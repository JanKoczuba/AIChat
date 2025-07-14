//
//  UserServices.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

protocol UserServices {
    var remote: RemoteUserService { get }
    var local: LocalUserPersistence { get }
}

struct MockUserServices: UserServices {
    let remote: RemoteUserService
    let local: LocalUserPersistence

    init(user: UserModel? = nil) {
        self.remote = MockUserService(user: user)
        self.local = MockUserPersistence(user: user)
    }

}

struct ProductionUserServices: UserServices {
    let remote: RemoteUserService = FirebaseUserService()
    let local: LocalUserPersistence = FileManagerUserPersistence()
}
