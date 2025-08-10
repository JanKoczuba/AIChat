//
//  OnboardingCommunityPresenter.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI

@Observable
@MainActor
class OnboardingCommunityPresenter {
    
    private let interactor: OnboardingCommunityInteractor
    private let router: OnboardingCommunityRouter

    init(interactor: OnboardingCommunityInteractor, router: OnboardingCommunityRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onContinueButtonPressed() {
        router.showOnboardingColorView(delegate: OnboardingColorDelegate())
    }
}
