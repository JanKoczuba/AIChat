//
//  PurchasedEntitlement+RevenueCat.swift
//  AIChat
//
//  Created by Jan Koczuba on 02/08/2025.
//

import RevenueCat

extension Dictionary where Key == String, Value == EntitlementInfo {

    func asPurchasedEntitlements() -> [PurchasedEntitlement] {
        map({ PurchasedEntitlement(entitlement: $0.value) })
    }

}

extension PurchasedEntitlement {

    init(entitlement: EntitlementInfo) {
        self.init(
            productId: entitlement.productIdentifier,
            expirationDate: entitlement.expirationDate,
            isActive: entitlement.isActive,
            originalPurchaseDate: entitlement.originalPurchaseDate,
            latestPurchaseDate: entitlement.latestPurchaseDate,
            ownershipType: EntitlementOwnershipOption(type: entitlement.ownershipType),
            isSandbox: entitlement.isSandbox,
            isVerified: entitlement.verification.isVerified
        )
    }

}

extension EntitlementOwnershipOption {

    init(type: PurchaseOwnershipType) {
        switch type {
        case .purchased:
            self = .purchased
        case .familyShared:
            self = .familyShared
        case .unknown:
            self = .unknown
        }
    }
}
