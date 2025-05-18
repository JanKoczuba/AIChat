//
//  WelcomeView.swift
//  AIChat
//
//  Created by Jan Koczuba on 17/05/2025.
//

import SwiftUI

struct WelcomeView: View {

    @State var imageName: String = Constants.randomImage

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ImageLoaderView(urlString: imageName)
                    .ignoresSafeArea()

                titleSection
                    .padding(.top, 24)
                ctaButtons
                    .padding(16)

                policyLinks

            }
        }
    }

    private var titleSection: some View {
        Text("AI Chat")
            .font(.largeTitle)
            .fontWeight(.semibold)

    }

    private var ctaButtons: some View {
        VStack(spacing: 8) {
            NavigationLink {
                OnboardingIntroView()
            } label: {
                Text("Get Started")
                    .callToActionButton()
            }
            Text("Already have an account? Sign In.")
                .underline()
                .font(.body)
                .padding(8)
                .tappableBackground()
                .onTapGesture {

                }
        }
    }

    private var policyLinks: some View {
        HStack(spacing: 8) {
            Link(destination: URL(string: Constants.termsOfServiceUrl)!) {
                Text("Terms of Service")
            }
            Circle()
                .fill(.accent)
                .frame(width: 4, height: 4)
            Link(destination: URL(string: Constants.privacyPolicyUrl)!) {
                Text("Privacy Policy")
            }
        }
    }
}

#Preview {
    WelcomeView()
}
