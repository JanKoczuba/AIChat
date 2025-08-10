//
//  PaywallRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//

@MainActor
protocol PaywallRouter {
    func dismissScreen()
    func showAlert(error: Error)
}

extension CoreRouter: PaywallRouter { }
