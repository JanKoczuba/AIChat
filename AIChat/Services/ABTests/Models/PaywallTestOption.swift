//
//  PaywallTestOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/08/2025.
//

import SwiftUI

enum PaywallTestOption: String, Codable, CaseIterable {
    case storeKit, custom, revenueCat
    
    static var `default`: Self {
        .storeKit
    }
}
