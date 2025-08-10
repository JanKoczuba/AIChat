//
//  ProfileRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol ProfileRouter {
    func showSettingsView()
    func showCreateAvatarView(onDisappear: @escaping () -> Void)
    func showChatView(delegate: ChatViewDelegate)
    func showSimpleAlert(title: String, subtitle: String?)
}

extension CoreRouter: ProfileRouter { }
