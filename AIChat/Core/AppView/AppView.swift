//
//  AppView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct AppView: View {

    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
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
        if let user = authManager.auth {
            print("User already authenticated: \(user.uid)")

            do {
                try await userManager.longIn(auth: user, isNewUser: false)
            } catch {
                print("Failed to log in to authfor existing user: \(error)")
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }

        } else {
            do {
                let result = try await authManager.signInAnonymously()

                print("Sign in anonymous success: \(result.user.uid)")

                try await userManager.longIn(
                    auth: result.user,
                    isNewUser: result.isNewUser
                )

            } catch {
                print(error)
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
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
