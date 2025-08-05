//
//  TabBarView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct TabBarView: View {

    @Environment(DependencyContainer.self) private var container

    var body: some View {
        TabView {
            ExploreView(viewModel: ExploreViewModel(container: container))
                .tabItem {
                    Label("Explore", systemImage: "eyes")
                }

            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right.fill")
                }

            ProfileView(
                viewModel: ProfileViewModel(
                    interactor: CoreInteractor(container: container)
                )
            )
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

#Preview {
    TabBarView()
        .previewEnvironment()
}
