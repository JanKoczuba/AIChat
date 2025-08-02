//
//  EntitlementOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 02/08/2025.
//

enum EntitlementOption: Codable, CaseIterable {
    case yearly
    
    var productId: String {
        switch self {
        case .yearly:
            return "koczuba.AIChat.yearly"
        }
    }
    
    static var allProductIds: [String] {
        EntitlementOption.allCases.map({ $0.productId })
    }
}
