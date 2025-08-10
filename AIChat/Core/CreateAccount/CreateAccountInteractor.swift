//
//  CreateAccountInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol CreateAccountInteractor {
    func trackEvent(event: LoggableEvent)
    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool)
    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws
}

extension CoreInteractor: CreateAccountInteractor { }
