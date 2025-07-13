//
//  OnboardingCompletedView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct OnboardingCompletedView: View {

    @Environment(AppState.self) private var root
    @Environment(UserManager.self) private var userManager

    @State private var isCompletingProfileSetup: Bool = false

    var selectedColor: Color = .accent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Setup complete!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(selectedColor)

            Text(
                "We've set up your profile and you're ready to start chatting."
            )
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)

        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(
            edge: .bottom,
            content: {
                ctaButton
            }
        )
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var ctaButton: some View {
        AsyncCallToActionButton(
            isLoading: isCompletingProfileSetup,
            title: "Finish",
            action: onFinishButtonPressed
        )
    }

    func onFinishButtonPressed() {
        isCompletingProfileSetup = true
        Task {
            let hex = selectedColor.asHex()
            try await userManager.markOnboardingCompletedForCurrentUser(
                profileColorHex: hex
            )

            //dismiss screen
            isCompletingProfileSetup = false
            root.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    OnboardingCompletedView(selectedColor: .accent)
        .environment(UserManager(services: MockUserServices()))
        .environment(AppState())
}
