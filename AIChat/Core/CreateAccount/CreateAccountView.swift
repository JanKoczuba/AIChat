//
//  CreateAccountView.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/05/2025.
//

import SwiftUI

struct CreateAccountView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager

    var title: String = "Create Account?"
    var subtitle: String =
        "Don't lose your data! Connect to an SSO provider to save your account."
    var onDidSignIn: ((_ isNewUser: Bool) -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            SignInWithAppleButtonView(
                type: .signIn,
                style: .black,
                cornerRadius: 10
            )
            .frame(height: 55)
            .anyButton(.press) {

            }

            Spacer()
        }
        .padding(16)
        .padding(.top, 40)
    }

    func onSignInApplePressed() {
        Task {
            do {
                let result = try await authManager.signInApple()
                print("Did sign in with Apple: \(result.user.uid)")
                try await userManager.longIn(
                    auth: result.user,
                    isNewUser: result.isNewUser
                )
                onDidSignIn?(result.isNewUser)
                dismiss()
            } catch {
                print("Error signing in with Apple")

            }
        }
    }
}

#Preview {
    CreateAccountView()
}
