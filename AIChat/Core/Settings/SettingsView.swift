//
//  SettingsView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct SettingsView: View {

    @Environment(AppState.self) private var appState
    var body: some View {
        NavigationStack {
            List {
                Button {
                    onSignOutPressed()
                } label: {
                    Text("Sign out")
                }
            }
            .navigationTitle("Settings")
        }
    }

    func onSignOutPressed() {
        appState.updateViewState(showTabBarView: false)
    }

}

#Preview {
    SettingsView()
        .environment(AppState(showTabBarView: true))
}
