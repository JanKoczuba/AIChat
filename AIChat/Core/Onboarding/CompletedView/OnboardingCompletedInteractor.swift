//
//  OnboardingCompletedInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol OnboardingCompletedInteractor {
    func trackEvent(event: LoggableEvent)
    func markOnboardingCompleteForCurrentUser(profileColorHex: String) async throws
    func updateAppState(showTabBarView: Bool)
}

extension CoreInteractor: OnboardingCompletedInteractor { }
