//
//  AvatarManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

import SwiftUI

@MainActor
@Observable
class AvatarManager {

    private let local: LocalAvatarPersistence
    private let service: RemoteAvatarService

    init(service: RemoteAvatarService, local: LocalAvatarPersistence = MockLocalAvatarPersistence()) {
        self.service = service
        self.local = local
    }

    func addRecentAvatar(avatar: AvatarModel) async throws {
        try local.addRecentAvatar(avatar: avatar)
        try await service.incrementAvatarClickCount(avatarId: avatar.id)
    }

    func getRecentAvatars() throws -> [AvatarModel] {
        try local.getRecentAvatars()
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await service.getAvatar(id: id)
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        try await service.createAvatar(avatar: avatar, image: image)
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await service.getFeaturedAvatars()
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await service.getPopularAvatars()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel] {
        try await service.getAvatarsForCategory(category: category)
    }

    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel] {
        try await service.getAvatarsForAuthor(userId: userId)
    }

    func removeAuthorIdFromAvatar(avatarId: String) async throws {
        try await service.removeAuthorIdFromAvatar(avatarId: avatarId)
    }

    func removeAuthorIdFromAllUserAvatars(userId: String) async throws {
        try await service.removeAuthorIdFromAllUserAvatars(userId: userId)
    }

}
