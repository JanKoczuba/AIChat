//
//  CategoryListRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//
@MainActor
protocol CategoryListRouter {
    func showChatView(delegate: ChatViewDelegate)
    func showAlert(error: Error)
}

extension CoreRouter: CategoryListRouter { }
