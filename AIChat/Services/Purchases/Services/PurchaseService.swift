//
//  PurchaseService.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/08/2025.
//

protocol PurchaseService: Sendable {
    func listenForTransactions(onTransactionUpdated: @Sendable ([PurchasedEntitlement]) async -> Void) async
    func getUserEntitlements() async throws -> [PurchasedEntitlement]
    func getProducts(productIds: [String]) async throws -> [AnyProduct]
    func restorePurchase() async throws -> [PurchasedEntitlement]
    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement]
    func logIn(userId: String) async throws -> [PurchasedEntitlement]
    func updateProfileAttributes(attributes: PurchaseProfileAttributes) async throws
    func logOut() async throws
}
