//
//  OnboardingColorView.swift
//  AIChat
//
//  Created by Jan Koczuba on 18/05/2025.
//

import SwiftUI

struct OnboardingColorView: View {

    @State private var selectedColor: Color?
    let profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan, .teal, .indigo]

    var body: some View {
        ScrollView {
            colorGrid
                .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16, content: {
            ZStack {
                if let selectedColor {
                    ctaButton(selectedColor: selectedColor)
                        .transition(AnyTransition.move(edge: .bottom))
                }
            }
            .padding(24)
            .background(Color(uiColor: .systemBackground))
        })
        .animation(.bouncy, value: selectedColor)
        .toolbar(.hidden, for: .navigationBar)
        .screenAppearAnalytics(name: "OnboardingColorView")
    }

    private var colorGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
            alignment: .center,
            spacing: 16,
            pinnedViews: [.sectionHeaders],
            content: {
                Section(content: {
                    ForEach(profileColors, id: \.self) { color in
                        Circle()
                            .fill(.accent)
                            .overlay(
                                color
                                    .clipShape(Circle())
                                    .padding(selectedColor == color ? 10 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }, header: {
                    Text("Select a profile color")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                })
            }
        )
    }

    private func ctaButton(selectedColor: Color) -> some View {
        NavigationLink {
            OnboardingCompletedView(selectedColor: selectedColor)
        } label: {
            Text("Continue")
                .callToActionButton()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingColorView()
    }
    .previewEnvironment()
}
