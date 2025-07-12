//
//  AuthService.swift
//  AIChat
//
//  Created by Jan Koczuba on 12/07/2025.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var authService: AuthService = MockAuthService()
}

protocol AuthService: Sendable {

    func getAuthenticatedUser() -> UserAuthInfo?

    func signInAnonymously() async throws -> (
        user: UserAuthInfo, isNewUser: Bool
    )

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool)

    func signOut() throws

    func deleteAccount() async throws

}
