//
//  OnboardingPathOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI
import Foundation

enum OnboardingPathOption: Hashable {
    case colorView
    case communityView
    case introView
    case completedView(selectedColor: Color)
}

struct NavDestForOnboardingModuleViewModifier: ViewModifier {
    
    @Environment(CoreBuilder.self) private var builder
    let path: Binding<[OnboardingPathOption]>
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: OnboardingPathOption.self) { newValue in
                switch newValue {
                case .colorView:
                    builder.onboardingColorView(delegate: OnboardingColorDelegate(path: path))
                case .communityView:
                    builder.onboardingCommunityView(delegate: OnboardingCommunityDelegate(path: path))
                case .introView:
                    builder.onboardingIntroView(delegate: OnboardingIntroDelegate(path: path))
                case .completedView(selectedColor: let selectedColor):
                    builder.onboardingCompletedView(delegate: OnboardingCompletedDelegate(selectedColor: selectedColor))
                }
            }
    }
}

extension View {
    
    func navigationDestinationForOnboardingModule(path: Binding<[OnboardingPathOption]>) -> some View {
        modifier(NavDestForOnboardingModuleViewModifier(path: path))
    }
}
