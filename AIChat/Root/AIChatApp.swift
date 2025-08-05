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
                    AppView(viewModel: AppViewModel(interactor: CoreInteractor(container: delegate.dependencies.container)))
                }
            }
            .environment(delegate.dependencies.container)
            .environment(delegate.dependencies.logManager)
        }
    }
}

struct AppViewForUITesting: View {
    
    @Environment(DependencyContainer.self) private var container
    
    private var startOnAvatarScreen: Bool {
        ProcessInfo.processInfo.arguments.contains("STARTSCREEN_CREATEAVATAR")
    }

    var body: some View {
        if startOnAvatarScreen {
            CreateAvatarView(viewModel: CreateAvatarViewModel(interactor: CoreInteractor(container: container)))
        } else {
            AppView(viewModel: AppViewModel(interactor: CoreInteractor(container: container)))
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
