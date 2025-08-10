//
//  WelcomeRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol WelcomeRouter {
    func showOnboardingIntroView(delegate: OnboardingIntroDelegate)
    func showCreateAccountView(delegate: CreateAccountDelegate, onDisappear: (() -> Void)?)
}

extension CoreRouter: WelcomeRouter { }
