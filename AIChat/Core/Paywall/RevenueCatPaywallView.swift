//
//  RevenueCatPaywallView.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/08/2025.
//
import SwiftUI
import RevenueCat
import RevenueCatUI

struct RevenueCatPaywallView: View {
    var body: some View {
        RevenueCatUI.PaywallView(displayCloseButton: true)
    }
}

#Preview {
    RevenueCatPaywallView()
}
