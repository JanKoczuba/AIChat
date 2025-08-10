//
//  ChatRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//

import SwiftUI

@MainActor
protocol ChatRouter {
    func showPaywallView()
    func dismissScreen()
    
    func showAlert(error: Error)
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?)
    func showProfileModal(avatar: AvatarModel, onXMarkPressed: @escaping () -> Void)
    func dismissModal()
}

extension CoreRouter: ChatRouter { }
