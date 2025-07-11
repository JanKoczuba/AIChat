//
//  AIChatApp.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/05/2025.
//

import SwiftUI
import FirebaseCore

@main
struct AIChatApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
