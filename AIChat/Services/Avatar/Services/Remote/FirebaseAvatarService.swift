//
//  FirebaseAvatarService.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/07/2025.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseAvatarService: RemoteAvatarService {

    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }

    func getAvatar(id: String) async throws -> AvatarModel {
        try await collection.getDocument(id: id)
    }

    func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
        let path = "avatars/\(avatar.avatarId)"
        let url = try await FirebaseImageUploadService().uploadImage(
            image: image,
            path: path
        )

        // Update avatar image name
        var avatar = avatar
        avatar.updateProfileImage(imageName: url.absoluteString)

        // Upload the avatar
        try collection.document(avatar.avatarId).setData(
            from: avatar,
            merge: true
        )
    }

    func getFeaturedAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 50)
            .getAllDocuments()
            .shuffled()
            .first(upTo: 5) ?? []
    }

    func getPopularAvatars() async throws -> [AvatarModel] {
        try await collection
            .limit(to: 200)
            .getAllDocuments()
    }

    func getAvatarsForCategory(category: CharacterOption) async throws
        -> [AvatarModel]
    {
        try await collection
            .whereField(
                AvatarModel.CodingKeys.characterOption.rawValue,
                isEqualTo: category.rawValue
            )
            .limit(to: 200)
            .getAllDocuments()
    }

    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel] {
        try await collection
            .whereField(
                AvatarModel.CodingKeys.authorId.rawValue,
                isEqualTo: userId
            )
            .getAllDocuments()
    }

}
