//
//  OnboardingIntroInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol OnboardingIntroInteractor {
    var onboardingCommunityTest: Bool { get }
    
    func trackEvent(event: LoggableEvent)
}

extension CoreInteractor: OnboardingIntroInteractor { }
