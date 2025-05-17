//
//  AppView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct AppView: View {
    @AppStorage("showTabbarView") var showTabBar: Bool = false

    var body: some View {
        AppViewBuilder(
            showTabBar: showTabBar,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
    }
}

#Preview("AppView - Tabar") {
    AppView(showTabBar: true)
}

#Preview("AppView - Onboarding") {
    AppView(showTabBar: false)
}
