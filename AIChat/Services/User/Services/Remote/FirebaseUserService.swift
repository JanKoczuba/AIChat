//
//  FirebaseUserService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseUserService: RemoteUserService {

    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    func saveUser(user: UserModel) async throws {
        try collection.document(user.userId).setData(
            from: user,
            merge: true
        )
    }

    func markOnboardingCompleted(userId: String, profileColorHex: String)
        async throws
    {
        try await collection.document(userId).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
            UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex,
        ])
    }

    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        collection.streamDocument(id: userId)
    }

    func deleteUser(userId: String) async throws {
        try await collection.document(userId).delete()
    }
}
