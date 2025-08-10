//
//  OnboardingIntroViewModel.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI

@MainActor
protocol OnboardingIntroInteractor {
    var onboardingCommunityTest: Bool { get }

    func trackEvent(event: LoggableEvent)
}

extension CoreInteractor: OnboardingIntroInteractor { }

@Observable
@MainActor
class OnboardingIntroViewModel {
    
    private let interactor: OnboardingIntroInteractor
    
    init(interactor: OnboardingIntroInteractor) {
        self.interactor = interactor
    }
    
    func onContinueButtonPressed(path: Binding<[OnboardingPathOption]>) {
        if interactor.onboardingCommunityTest {
            path.wrappedValue.append(.communityView)
        } else {
            path.wrappedValue.append(.colorView)
        }
    }
}
