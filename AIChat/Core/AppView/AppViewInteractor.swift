//
//  AppViewInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol AppViewInteractor {
    var auth: UserAuthInfo? { get }
    var showTabBar: Bool { get }
    
    func trackEvent(event: LoggableEvent)
    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool)
}

extension CoreInteractor: AppViewInteractor { }
