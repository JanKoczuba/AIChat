//
//  ExploreRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol ExploreRouter {
    // Segues
    func showCategoryListView(delegate: CategoryListDelegate)
    func showChatView(delegate: ChatViewDelegate)
    func showCreateAccountView(delegate: CreateAccountDelegate, onDisappear: (() -> Void)?)
    func showDevSettingsView()
    
    // Modals
    func showPushNotificationModal(onEnablePressed: @escaping () -> Void, onCancelPressed: @escaping () -> Void)
    func dismissModal()
}
extension CoreRouter: ExploreRouter { }
