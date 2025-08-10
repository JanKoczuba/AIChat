//
//  OnboardingColorView.swift
//  AIChat
//
//  Created by Jan Koczuba on 18/05/2025.
//

import SwiftUI

struct OnboardingColorDelegate {
}

struct OnboardingColorView: View {
    
    @State var presenter: OnboardingColorPresenter
    let delegate: OnboardingColorDelegate
    
    var body: some View {
        ScrollView {
            colorGrid
                .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16, content: {
            ZStack {
                if let selectedColor = presenter.selectedColor {
                    ctaButton(selectedColor: selectedColor)
                        .transition(AnyTransition.move(edge: .bottom))
                }
            }
            .padding(24)
            .background(Color(uiColor: .systemBackground))
        })
        .animation(.bouncy, value: presenter.selectedColor)
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
                    ForEach(presenter.profileColors, id: \.self) { color in
                        Circle()
                            .fill(.accent)
                            .overlay(
                                color
                                    .clipShape(Circle())
                                    .padding(presenter.selectedColor == color ? 10 : 0)
                            )
                            .onTapGesture {
                                presenter.onColorPressed(color: color)
                            }
                            .accessibilityIdentifier("ColorCircle")
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
        Text("Continue")
            .callToActionButton()
            .anyButton(.press, action: {
                presenter.onContinuePressed()
            })
            .accessibilityIdentifier("ContinueButton")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container))
    
    return RouterView { router in
        builder.onboardingColorView(router: router, delegate: OnboardingColorDelegate())
    }
    .previewEnvironment()
}
