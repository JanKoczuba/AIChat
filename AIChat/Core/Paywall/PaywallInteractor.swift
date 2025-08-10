//
//  PaywallInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol PaywallInteractor {
    var paywallTest: PaywallTestOption { get }
    
    func trackEvent(event: LoggableEvent)
    func getProducts(productIds: [String]) async throws -> [AnyProduct]
    func restorePurchase() async throws -> [PurchasedEntitlement]
    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement]
}

extension CoreInteractor: PaywallInteractor { }
