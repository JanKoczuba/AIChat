//
//  OnboardingIntroPresenter.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI

@Observable
@MainActor
class OnboardingIntroPresenter {
    
    private let interactor: OnboardingIntroInteractor
    private let router: OnboardingIntroRouter

    init(interactor: OnboardingIntroInteractor, router: OnboardingIntroRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onContinueButtonPressed() {
        if interactor.onboardingCommunityTest {
            router.showOnboardingCommunityView(delegate: OnboardingCommunityDelegate())
        } else {
            router.showOnboardingColorView(delegate: OnboardingColorDelegate())
        }
    }
}
