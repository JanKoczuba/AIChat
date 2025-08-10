//
//  ChatsRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol ChatsRouter {
    func showChatView(delegate: ChatViewDelegate)
}

extension CoreRouter: ChatsRouter { }
