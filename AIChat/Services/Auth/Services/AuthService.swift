//
//  AuthService.swift
//  AIChat
//
//  Created by Jan Koczuba on 12/07/2025.
//

import SwiftUI

protocol AuthService: Sendable {

    func addAuthenticatedUserListaner(
        onListenerAttached: (any NSObjectProtocol) -> Void
    ) -> AsyncStream<UserAuthInfo?>

    func removeAuthenticatedUserListener(listener: any NSObjectProtocol)

    func getAuthenticatedUser() -> UserAuthInfo?

    func signInAnonymously() async throws -> (
        user: UserAuthInfo, isNewUser: Bool
    )

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool)

    func signOut() throws

    func deleteAccount() async throws

}
