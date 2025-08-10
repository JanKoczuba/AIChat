//
//  CoreBuilder.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//
import SwiftUI

@Observable
@MainActor
class CoreBuilder {
    let interactor: CoreInteractor
    
    init(interactor: CoreInteractor) {
        self.interactor = interactor
    }
    
    func appView() -> some View {
        AppView(
            viewModel: AppViewModel(
                interactor: interactor
            )
        )
    }
    
    func tabbarView() -> some View {
        TabBarView()
    }
    
    func welcomeView() -> some View {
        WelcomeView(
            viewModel: WelcomeViewModel(
                interactor: interactor
            )
        )
    }
    
    func onboardingIntroView(delegate: OnboardingIntroDelegate) -> some View {
        OnboardingIntroView(
            viewModel: OnboardingIntroViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func onboardingColorView(delegate: OnboardingColorDelegate) -> some View {
        OnboardingColorView(
            viewModel: OnboardingColorViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func onboardingCommunityView(delegate: OnboardingCommunityDelegate) -> some View {
        OnboardingCommunityView(
            viewModel: OnboardingCommunityViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func onboardingCompletedView(delegate: OnboardingCompletedDelegate) -> some View {
        OnboardingCompletedView(
            viewModel: OnboardingCompletedViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func createAccountView(delegate: CreateAccountDelegate = CreateAccountDelegate()) -> some View {
        CreateAccountView(
            viewModel: CreateAccountViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }

    func exploreView() -> some View {
        ExploreView(
            viewModel: ExploreViewModel(
                interactor: interactor
            )
        )
    }
    
    func categoryListView(delegate: CategoryListDelegate) -> some View {
        CategoryListView(
            viewModel: CategoryListViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func chatsView() -> some View {
        ChatsView(
            viewModel: ChatsViewModel(
                interactor: interactor
            )
        )
    }
    
    func chatView(delegate: ChatViewDelegate = ChatViewDelegate()) -> some View {
        ChatView(
            viewModel: ChatViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
    
    func createAvatarView() -> some View {
        CreateAvatarView(
            viewModel: CreateAvatarViewModel(
                interactor: interactor
            )
        )
    }
        
    func paywallView() -> some View {
        PaywallView(
            viewModel: PaywallViewModel(
                interactor: interactor
            )
        )
    }
    
    func profileView() -> some View {
        ProfileView(
            viewModel: ProfileViewModel(
                interactor: interactor
            )
        )
    }

    func settingsView() -> some View {
        SettingsView(
            viewModel: SettingsViewModel(
                interactor: interactor
            )
        )
    }
        
    func devSettingsView() -> some View {
        DevSettingsView(
            viewModel: DevSettingsViewModel(
                interactor: interactor
            )
        )
    }
    
    // MARK: CELLS
    
    func chatRowCell(delegate: ChatRowCellDelegate = ChatRowCellDelegate()) -> some View {
        ChatRowCellViewBuilder(
            viewModel: ChatRowCellViewModel(
                interactor: interactor
            ),
            delegate: delegate
        )
    }
}
