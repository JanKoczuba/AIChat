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
            AppView()
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.authManager)
                .environment(delegate.dependencies.aiManager)


        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var  dependencies: Dependencies!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        dependencies = Dependencies()

        return true
    }
}

@MainActor
struct Dependencies {
    let authManager: AuthManager
    let userManager: UserManager
    let aiManager: AIManager

    init() {
        self.authManager = AuthManager(service: FirebaseAuthService())
        self.userManager = UserManager(services: ProductionUserServices())
        self.aiManager = AIManager(service: OpenAIService())
    }
}
