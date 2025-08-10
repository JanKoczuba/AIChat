//
//  ExplorePresenter.swift
//  AIChat
//
//  Created by Jan Koczuba on 05/08/2025.
//

import SwiftUI

@Observable
@MainActor
class ExplorePresenter {
    
    private let interactor: ExploreInteractor
    private let router: ExploreRouter

    private(set) var featuredAvatars: [AvatarModel] = []
    private(set) var popularAvatars: [AvatarModel] = []
    private(set) var isLoadingFeatured: Bool = true
    private(set) var isLoadingPopular: Bool = true
    private(set) var categories: [CharacterOption] = CharacterOption.allCases
    private(set) var showNotificationButton: Bool = false
        
    var showDevSettingsButton: Bool {
        #if DEV || MOCK
        return true
        #else
        return false
        #endif
    }
    
    var categoryRowTest: CategoryRowTestOption {
        interactor.categoryRowTest
    }

    init(interactor: ExploreInteractor, router: ExploreRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func handleDeepLink(url: URL) {
        interactor.trackEvent(event: Event.deeplinkStart)
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
            interactor.trackEvent(event: Event.deeplinkNoQueryItems)
            return
        }
        
        for queryItem in queryItems {
            if queryItem.name == "category", let value = queryItem.value, let category = CharacterOption(rawValue: value) {
                let imageName = popularAvatars.first(where: { $0.characterOption == category })?.profileImageName ?? Constants.randomImage
                
                let delegate = CategoryListDelegate(category: category, imageName: imageName)
                router.showCategoryListView(delegate: delegate)

                interactor.trackEvent(event: Event.deeplinkCategory(category: category))
                return
            }
        }
        
        interactor.trackEvent(event: Event.deeplinkUnknown)
    }
    
    func schedulePushNotifications() {
        interactor.schedulePushNotificationsForTheNextWeek()
    }
    
    func showCreateAccountScreenIfNeeded() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            // If the user doesn't already have an account (anonymous)
            // If the user is in our AB test
            guard
                interactor.auth?.isAnonymous == true &&
                interactor.createAccountTest == true
            else {
                return
            }
            
            router.showCreateAccountView(delegate: CreateAccountDelegate(), onDisappear: nil)
        }
    }
    
    func handleShowPushNotificationButton() async {
        showNotificationButton = await interactor.canRequestAuthorization()
    }
    
    func onPushNotificationButtonPressed() {
        func onEnablePushNotificationsPressed() {
            router.dismissModal()
            
            Task {
                let isAuthorized = try await interactor.requestAuthorization()
                interactor.trackEvent(event: Event.pushNotifsEnable(isAuthorized: isAuthorized))
                await handleShowPushNotificationButton()
            }
        }
        
        func onCancelPushNotificationsPressed() {
            router.dismissModal()
            interactor.trackEvent(event: Event.pushNotifsCancel)
        }
        
        interactor.trackEvent(event: Event.pushNotifsStart)
        router.showPushNotificationModal(
                onEnablePressed: {
                    onEnablePushNotificationsPressed()
                },
                onCancelPressed: {
                    onCancelPushNotificationsPressed()
                }
            )
    }
        
    func onDevSettingsPressed() {
        interactor.trackEvent(event: Event.devSettingsPressed)
        router.showDevSettingsView()
    }

    func onTryAgainPressed() {
        isLoadingFeatured = true
        isLoadingPopular = true
        interactor.trackEvent(event: Event.tryAgainPressed)

        Task {
            await loadFeaturedAvatars()
        }
        Task {
            await loadPopularAvatars()
        }
    }
    
    func loadFeaturedAvatars() async {
        // If already loaded, no need to fetch again
        guard featuredAvatars.isEmpty else { return }
        interactor.trackEvent(event: Event.loadFeaturedAvatarsStart)

        do {
            featuredAvatars = try await interactor.getFeaturedAvatars()
            interactor.trackEvent(event: Event.loadFeaturedAvatarsSuccess(count: featuredAvatars.count))
        } catch {
            interactor.trackEvent(event: Event.loadFeaturedAvatarsFail(error: error))
        }
        
        isLoadingFeatured = false
    }
    
    func loadPopularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        interactor.trackEvent(event: Event.loadPopularAvatarsStart)

        do {
            popularAvatars = try await interactor.getPopularAvatars()
            interactor.trackEvent(event: Event.loadPopularAvatarsSuccess(count: popularAvatars.count))
        } catch {
            interactor.trackEvent(event: Event.loadPopularAvatarsFail(error: error))
        }
        
        isLoadingPopular = false
    }

    func onAvatarPressed(avatar: AvatarModel) {
        interactor.trackEvent(event: Event.avatarPressed(avatar: avatar))
        
        let delegate = ChatViewDelegate(chat: nil, avatarId: avatar.avatarId)
        router.showChatView(delegate: delegate)
    }

    func onCategoryPressed(category: CharacterOption, imageName: String) {
        interactor.trackEvent(event: Event.categoryPressed(category: category))
        
        let delegate = CategoryListDelegate(category: category, imageName: imageName)
        router.showCategoryListView(delegate: delegate)
    }

    enum Event: LoggableEvent {
        case devSettingsPressed
        case tryAgainPressed
        case loadFeaturedAvatarsStart
        case loadFeaturedAvatarsSuccess(count: Int)
        case loadFeaturedAvatarsFail(error: Error)
        case loadPopularAvatarsStart
        case loadPopularAvatarsSuccess(count: Int)
        case loadPopularAvatarsFail(error: Error)
        case avatarPressed(avatar: AvatarModel)
        case categoryPressed(category: CharacterOption)
        case pushNotifsStart
        case pushNotifsEnable(isAuthorized: Bool)
        case pushNotifsCancel
        case deeplinkStart
        case deeplinkNoQueryItems
        case deeplinkCategory(category: CharacterOption)
        case deeplinkUnknown

        var eventName: String {
            switch self {
            case .devSettingsPressed:           return "ExploreView_DevSettings_Pressed"
            case .tryAgainPressed:              return "ExploreView_TryAgain_Pressed"
            case .loadFeaturedAvatarsStart:     return "ExploreView_LoadFeaturedAvatars_Start"
            case .loadFeaturedAvatarsSuccess:   return "ExploreView_LoadFeaturedAvatars_Success"
            case .loadFeaturedAvatarsFail:      return "ExploreView_LoadFeaturedAvatars_Fail"
            case .loadPopularAvatarsStart:      return "ExploreView_LoadPopularAvatars_Start"
            case .loadPopularAvatarsSuccess:    return "ExploreView_LoadPopularAvatars_Success"
            case .loadPopularAvatarsFail:       return "ExploreView_LoadPopularAvatars_Fail"
            case .avatarPressed:                return "ExploreView_Avatar_Pressed"
            case .categoryPressed:              return "ExploreView_Category_Pressed"
            case .pushNotifsStart:              return "ExploreView_PushNotifs_Start"
            case .pushNotifsEnable:             return "ExploreView_PushNotifs_Enable"
            case .pushNotifsCancel:             return "ExploreView_PushNotifs_Cancel"
            case .deeplinkStart:                return "ExploreView_DeepLink_Start"
            case .deeplinkNoQueryItems:         return "ExploreView_DeepLink_NoItems"
            case .deeplinkCategory:             return "ExploreView_DeepLink_Category"
            case .deeplinkUnknown:              return "ExploreView_DeepLink_Unknown"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .loadPopularAvatarsSuccess(count: let count), .loadFeaturedAvatarsSuccess(count: let count):
                return [
                    "avatars_count": count
                ]
            case .loadPopularAvatarsFail(error: let error), .loadFeaturedAvatarsFail(error: let error):
                return error.eventParameters
            case .avatarPressed(avatar: let avatar):
                return avatar.eventParameters
            case .categoryPressed(category: let category), .deeplinkCategory(category: let category):
                return [
                    "category": category.rawValue
                ]
            case .pushNotifsEnable(isAuthorized: let isAuthorized):
                return [
                    "is_authorized": isAuthorized
                ]
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .loadPopularAvatarsFail, .loadFeaturedAvatarsFail, .deeplinkUnknown:
                return .severe
            default:
                return .analytic
            }
        }
    }

}
