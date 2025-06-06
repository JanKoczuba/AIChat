//
//  AppState.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

@Observable
class AppState {

    private(set) var showTabBar: Bool {
        didSet {
            UserDefaults.showTabbarView = showTabBar
        }
    }

    init(
        showTabBarView: Bool = UserDefaults.showTabbarView
    ) {
        self.showTabBar = showTabBarView
    }

    func updateViewState(showTabBarView: Bool) {
        showTabBar = showTabBarView
    }
}

extension UserDefaults {

    private struct Keys {
        static let showTabbarView = "showTabbarView"
    }

    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        }
        set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
}
