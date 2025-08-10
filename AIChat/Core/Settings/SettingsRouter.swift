//
//  SettingsRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


import SwiftUI

@MainActor
protocol SettingsRouter {
    func showCreateAccountView(delegate: CreateAccountDelegate, onDisappear: (() -> Void)?)
    func dismissScreen()
    
    func showAlert(error: Error)
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?)
    
    func showRatingsModal(onYesPressed: @escaping () -> Void, onNoPressed: @escaping () -> Void)
    func dismissModal()
}

extension CoreRouter: SettingsRouter { }
