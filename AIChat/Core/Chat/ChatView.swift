//
//  ChatView.swift
//  AIChat
//
//  Created by Jan Koczuba on 02/06/2025.
//

import SwiftUI

struct ChatView: View {

    @State var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(DependencyContainer.self) private var container

    var chat: ChatModel?
    var avatarId: String = AvatarModel.mock.avatarId

    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .navigationTitle(viewModel.avatar?.name ?? "")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if viewModel.isGeneratingResponse {
                        ProgressView()
                    }

                    Image(systemName: "ellipsis")
                        .padding(8)
                        .anyButton {
                            viewModel.onChatSettingsPressed(onDidDeleteChat: {
                                dismiss()
                            })
                        }
                }
            }
        }
        .screenAppearAnalytics(name: "ChatView")
        .showCustomAlert(type: .confirmationDialog, alert: $viewModel.showChatSettings)
        .showCustomAlert(alert: $viewModel.showAlert)
        .showModal(showModal: $viewModel.showProfileModal) {
            if let avatar = viewModel.avatar {
                profileModal(avatar: avatar)
            }
        }
        .sheet(isPresented: $viewModel.showPaywall, content: {
            PaywallView(viewModel: PaywallViewModel(interactor: CoreInteractor(container: container)))
        })
        .task {
            await viewModel.loadAvatar(avatarId: avatarId)
        }
        .task {
            await viewModel.loadChat(avatarId: avatarId)
            await viewModel.listenForChatMessages()
        }
        .onFirstAppear {
            viewModel.onViewFirstAppear(chat: chat)
        }
    }

    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.chatMessages) { message in
                    if viewModel.messageIsDelayed(message: message) {
                        timestampView(date: message.dateCreatedCalculated)
                    }

                    let isCurrentUser = viewModel.messageIsCurrentUser(message: message)
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        currentUserProfileColor: viewModel.currentUser?.profileColorCalculated ?? .accent,
                        imageName: isCurrentUser ? nil : viewModel.avatar?.profileImageName,
                        onImagePressed: viewModel.onAvatarImagePressed
                    )
                    .onAppear {
                        viewModel.onMessageDidAppear(message: message)
                    }
                    .id(message.id)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .rotationEffect(.degrees(180))
        }
        .rotationEffect(.degrees(180))
        .scrollPosition(id: $viewModel.scrollPosition, anchor: .center)
        .animation(.default, value: viewModel.chatMessages.count)
        .animation(.default, value: viewModel.scrollPosition)
    }

    private var textFieldSection: some View {
        TextField("Say something...", text: $viewModel.textFieldText)
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .padding(12)
            .padding(.trailing, 60)
            .accessibilityIdentifier("ChatTextField")
            .overlay(
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .padding(.trailing, 4)
                    .foregroundStyle(.accent)
                    .anyButton(.plain, action: {
                        viewModel.onSendMessagePressed(avatarId: avatarId)
                    })

                , alignment: .trailing
            )
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color(uiColor: .systemBackground))

                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(uiColor: .secondarySystemBackground))
    }

    private func profileModal(avatar: AvatarModel) -> some View {
        ProfileModalView(
            imageName: avatar.profileImageName,
            title: avatar.name,
            subtitle: avatar.characterOption?.rawValue.capitalized,
            headline: avatar.characterDescription,
            onXMarkPressed: {
                viewModel.onProfileModalXmarkPressed()
            }
        )
        .padding(40)
        .transition(.slide)
    }

    private func timestampView(date: Date) -> some View {
        Group {
            Text(date.formatted(date: .abbreviated, time: .omitted))
            +
            Text(" • ")
            +
            Text(date.formatted(date: .omitted, time: .shortened))
        }
        .foregroundStyle(.secondary)
        .font(.callout)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
    }

}

#Preview("Working chat - Not Premium") {
    NavigationStack {
        ChatView(viewModel: ChatViewModel(interactor: CoreInteractor(container: DevPreview.shared.container)))
            .previewEnvironment()
    }
}
#Preview("Working chat - Premium") {
    let container = DevPreview.shared.container
    container.register(PurchaseManager.self, service: PurchaseManager(service: MockPurchaseService(activeEntitlements: [.mock])))

    return NavigationStack {
        ChatView(viewModel: ChatViewModel(interactor: CoreInteractor(container: container)))
            .previewEnvironment()
    }
}
#Preview("Slow AI generation") {
    let container = DevPreview.shared.container
    container.register(AIManager.self, service: AIManager(service: MockAIService(delay: 20)))

    return NavigationStack {
        ChatView(viewModel: ChatViewModel(interactor: CoreInteractor(container: container)))
            .previewEnvironment()
    }
}
#Preview("Failed AI generation") {
    let container = DevPreview.shared.container
    container.register(AIManager.self, service: AIManager(service: MockAIService(delay: 2, showError: true)))
    container.register(PurchaseManager.self, service: PurchaseManager(service: MockPurchaseService(activeEntitlements: [.mock])))

    return NavigationStack {
        ChatView(viewModel: ChatViewModel(interactor: CoreInteractor(container: container)))
            .previewEnvironment()
    }
}
