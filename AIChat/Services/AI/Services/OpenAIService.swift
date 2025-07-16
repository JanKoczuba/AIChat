//
//  OpenAIService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

import OpenAI
import SwiftUI

private typealias ChatCompletion = ChatQuery.ChatCompletionMessageParam
private typealias SystemMessage = ChatQuery.ChatCompletionMessageParam.ChatCompletionSystemMessageParam
private typealias UserMessage = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam
private typealias UserTextContent = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.Content
private typealias AssistantMessage = ChatQuery.ChatCompletionMessageParam.ChatCompletionAssistantMessageParam

struct OpenAIService: AIService {

    var openAI: OpenAI {
        OpenAI(apiToken: Keys.openAI)
    }

    func generateImage(input: String) async throws -> UIImage {
        let query = ImagesQuery(
            prompt: input,
            //            model: .gpt4,
            n: 1,
            quality: .hd,
            responseFormat: .b64_json,
            size: ._512,
            style: .natural,
            user: nil
        )

        let result = try await openAI.images(query: query)

        guard let b64Json = result.data.first?.b64Json,
              let data = Data(base64Encoded: b64Json),
              let image = UIImage(data: data) else {
            throw OpenAIError.invalidResponse
        }

        return image
    }

    func generateText(chats: [AIChatModel]) async throws -> AIChatModel {
        let messages = chats.compactMap({ $0.toOpenAIModel() })
        let query = ChatQuery(messages: messages, model: .gpt3_5Turbo)
        let result = try await openAI.chats(query: query)

        guard
            let chat = result.choices.first?.message,
            let model = AIChatModel(chat: chat)
        else {
            throw OpenAIError.invalidResponse
        }

        return model
    }

    enum OpenAIError: LocalizedError {
        case invalidResponse
    }
}

struct AIChatModel: Codable {
    let role: AIChatRole
    let message: String

    init(role: AIChatRole, content: String) {
        self.role = role
        self.message = content
    }

    init?(chat: ChatResult.Choice.ChatCompletionMessage) {
        self.role = AIChatRole(role: chat.role)

        if let string = chat.content?.string {
            self.message = string
        } else {
            return nil
        }
    }

    fileprivate func toOpenAIModel() -> ChatCompletion? {
        switch role {
        case .system:
            return ChatCompletion.system(SystemMessage(content: message))
        case .user:
            return ChatCompletion.user(UserMessage(content: UserTextContent(string: message)))
        case .assistant:
            return ChatCompletion.assistant(AssistantMessage(content: message))
        case .tool:
            return nil
        }
    }
}

enum AIChatRole: String, Codable {
    case system, user, assistant, tool

    init(role: ChatQuery.ChatCompletionMessageParam.Role) {
        switch role {
        case .system:
            self = .system
        case .user:
            self = .user
        case .assistant:
            self = .assistant
        case .tool:
            self = .tool
        }
    }

    var openAIRole: ChatQuery.ChatCompletionMessageParam.Role {
        switch self {
        case .system:
            return .system
        case .user:
            return .user
        case .assistant:
            return .assistant
        case .tool:
            return .tool
        }
    }
}

