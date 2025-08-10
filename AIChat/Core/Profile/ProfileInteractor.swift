//
//  ProfileInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//

@MainActor
protocol ProfileInteractor {
    var currentUser: UserModel? { get }
    
    func getAuthId() throws -> String
    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel]
    func removeAuthorIdFromAvatar(avatarId: String) async throws
    func trackEvent(event: LoggableEvent)
}

extension CoreInteractor: ProfileInteractor { }

@MainActor
struct ProdProfileInteractor: ProfileInteractor {
    let authManager: AuthManager
    let userManager: UserManager
    let avatarManager: AvatarManager
    let logManager: LogManager

    init(container: DependencyContainer) {
        self.authManager = container.resolve(AuthManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.avatarManager = container.resolve(AvatarManager.self)!
        self.logManager = container.resolve(LogManager.self)!
    }

    var currentUser: UserModel? {
        userManager.currentUser
    }
    
    func getAuthId() throws -> String {
        try authManager.getAuthId()
    }
    
    func getAvatarsForAuthor(userId: String) async throws -> [AvatarModel] {
        try await avatarManager.getAvatarsForAuthor(userId: userId)
    }
    
    func removeAuthorIdFromAvatar(avatarId: String) async throws {
        try await avatarManager.removeAuthorIdFromAvatar(avatarId: avatarId)
    }
    
    func trackEvent(event: any LoggableEvent) {
        logManager.trackEvent(event: event)
    }

}
