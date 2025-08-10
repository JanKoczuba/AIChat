//
//  OnboardingCommunityRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol OnboardingCommunityRouter {
    func showOnboardingColorView(delegate: OnboardingColorDelegate)
}

extension CoreRouter: OnboardingCommunityRouter { }
