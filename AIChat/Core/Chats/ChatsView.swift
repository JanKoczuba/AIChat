//
//  ChatsView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct ChatsView: View {

    @State private var chats: [ChatModel] = ChatModel.mocks

    var body: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    Text(chat.id)
                }
            }
                .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
