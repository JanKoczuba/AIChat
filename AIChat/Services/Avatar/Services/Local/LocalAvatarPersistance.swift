//
//  LocalAvatarPersistence.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

@MainActor
protocol LocalAvatarPersistence {
    func addRecentAvatar(avatar: AvatarModel) throws
    func getRecentAvatars() throws -> [AvatarModel]
}
