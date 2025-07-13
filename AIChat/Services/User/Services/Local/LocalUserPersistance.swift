//
//  LocalUserPersistance.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//


protocol LocalUserPersistance {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel?) throws
}


