//
//  ExploreInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol ExploreInteractor {
    var categoryRowTest: CategoryRowTestOption { get }
    var createAccountTest: Bool { get }
    var auth: UserAuthInfo? { get }

    func trackEvent(event: LoggableEvent)
    func schedulePushNotificationsForTheNextWeek()
    func canRequestAuthorization() async -> Bool
    func requestAuthorization() async throws -> Bool
    func getFeaturedAvatars() async throws -> [AvatarModel]
    func getPopularAvatars() async throws -> [AvatarModel]
}

extension CoreInteractor: ExploreInteractor { }
