//
//  CategoryListView.swift
//  AIChat
//
//  Created by Jan Koczuba on 18/06/2025.
//
import SwiftUI

struct CategoryListDelegate {
    var path: Binding<[TabbarPathOption]>
    var category: CharacterOption = .alien
    var imageName: String = Constants.randomImage
}

struct CategoryListView: View {

    @State var viewModel: CategoryListViewModel
    let delegate: CategoryListDelegate
    
    var body: some View {
        List {
            CategoryCellView(
                title: delegate.category.plural.capitalized,
                imageName: delegate.imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(40)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else if viewModel.avatars.isEmpty {
                Text("No avatars found 😭")
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else {
                ForEach(viewModel.avatars, id: \.self) { avatar in
                    CustomListCellView(
                        imageName: avatar.profileImageName,
                        title: avatar.name,
                        subtitle: avatar.characterDescription
                    )
                    .anyButton(.highlight, action: {
                        viewModel.onAvatarPressed(avatar: avatar, path: delegate.path)
                    })
                    .removeListRowFormatting()
                }
            }
        }
        .showCustomAlert(alert: $viewModel.showAlert)
        .screenAppearAnalytics(name: "CategoryList")
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
        .task {
            await viewModel.loadAvatars(category: delegate.category)
        }
    }
        
}

#Preview("Has data") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService()))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    let delegate = CategoryListDelegate(path: .constant([]))
    
    return builder.categoryListView(delegate: delegate)
    .previewEnvironment()
}
#Preview("No data") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService(avatars: [])))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    let delegate = CategoryListDelegate(path: .constant([]))
    
    return builder.categoryListView(delegate: delegate)
    .previewEnvironment()
}
#Preview("Slow loading") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService(delay: 10)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    let delegate = CategoryListDelegate(path: .constant([]))
    
    return builder.categoryListView(delegate: delegate)
    .previewEnvironment()
}
#Preview("Error loading") {
    let container = DevPreview.shared.container
    container.register(AvatarManager.self, service: AvatarManager(service: MockAvatarService(delay: 5, showError: true)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    let delegate = CategoryListDelegate(path: .constant([]))
    
    return builder.categoryListView(delegate: delegate)
    .previewEnvironment()
}
