//
//  OnboardingColorRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol OnboardingColorRouter {
    func showOnboardingCompletedView(delegate: OnboardingCompletedDelegate)
}

extension CoreRouter: OnboardingColorRouter { }
