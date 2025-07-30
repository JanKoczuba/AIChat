//
//  PurchaseManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//
import SwiftUI

protocol PurchaseService: Sendable {
    func listenForTransactions(onTransactionUpdated: @Sendable ([PurchasedEntitlement]) async -> Void) async
    func getUserEntitlements() async -> [PurchasedEntitlement]
}

struct MockPurchaseService: PurchaseService {

    let activeEntitlements: [PurchasedEntitlement]

    init(activeEntitlements: [PurchasedEntitlement] = []) {
        self.activeEntitlements = activeEntitlements
    }

    func listenForTransactions(onTransactionUpdated: ([PurchasedEntitlement]) async -> Void) async {
        await onTransactionUpdated(activeEntitlements)
    }

    func getUserEntitlements() async -> [PurchasedEntitlement] {
        activeEntitlements
    }
}

import StoreKit
struct StoreKitPurchaseService: PurchaseService {


    func listenForTransactions(onTransactionUpdated: ([PurchasedEntitlement]) async -> Void) async {
        for await update in StoreKit.Transaction.updates {
            if let transaction = try? update.payloadValue {
                let entitlements = await getUserEntitlements()
                await onTransactionUpdated(entitlements)

                await transaction.finish()
            }
        }
    }

    func getUserEntitlements() async -> [PurchasedEntitlement] {
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
            let entitlements = await service.getUserEntitlements()
            updateActiveEntitlements(entitlements: entitlements)
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
    
}

