//
//  ChatManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 15/07/2025.
//

import FirebaseFirestore
import SwiftfulFirestore

protocol ChatService: Sendable {
    func createNewChat(chat: ChatModel) async throws
    func getChat(userId: String, avatarId: String) async throws -> ChatModel?
    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    func streamChatMessages(chatId: String) -> AsyncThrowingStream<
        [ChatMessageModel], Error
    >
}

struct MockChatService: ChatService {
    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        ChatModel.mock
    }

    func createNewChat(chat: ChatModel) async throws {

    }

    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    {

    }
    func streamChatMessages(chatId: String) -> AsyncThrowingStream<
        [ChatMessageModel], Error
    > {
        AsyncThrowingStream { continuation in

        }
    }
}

struct FirebaseChatService: ChatService {

    private var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        try await collection.getDocument(
            id: ChatModel.chatId(userId: userId, avatarId: avatarId)
        )
    }

    private func messagesCollection(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("messages")
    }

    func createNewChat(chat: ChatModel) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }

    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    {
        // Add the message to chat sub-collection
        try messagesCollection(chatId: chatId).document(message.id).setData(
            from: message,
            merge: true
        )

        // Update chat dateModified
        try await collection.document(chatId).updateData([
            ChatModel.CodingKeys.dateModified.rawValue: Date.now
        ])
    }

    func streamChatMessages(chatId: String) -> AsyncThrowingStream<
        [ChatMessageModel], any Error
    > {
        messagesCollection(chatId: chatId).streamAllDocuments()
    }

}

@MainActor
@Observable
class ChatManager {

    private let service: ChatService

    init(service: ChatService) {
        self.service = service
    }

    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        try await service.getChat(userId: userId, avatarId: avatarId)
    }

    func createNewChat(chat: ChatModel) async throws {
        try await service.createNewChat(chat: chat)
    }

    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    {
        try await service.addChatMessage(chatId: chatId, message: message)
    }

    func streamChatMessages(
        chatId: String,
    ) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        service.streamChatMessages(
            chatId: chatId,
        )
    }
}
