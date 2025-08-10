//
//  OnboardingColorInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol OnboardingColorInteractor {
    func trackEvent(event: LoggableEvent)
}

extension CoreInteractor: OnboardingColorInteractor { }
