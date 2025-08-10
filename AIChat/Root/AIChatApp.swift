//
//  AIChatApp.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//
import SwiftUI
import SwiftfulUtilities

@main
struct AppEntryPoint {
    
    static func main() {
        if Utilities.isUnitTesting {
            TestingApp.main()
        } else {
            AIChatApp.main()
        }
    }
}

struct AIChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var body: some Scene {
        WindowGroup {
            Group {
                if Utilities.isUITesting {
                    AppViewForUITesting()
                } else {
                    delegate.builder.appView()
                }
            }
            .environment(delegate.builder)
            .environment(delegate.dependencies.logManager)
        }
    }
}

struct AppViewForUITesting: View {
    
    @Environment(CoreBuilder.self) private var builder
    
    private var startOnAvatarScreen: Bool {
        ProcessInfo.processInfo.arguments.contains("STARTSCREEN_CREATEAVATAR")
    }

    var body: some View {
        if startOnAvatarScreen {
            builder.createAvatarView()
        } else {
            builder.appView()
        }
    }
}

struct TestingApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Testing!")
        }
    }
}
