//
//  TabbarPathOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//

import SwiftUI
import Foundation

enum TabbarPathOption: Hashable {
    case chat(avatarId: String, chat: ChatModel?)
    case category(category: CharacterOption, imageName: String)
}

struct NavDestForTabbarModuleViewModifier: ViewModifier {
    
    @Environment(DependencyContainer.self) private var container
    let path: Binding<[TabbarPathOption]>
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: TabbarPathOption.self) { newValue in
                switch newValue {
                case .chat(avatarId: let avatarId, chat: let chat):
                    ChatView(
                        viewModel: ChatViewModel(interactor: CoreInteractor(container: container)),
                        chat: chat,
                        avatarId: avatarId
                    )
                case .category(category: let category, imageName: let imageName):
                    CategoryListView(
                        viewModel: CategoryListViewModel(interactor: CoreInteractor(container: container)),
                        path: path,
                        category: category,
                        imageName: imageName
                    )
                }
            }
    }
}

extension View {
    
    func navigationDestinationForTabbarModule(path: Binding<[TabbarPathOption]>) -> some View {
        modifier(NavDestForTabbarModuleViewModifier(path: path))
    }
}
