//
//  OnboardingCompletedRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol OnboardingCompletedRouter {
    func showAlert(error: Error)
}

extension CoreRouter: OnboardingCompletedRouter { }
