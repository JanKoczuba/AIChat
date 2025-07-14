//
//  MockUserPersistence.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//



struct MockUserPersistence: LocalUserPersistence {
    let currentUser: UserModel?

    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    func getCurrentUser() -> UserModel? {
        currentUser
    }

    func saveCurrentUser(user: UserModel?) throws {
    }
}
