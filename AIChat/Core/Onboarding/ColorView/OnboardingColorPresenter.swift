//
//  OnboardingColorPresenter.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI

@Observable
@MainActor
class OnboardingColorPresenter {
    
    private let interactor: OnboardingColorInteractor
    private let router: OnboardingColorRouter
    
    private(set) var selectedColor: Color?
    let profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan, .teal, .indigo]

    init(interactor: OnboardingColorInteractor, router: OnboardingColorRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onColorPressed(color: Color) {
        selectedColor = color
    }
    
    func onContinuePressed() {
        guard let selectedColor else { return }
        let delegate = OnboardingCompletedDelegate(selectedColor: selectedColor)
        router.showOnboardingCompletedView(delegate: delegate)
    }
}
