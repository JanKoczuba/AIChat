//
//  MockLocalAvatarPersistence.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

@MainActor
struct MockLocalAvatarPersistence: LocalAvatarPersistence {
    func addRecentAvatar(avatar: AvatarModel) throws {
    }
    func getRecentAvatars() throws -> [AvatarModel] {
        AvatarModel.mocks.shuffled()
    }
}
