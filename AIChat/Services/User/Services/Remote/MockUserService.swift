//
//  MockUserService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

struct MockUserService: RemoteUserService {

    let currentUser: UserModel?

    init(user: UserModel? = nil) {
        self.currentUser = user
    }

    func saveUser(user: UserModel) async throws {

    }

    func markOnboardingCompleted(userId: String, profileColorHex: String)
        async throws
    {}

    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        AsyncThrowingStream { continuation in
            if let currentUser {
                continuation.yield(currentUser)
            }
        }
    }

    func deleteUser(userId: String) async throws {

    }

}
