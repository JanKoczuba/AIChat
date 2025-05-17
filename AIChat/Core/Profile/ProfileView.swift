//
//  ProfileView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct ProfileView: View {

    @State private var showSettingView: Bool = false

    var body: some View {
        NavigationStack {
            Text("Profile")
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        settingsButton
                    }
                }
                .sheet(isPresented: $showSettingView) {
                    Text("SettingsView")
                }

        }
    }

    private var settingsButton: some View {
        Button {
            onSettingsButtonPressed()
        } label: {
            Image(systemName: "gear")
                .font(.headline)
        }
    }

    private func onSettingsButtonPressed() {
        showSettingView = true
    }
}

#Preview {
    ProfileView()
}
