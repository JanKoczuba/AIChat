//
//  AppView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct AppView: View {

    @Environment(\.authService) private var authService
    @State var appState: AppState = AppState()

    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            if !showTabBar {
                Task {
                    await checkUserStatus()
                }
            }
        }
    }
    private func checkUserStatus() async {
        if let user = authService.getAuthenticatedUser() {
            print("User already authenticated: \(user.uid)")

        } else {
            do {
                let result = try await authService.signInAnonymously()

                print("Sign in anonymous success: \(result.user.uid)")
            } catch {
                print(error)

            }
        }
    }
}

#Preview("AppView - Tabar") {
    AppView(appState: AppState(showTabBarView: true))
}

#Preview("AppView - Onboarding") {
    AppView(appState: AppState(showTabBarView: false))
}
