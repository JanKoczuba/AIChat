//
//  SettingsView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(AppState.self) private var appState

    @State private var isPremium: Bool = false
    @State private var isAnonymousUser: Bool = true
    @State private var showCreateAccountView: Bool = false
    @State private var showAlert: AnyAppAlert?

    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
            .sheet(
                isPresented: $showCreateAccountView,
                onDismiss: {
                    setAnonymousAccountStatus()

                },
                content: {
                    CreateAccountView()
                        .presentationDetents([.medium])
                }
            )
            .onAppear {
                setAnonymousAccountStatus()
            }
            .showCustomAlert(alert: $showAlert)
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
                    onDeleteAccountPressed()
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

    func setAnonymousAccountStatus() {
        isAnonymousUser =
            authManager.auth?.isAnonymous == true
    }

    func onSignOutPressed() {
        Task {
            do {
                try authManager.signOut()
                await dissmissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    private func dissmissScreen() async {

        dismiss()
        try? await Task.sleep(for: .seconds(1))
        appState.updateViewState(showTabBarView: false)
    }

    func onDeleteAccountPressed() {
        showAlert = AnyAppAlert(
            title: "Delete Account?",
            subtitle: "This action is permanent and cannon be undone.",
            buttons: {
                AnyView(
                    Button(
                        "Delete",
                        role: .destructive,
                        action: {
                            onDeleteAccountConfirmed()
                        }
                    )
                )

            }
        )

    }

    func onDeleteAccountConfirmed() {
        Task {
            do {
                try await authManager.deleteAccount()
                await dissmissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    func onAccountCreatePressed() {
        showCreateAccountView = true
    }

}

#Preview("no auth") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: nil)))
        .environment(AppState())
}
#Preview("Anonymous") {
    SettingsView()
        .environment(
            AuthManager(
                service: MockAuthService(
                    user: UserAuthInfo.mock(isAnonymous: true)
                )
            )
        )
        .environment(AppState())
}
#Preview("Not anonymous") {
    SettingsView()
        .environment(
            AuthManager(
                service: MockAuthService(
                    user: UserAuthInfo.mock(isAnonymous: false)
                )
            )
        )

        .environment(AppState())
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
