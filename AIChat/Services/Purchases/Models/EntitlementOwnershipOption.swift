//
//  EntitlementOwnershipOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//


import SwiftUI

public enum EntitlementOwnershipOption: Codable, Sendable {
    case purchased, familyShared, unknown
}

import StoreKit

extension EntitlementOwnershipOption {

    init(type: StoreKit.Transaction.OwnershipType) {
        switch type {
        case .purchased:
            self = .purchased
        case .familyShared:
            self = .familyShared
        default:
            self = .unknown
        }
    }
}
