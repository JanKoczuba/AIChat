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
                .environment(delegate.userManager)
                .environment(delegate.authManager)

        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var authManager: AuthManager!
    var userManager: UserManager!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        authManager = AuthManager(service: FirebaseAuthService())
        userManager = UserManager(services: ProductionUserServices())

        return true
    }
}
