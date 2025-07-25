//
//  AIChatApp.swift
//  AIChat
//
//  Created by Jan Koczuba on 14/05/2025.
//

import FirebaseCore
import SwiftUI

@main
struct AIChatCourseApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.dependencies.chatManager)
                .environment(delegate.dependencies.aiManager)
                .environment(delegate.dependencies.avatarManager)
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.authManager)
                .environment(delegate.dependencies.logManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        let config: BuildConfiguration

        #if MOCK
        config = .mock(isSignedIn: true)
        #elseif DEV
        config = .dev
        #else
        config = .prod
        #endif

        config.configure()
        dependencies = Dependencies(config: config)
        return true
    }
}

enum BuildConfiguration {
    case mock(isSignedIn: Bool), dev, prod

    func configure() {
        switch self {
        case .mock:
            break
        case .dev:
            let plist = Bundle.main.path(forResource: "GoogleServiceInfo-Dev", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: plist)!
            FirebaseApp.configure(options: options)
        case .prod:
            let plist = Bundle.main.path(forResource: "GoogleServiceInfo-Prod", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: plist)!
            FirebaseApp.configure(options: options)
        }
    }
}

@MainActor
struct Dependencies {
    let authManager: AuthManager
    let userManager: UserManager
    let aiManager: AIManager
    let avatarManager: AvatarManager
    let chatManager: ChatManager
    let logManager: LogManager

    init(config: BuildConfiguration) {
        switch config {
        case .mock(isSignedIn: let isSignedIn):
            logManager = LogManager(services: [
                ConsoleService(printParameters: false)
            ])
            authManager = AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil), logManager: logManager)
            userManager = UserManager(services: MockUserServices(user: isSignedIn ? .mock : nil), logManager: logManager)
            aiManager = AIManager(service: MockAIService())
            avatarManager = AvatarManager(remote: MockAvatarService(), local: MockLocalAvatarPersistence())
            chatManager = ChatManager(service: MockChatService())
        case .dev:
            logManager = LogManager(services: [
                ConsoleService(printParameters: false),
                FirebaseAnalyticsService(),
                MixpanelService(token: Keys.mixpanelToken),
                FirebaseCrashlyticsService()
            ])
            authManager = AuthManager(service: FirebaseAuthService(), logManager: logManager)
            userManager = UserManager(services: ProductionUserServices(), logManager: logManager)
            aiManager = AIManager(service: OpenAIService())
            avatarManager = AvatarManager(remote: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(service: FirebaseChatService())
        case .prod:
            logManager = LogManager(services: [
                FirebaseAnalyticsService(),
                MixpanelService(token: Keys.mixpanelToken),
                FirebaseCrashlyticsService()
            ])
            authManager = AuthManager(service: FirebaseAuthService(), logManager: logManager)
            userManager = UserManager(services: ProductionUserServices(), logManager: logManager)
            aiManager = AIManager(service: OpenAIService())
            avatarManager = AvatarManager(remote: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(service: FirebaseChatService())
        }
    }
}

extension View {
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(ChatManager(service: MockChatService()))
            .environment(AIManager(service: MockAIService()))
            .environment(AvatarManager(remote: MockAvatarService()))
            .environment(UserManager(services: MockUserServices(user: isSignedIn ? .mock : nil)))
            .environment(AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil)))
            .environment(AppState())
            .environment(LogManager(services: []))
    }
}
