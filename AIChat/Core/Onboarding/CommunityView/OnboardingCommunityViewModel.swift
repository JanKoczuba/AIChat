//
//  OnboardingCommunityViewModel.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI

@MainActor
protocol OnboardingCommunityInteractor {
    func trackEvent(event: LoggableEvent)
}

extension CoreInteractor: OnboardingCommunityInteractor { }

@Observable
@MainActor
class OnboardingCommunityViewModel {
    
    private let interactor: OnboardingCommunityInteractor
    
    init(interactor: OnboardingCommunityInteractor) {
        self.interactor = interactor
    }
    
    func onContinueButtonPressed(path: Binding<[OnboardingPathOption]>) {
        path.wrappedValue.append(.colorView)
    }
}
