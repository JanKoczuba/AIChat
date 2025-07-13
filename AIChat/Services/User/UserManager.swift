//
//  UserManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 12/07/2025.
//

import SwiftUI

@MainActor
@Observable
class UserManager {

    private let remote: RemoteUserService
    private let local: LocalUserPersistance
    private(set) var currentUser: UserModel?

    init(services: UserServices) {
        self.remote = services.remote
        self.local = services.local
        self.currentUser = local.getCurrentUser()
    }

    func longIn(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, creationVersion: creationVersion)
        try await remote.saveUser(user: user)
        addCurrentUserListener(userId: auth.uid)
    }

    private func addCurrentUserListener(userId: String) {
        Task {
            do {
                for try await value in remote.streamUser(userId: userId) {
                    self.currentUser = value
                    self.saveCurrentUserLocaly()
                    print("Fully listen to user: \(value.userId)")
                }
            } catch {
                print("Error attaching user listener \(error)")
            }
        }
    }

    private func saveCurrentUserLocaly() {
        Task {
            do {
                try local.saveCurrentUser(user: currentUser)
                print("Success saved current user locally")

            } catch {
                print("Error saving current user locally: \(error)")
            }
        }
    }

    func markOnboardingCompletedForCurrentUser(profileColorHex: String)
        async throws
    {
        let uid = try currentUserId()
        try await remote.markOnboardingCompleted(
            userId: uid,
            profileColorHex: profileColorHex
        )
    }

    func signOut() {
        currentUser = nil
    }
    func deleteCurrentUser() async throws {
        let uid = try currentUserId()
        try await remote.deleteUser(userId: uid)
        signOut()
    }

    private func currentUserId() throws -> String {
        guard let uid = currentUser?.userId else {
            throw UserManagerError.noUserId
        }
        return uid
    }

    enum UserManagerError: LocalizedError {
        case noUserId
    }
}
