//
//  ExploreView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//
import SwiftUI

struct ExploreView: View {

    @State var presenter: ExplorePresenter

    var body: some View {
        List {
            if presenter.featuredAvatars.isEmpty && presenter.popularAvatars.isEmpty {
                ZStack {
                    if presenter.isLoadingFeatured || presenter.isLoadingPopular {
                        loadingIndicator
                    } else {
                        errorMessageView
                    }
                }
                .removeListRowFormatting()
            }
            
            if !presenter.popularAvatars.isEmpty {
                if presenter.categoryRowTest == .top {
                    categorySection
                }
            }
            
            if !presenter.featuredAvatars.isEmpty {
                featuredSection
            }
            
            if !presenter.popularAvatars.isEmpty {
                if presenter.categoryRowTest == .original {
                    categorySection
                }
                popularSection
            }
        }
        .navigationTitle("Explore")
        .screenAppearAnalytics(name: "ExploreView")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                if presenter.showDevSettingsButton {
                    devSettingsButton
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if presenter.showNotificationButton {
                    pushNotificationButton
                }
            }
        })
        .task {
            await presenter.loadFeaturedAvatars()
        }
        .task {
            await presenter.loadPopularAvatars()
        }
        .task {
            await presenter.handleShowPushNotificationButton()
        }
        .onFirstAppear {
            presenter.schedulePushNotifications()
            presenter.showCreateAccountScreenIfNeeded()
        }
        .onOpenURL { url in
            presenter.handleDeepLink(url: url)
        }
    }
        
    private var pushNotificationButton: some View {
        Image(systemName: "bell.fill")
            .font(.headline)
            .padding(4)
            .tappableBackground()
            .foregroundStyle(.accent)
            .anyButton {
                presenter.onPushNotificationButtonPressed()
            }
    }
    
    private var devSettingsButton: some View {
        Text("DEV 🤫")
            .badgeButton()
            .anyButton(.press) {
                presenter.onDevSettingsPressed()
            }
    }
    
    private var loadingIndicator: some View {
        ProgressView()
            .tint(.accent)
            .padding(40)
            .frame(maxWidth: .infinity)
    }
    
    private var errorMessageView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Error")
                .font(.headline)
            Text("Please check your internet connection and try again.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Try again") {
                presenter.onTryAgainPressed()
            }
            .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(40)
    }
        
    private var featuredSection: some View {
        Section {
            ZStack {
                CarouselView(items: presenter.featuredAvatars) { avatar in
                    HeroCellView(
                        title: avatar.name,
                        subtitle: avatar.characterDescription,
                        imageName: avatar.profileImageName
                    )
                    .anyButton {
                        presenter.onAvatarPressed(avatar: avatar)
                    }
                    .accessibilityIdentifier("HeroCell")
                }
            }
            .removeListRowFormatting()
        } header: {
            Text("Featured")
        }
    }
        
    private var categorySection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(presenter.categories, id: \.self) { category in
                            let imageName = presenter.popularAvatars.last(where: { $0.characterOption == category })?.profileImageName
                            if let imageName {
                                CategoryCellView(
                                    title: category.plural.capitalized,
                                    imageName: imageName
                                )
                                .anyButton {
                                    presenter.onCategoryPressed(category: category, imageName: imageName)
                                }
                            }
                        }
                    }
                }
                .frame(height: 140)
                .scrollIndicators(.hidden)
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
            }
            .removeListRowFormatting()
        } header: {
            Text("Categories")
        }
    }
    
    private var popularSection: some View {
        Section {
            ForEach(presenter.popularAvatars, id: \.self) { avatar in
                CustomListCellView(
                    imageName: avatar.profileImageName,
                    title: avatar.name,
                    subtitle: avatar.characterDescription
                )
                .anyButton(.highlight) {
                    presenter.onAvatarPressed(avatar: avatar)
                }
                .removeListRowFormatting()
            }
        } header: {
            Text("Popular")
        }
    }
    
}

#Preview("Has data") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService()))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("Has data w/ Create Acct Test") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService()))
    container.register(AuthManager.self, service: AuthManager(service: MockAuthService(user: .mock(isAnonymous: true))))
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(createAccountTest: true)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    
    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("CategoryRowTest: original") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(categoryRowTest: .original)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("CategoryRowTest: top") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(categoryRowTest: .top)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("CategoryRowTest: hidden") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(categoryRowTest: .hidden)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("No data") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService(avatars: [], delay: 2.0)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
#Preview("Slow loading") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService(delay: 10)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.exploreView(router: router)
    }
    .previewEnvironment()
}
