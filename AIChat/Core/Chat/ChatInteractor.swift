//
//  ChatInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//
@MainActor
protocol ChatInteractor {
    var currentUser: UserModel? { get }
    var auth: UserAuthInfo? { get }
    var isPremium: Bool { get }
    
    func getAuthId() throws -> String
    func trackEvent(event: LoggableEvent)
    
    // Avatar methods
    func getAvatar(id: String) async throws -> AvatarModel
    func addRecentAvatar(avatar: AvatarModel) async throws
    
    // Chat methods
    func getChat(userId: String, avatarId: String) async throws -> ChatModel?
    func streamChatMessages(chatId: String) -> AsyncThrowingStream<[ChatMessageModel], Error>
    func markChatMessageAsSeen(chatId: String, messageId: String, userId: String) async throws
    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    func createNewChat(chat: ChatModel) async throws
    func reportChat(chatId: String, userId: String) async throws
    func deleteChat(chatId: String) async throws

    // AI Methods
    func generateText(chats: [AIChatModel]) async throws -> AIChatModel
}

extension CoreInteractor: ChatInteractor { }
