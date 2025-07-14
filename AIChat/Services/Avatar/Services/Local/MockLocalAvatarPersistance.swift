//
//  MockLocalAvatarPersistance.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

@MainActor
struct MockLocalAvatarPersistance: LocalAvatarPersistance {
    func addRecentAvatar(avatar: AvatarModel) throws {
    }
    func getRecentAvatars() throws -> [AvatarModel] {
        AvatarModel.mocks.shuffled()
    }
}
