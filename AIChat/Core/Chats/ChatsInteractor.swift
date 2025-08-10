//
//  ChatsInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//
@MainActor
protocol ChatsInteractor {
    func trackEvent(event: LoggableEvent)
    func getRecentAvatars() throws -> [AvatarModel]
    func getAuthId() throws -> String
    func getAllChats(userId: String) async throws -> [ChatModel]
}

extension CoreInteractor: ChatsInteractor { }
