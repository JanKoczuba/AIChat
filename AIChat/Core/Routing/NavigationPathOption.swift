//
//  NavigationPathOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 18/06/2025.
//

import Foundation
import SwiftUI

enum NavigationPathOption: Hashable {
    case chat(avatarId: String, chat: ChatModel?)
    case category(category: CharacterOption, imageName: String)
}

extension View {

    func navigationDestinationForCoreModule(
        path: Binding<[NavigationPathOption]>
    ) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { newValue in
                switch newValue {
                case .chat(let avatarId, let chat):
                    ChatView(chat: chat, avatarId: avatarId)
                case .category(let category, let imageName):
                    CategoryListView(
                        path: path,
                        category: category,
                        imageName: imageName
                    )
                }
            }
    }
}
