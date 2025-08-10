//
//  OnboardingIntroRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol OnboardingIntroRouter {
    func showOnboardingCommunityView(delegate: OnboardingCommunityDelegate)
    func showOnboardingColorView(delegate: OnboardingColorDelegate)
}

extension CoreRouter: OnboardingIntroRouter { }
