//
//  SettingsView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

    @State private var isPremium: Bool = false
    @State private var isAnonymousUser: Bool = true
    @State private var showCreateAccountView: Bool = false

    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCreateAccountView) {
                CreateAccountView()
                    .presentationDetents([.medium])
            }
        }
    }

    private var accountSection: some View {
        Section {
            if isAnonymousUser {
                Text("Save & back-up account")
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onAccountCreatePressed()
                    }
                    .removeListRowFormatting()

            } else {
                Text("Sign out")
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onSignOutPressed()
                    }
                    .removeListRowFormatting()

            }

            Text("Delete account")
                .foregroundStyle(.red)
                .rowFormatting()
                .anyButton(.highlight) {

                }
                .removeListRowFormatting()
        } header: {
            Text("Account")
        }

    }

    private var purchaseSection: some View {
        Section {
            HStack(spacing: 8) {
                Text(
                    "Account status:  \(isPremium ? "Premium" : "FREE")"
                )
                Spacer(minLength: 0)

                if isPremium {
                    Text("MANAGE")
                        .badgeButton()
                }

            }
            .rowFormatting()
            .anyButton(.highlight) {
            }
            .disabled(!isPremium)
            .removeListRowFormatting()

        } header: {
            Text("Purchases")
        }
    }

    private var applicationSection: some View {
        Section {
            HStack(spacing: 8) {
                Text("Version")
                Spacer(minLength: 0)
                Text(Utilities.appVersion ?? "")
                    .foregroundStyle(.secondary)

            }
            .rowFormatting()
            .removeListRowFormatting()
            HStack(spacing: 8) {
                Text("Build Number")
                Spacer(minLength: 0)
                Text(Utilities.buildNumber ?? "")
                    .foregroundStyle(.secondary)

            }
            .rowFormatting()
            .removeListRowFormatting()

            Text("Contact Us")
                .foregroundStyle(.blue)
                .rowFormatting()
                .anyButton(
                    .highlight,
                    action: {
                        //
                    }
                )
                .removeListRowFormatting()

        } header: {
            Text("Application")
        }
    }

    func onSignOutPressed() {
        dismiss()

        Task {
            try? await Task.sleep(for: .seconds(1))
            appState.updateViewState(showTabBarView: false)

        }
    }

    func onAccountCreatePressed() {
        showCreateAccountView = true
    }

}

#Preview {
    SettingsView()
        .environment(AppState(showTabBarView: true))
}

extension View {

    fileprivate func rowFormatting() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(uiColor: .systemBackground))
    }
}
