//
//  RemoteUserService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error>
    func deleteUser(userId: String) async throws
    func markOnboardingCompleted(userId: String, profileColorHex: String)
        async throws
}
