//
//  MockLocalAvatarPersistence.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

@MainActor
struct MockLocalAvatarPersistence: LocalAvatarPersistence {

    let avatars: [AvatarModel]

    init(avatars: [AvatarModel] = AvatarModel.mocks) {
        self.avatars = avatars
    }

    func addRecentAvatar(avatar: AvatarModel) throws {

    }

    func getRecentAvatars() throws -> [AvatarModel] {
        avatars
    }
}
