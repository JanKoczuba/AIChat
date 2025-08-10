//
//  OnboardingCompletedView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct OnboardingCompletedDelegate {
    var selectedColor: Color = .orange
}

struct OnboardingCompletedView: View {
    
    @State var presenter: OnboardingCompletedPresenter
    var delegate: OnboardingCompletedDelegate = OnboardingCompletedDelegate()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Setup complete!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(delegate.selectedColor)

            Text("We've set up your profile and you're ready to start chatting.")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            AsyncCallToActionButton(
                isLoading: presenter.isCompletingProfileSetup,
                title: "Finish",
                action: {
                    presenter.onFinishButtonPressed(selectedColor: delegate.selectedColor)
                }
            )
            .accessibilityIdentifier("FinishButton")
        })
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
        .screenAppearAnalytics(name: "OnboardingCompletedView")
    }
    
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container))
    
    return RouterView { router in
        builder.onboardingCompletedView(
            router: router,
            delegate: OnboardingCompletedDelegate(
                selectedColor: .mint
            )
        )
    }
    .previewEnvironment()
}
