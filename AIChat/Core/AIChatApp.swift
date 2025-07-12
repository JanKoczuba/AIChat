//
//  AIChatApp.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/05/2025.
//

import FirebaseCore
import SwiftUI

@main
struct AIChatApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            EnvironmentBuilderView {
                AppView()
            }
        }
    }
}

struct EnvironmentBuilderView<Content: View>: View {

    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .environment(\.authService, FirebaseAuthService())
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
