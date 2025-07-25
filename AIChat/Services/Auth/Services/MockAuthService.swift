//
//  MockAuthService.swift
//  AIChat
//
//  Created by Jan Koczuba on 12/07/2025.
//

import Foundation

struct MockAuthService: AuthService {

    let currentUser: UserAuthInfo?

    init(user: UserAuthInfo? = nil) {
        self.currentUser = user
    }

    func addAuthenticatedUserListaner(
        onListenerAttached: (any NSObjectProtocol) -> Void
    ) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            continuation.yield(currentUser)

        }
    }
    func removeAuthenticatedUserListener(listener: any NSObjectProtocol) {

    }

    func getAuthenticatedUser() -> UserAuthInfo? {
        currentUser
    }

    func signInAnonymously() async throws -> (
        user: UserAuthInfo, isNewUser: Bool
    ) {
        let user = UserAuthInfo.mock(isAnonymous: true)
        return (user, true)
    }

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        return (user, false)
    }

    func signOut() throws {

    }

    func deleteAccount() async throws {

    }

}
