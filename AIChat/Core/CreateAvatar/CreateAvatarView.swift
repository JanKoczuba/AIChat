//
//  CreateAvatarView.swift
//  AIChat
//
//  Created by Jan Koczuba on 02/06/2025.
//

import SwiftUI

struct CreateAvatarView: View {
    
    @State var presenter: CreateAvatarPresenter

    var body: some View {
        List {
            nameSection
            attributesSection
            imageSection
            saveSection
        }
        .navigationTitle("Create Avatar")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .screenAppearAnalytics(name: "CreateAvatar")
    }
    
    private var backButton: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.semibold)
            .anyButton(.plain) {
                presenter.onBackButtonPressed()
            }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Player 1", text: $presenter.avatarName)
        } header: {
            Text("Name your avatar*")
                .lineLimit(1)
                .minimumScaleFactor(0.3)
        }
    }
    
    private var attributesSection: some View {
        Section {
            Picker(selection: $presenter.characterOption) {
                ForEach(CharacterOption.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("is a...")
            }

            Picker(selection: $presenter.characterAction) {
                ForEach(CharacterAction.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("that is...")
            }
            
            Picker(selection: $presenter.characterLocation) {
                ForEach(CharacterLocation.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } label: {
                Text("in the...")
            }
        } header: {
            Text("Attributes")
                .lineLimit(1)
                .minimumScaleFactor(0.3)
        }
    }
    
    private var imageSection: some View {
        Section {
            HStack(alignment: .top, spacing: 8) {
                ZStack {
                    Text("Generate image")
                        .underline()
                        .foregroundStyle(.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .anyButton(.plain) {
                            presenter.onGenerateImagePressed()
                        }
                        .opacity(presenter.isGenerating ? 0 : 1)

                    ProgressView()
                        .tint(.accent)
                        .opacity(presenter.isGenerating ? 1 : 0)
                }
                .disabled(presenter.isGenerating || presenter.avatarName.isEmpty)
                
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .overlay(
                        ZStack {
                            if let generatedImage = presenter.generatedImage {
                                Image(uiImage: generatedImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    )
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, maxHeight: 400)
            }
            .removeListRowFormatting()
        }
    }
    
    private var saveSection: some View {
        Section {
            AsyncCallToActionButton(
                isLoading: presenter.isSaving,
                title: "Save",
                action: {
                    presenter.onSavePressed()
                }
            )
            .removeListRowFormatting()
            .padding(.top, 24)
            .opacity(presenter.generatedImage == nil ? 0.5 : 1.0)
            .disabled(presenter.generatedImage == nil)
            .frame(maxWidth: 500)
            .frame(maxWidth: .infinity)
        }
    }
    
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container))

    return RouterView { router in
        builder.createAvatarView(router: router)
    }
    .previewEnvironment()
}
