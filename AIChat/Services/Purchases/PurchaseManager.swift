//
//  PurchaseManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//
import SwiftUI

protocol PurchaseService: Sendable {
    func listenForTransactions(onTransactionUpdated: @Sendable ([PurchasedEntitlement]) async -> Void) async
    func getUserEntitlements() async throws -> [PurchasedEntitlement]
    func getProducts(productIds: [String]) async throws -> [AnyProduct]
    func restorePurchase() async throws -> [PurchasedEntitlement]
    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement]
}

struct MockPurchaseService: PurchaseService {

    let activeEntitlements: [PurchasedEntitlement]

    init(activeEntitlements: [PurchasedEntitlement] = []) {
        self.activeEntitlements = activeEntitlements
    }

    func listenForTransactions(onTransactionUpdated: ([PurchasedEntitlement]) async -> Void) async {
        await onTransactionUpdated(activeEntitlements)
    }

    func getUserEntitlements() async throws -> [PurchasedEntitlement] {
        activeEntitlements
    }

    func getProducts(productIds: [String]) async throws -> [AnyProduct] {
        return AnyProduct.mocks.filter { product in
            return productIds.contains(product.id)
        }
    }

    func restorePurchase() async throws -> [PurchasedEntitlement] {
        activeEntitlements
    }

    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        activeEntitlements
    }
}

import StoreKit
struct StoreKitPurchaseService: PurchaseService {

    func listenForTransactions(onTransactionUpdated: ([PurchasedEntitlement]) async -> Void) async {
        for await update in StoreKit.Transaction.updates {
            if let transaction = try? update.payloadValue {
                await transaction.finish()

                if let entitlements = try? await getUserEntitlements() {
                    await onTransactionUpdated(entitlements)
                }
            }
        }
    }

    func getUserEntitlements() async throws -> [PurchasedEntitlement] {
        var activeTransactions: [PurchasedEntitlement] = []

        for await verificationResult in StoreKit.Transaction.currentEntitlements {

            switch verificationResult {
            case .verified(let transaction):
                let isActive: Bool
                if let expirationDate = transaction.expirationDate {
                    isActive = expirationDate >= Date.now
                } else {
                    isActive = transaction.revocationDate == nil
                }

                activeTransactions.append(
                    PurchasedEntitlement(
                        productId: transaction.productID,
                        expirationDate: transaction.expirationDate,
                        isActive: isActive,
                        originalPurchaseDate: transaction.originalPurchaseDate,
                        latestPurchaseDate: transaction.purchaseDate,
                        ownershipType: EntitlementOwnershipOption(type: transaction.ownershipType),
                        isSandbox: transaction.environment == .sandbox,
                        isVerified: true
                    )
                )
            case .unverified:
                break
            }

        }

        return activeTransactions
    }

    func getProducts(productIds: [String]) async throws -> [AnyProduct] {
        let products = try await Product.products(for: productIds)
        return products.compactMap({ AnyProduct(storeKitProduct: $0) })
    }

    func restorePurchase() async throws -> [PurchasedEntitlement] {
        try await AppStore.sync()
        return try await getUserEntitlements()
    }

    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        let products = try await Product.products(for: [productId])

        guard let product = products.first else {
            throw PurchaseError.productNotFound
        }

        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            let transaction = try verificationResult.payloadValue
            await transaction.finish()

            return try await getUserEntitlements()
        case .userCancelled:
            throw PurchaseError.userCancelledPurchase
        default:
            throw PurchaseError.failedToPurchase
        }
    }
}

enum PurchaseError: LocalizedError {
    case productNotFound, userCancelledPurchase, failedToPurchase
}

import RevenueCat
struct RevenueCatPurchaseService: PurchaseService {

    init(apiKey: String, logLevel: LogLevel = .warn) {
        Purchases.configure(withAPIKey: apiKey)
        Purchases.logLevel = logLevel
        Purchases.shared.attribution.collectDeviceIdentifiers()
    }

    func listenForTransactions(onTransactionUpdated: @Sendable ([PurchasedEntitlement]) async -> Void) async {
        for await customerInfo in Purchases.shared.customerInfoStream {
            let entitlements = customerInfo.entitlements.all.asPurchasedEntitlements()
            await onTransactionUpdated(entitlements)
        }
    }

    func getUserEntitlements() async throws -> [PurchasedEntitlement] {
        let customerInfo = try await Purchases.shared.customerInfo()
        let entitlements = customerInfo.entitlements.all.asPurchasedEntitlements()
        return entitlements
    }

    func getProducts(productIds: [String]) async throws -> [AnyProduct] {
        let products = await Purchases.shared.products(productIds)
        return products.map({ AnyProduct(revenueCatProduct: $0) })
    }

    func restorePurchase() async throws -> [PurchasedEntitlement] {
        let customerInfo = try await Purchases.shared.restorePurchases()
        let entitlements = customerInfo.entitlements.all.asPurchasedEntitlements()
        return entitlements
    }

    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        let products = await Purchases.shared.products([productId])

        guard let product = products.first else {
            throw PurchaseError.productNotFound
        }

        let result = try await Purchases.shared.purchase(product: product)
        let customerInfo = result.customerInfo
        let entitlements = customerInfo.entitlements.all.asPurchasedEntitlements()
        return entitlements
    }
}

@MainActor
@Observable
class PurchaseManager {

    private let service: PurchaseService
    private let logManager: LogManager?

    /// User's pruchased entitlements, sorted by most recent
    private(set) var entitlements: [PurchasedEntitlement] = []

    init(service: PurchaseService, logManager: LogManager? = nil) {
        self.service = service
        self.logManager = logManager
        self.configure()
    }

    private func configure() {
        Task {
            if let entitlements = try? await service.getUserEntitlements() {
                updateActiveEntitlements(entitlements: entitlements)
            }
        }
        Task {
            await service.listenForTransactions { entitlements in
                await updateActiveEntitlements(entitlements: entitlements)
            }
        }
    }

    private func updateActiveEntitlements(entitlements: [PurchasedEntitlement]) {
        self.entitlements = entitlements.sortedByKeyPath(keyPath: \.expirationDateCalc, ascending: false)
        logManager?.addUserProperties(dict: entitlements.eventParameters, isHighPriority: false)
    }

    func getProducts(productIds: [String]) async throws -> [AnyProduct] {
        logManager?.trackEvent(event: Event.getProductsStart)

        do {
            let products = try await service.getProducts(productIds: productIds)
            logManager?.trackEvent(event: Event.getProductsSuccess(products: products))
            return products
        } catch {
            logManager?.trackEvent(event: Event.getProductsFail(error: error))
            throw error
        }
    }

    func restorePurchase() async throws -> [PurchasedEntitlement] {
        logManager?.trackEvent(event: Event.restorePurchaseStart)

        do {
            let entitlements = try await service.restorePurchase()
            logManager?.trackEvent(event: Event.restorePurchaseSuccess(entitlements: entitlements))
            updateActiveEntitlements(entitlements: entitlements)
            return entitlements
        } catch {
            logManager?.trackEvent(event: Event.restorePurchaseFail(error: error))
            throw error
        }
    }

    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        logManager?.trackEvent(event: Event.purchaseStart)

        do {
            let entitlements = try await service.purchaseProduct(productId: productId)
            logManager?.trackEvent(event: Event.purchaseSuccess(entitlements: entitlements))
            updateActiveEntitlements(entitlements: entitlements)
            return entitlements
        } catch {
            logManager?.trackEvent(event: Event.purchaseFail(error: error))
            throw error
        }
    }

    enum Event: LoggableEvent {
        case purchaseStart
        case purchaseSuccess(entitlements: [PurchasedEntitlement])
        case purchaseFail(error: Error)
        case restorePurchaseStart
        case restorePurchaseSuccess(entitlements: [PurchasedEntitlement])
        case restorePurchaseFail(error: Error)
        case getProductsStart
        case getProductsSuccess(products: [AnyProduct])
        case getProductsFail(error: Error)

        var eventName: String {
            switch self {
            case .purchaseStart:            return "PurMan_Purchase_Start"
            case .purchaseSuccess:          return "PurMan_Purchase_Success"
            case .purchaseFail:             return "PurMan_Purchase_Fail"
            case .restorePurchaseStart:     return "PurMan_Restore_Start"
            case .restorePurchaseSuccess:   return "PurMan_Restore_Success"
            case .restorePurchaseFail:      return "PurMan_Restore_Fail"
            case .getProductsStart:         return "PurMan_GetProducts_Start"
            case .getProductsSuccess:       return "PurMan_GetProducts_Success"
            case .getProductsFail:          return "PurMan_GetProducts_Fail"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .purchaseSuccess(entitlements: let entitlements), .restorePurchaseSuccess(entitlements: let entitlements):
                return entitlements.eventParameters
            case .getProductsSuccess(products: let products):
                return products.eventParameters
            case .purchaseFail(error: let error), .getProductsFail(error: let error), .restorePurchaseFail(error: let error):
                return error.eventParameters
            default:
                return nil
            }
        }

        var type: LogType {
            switch self {
            case .purchaseFail, .getProductsFail, .restorePurchaseFail:
                return .severe
            default:
                return .analytic
            }
        }
    }
}

