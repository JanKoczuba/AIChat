//
//  PaywallView.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//

import SwiftUI

struct PaywallView: View {

    @Environment(\.dismiss) private var dismiss
    @State var viewModel: PaywallViewModel

    var body: some View {
        ZStack {
            switch viewModel.paywallTest {
            case .custom:
                if viewModel.products.isEmpty {
                    ProgressView()
                } else {
                    CustomPaywallView(
                        products: viewModel.products,
                        onBackButtonPressed: {
                            viewModel.onBackButtonPressed(onDismiss: {
                                dismiss()
                            })
                        },
                        onRestorePurchasePressed: {
                            viewModel.onRestorePurchasePressed(onDismiss: {
                                dismiss()
                            })
                        },
                        onPurchaseProductPressed: { product in
                            viewModel.onPurchaseProductPressed(product: product, onDismiss: {
                                dismiss()
                            })
                        }
                    )
                }
            case .revenueCat:
                RevenueCatPaywallView()
            case .storeKit:
                StoreKitPaywallView(
                    productIds: viewModel.productIds,
                    onInAppPurchaseStart: viewModel.onPurchaseStart,
                    onInAppPurchaseCompletion: { (product, result) in
                        viewModel.onPurchaseComplete(product: product, result: result, onDismiss: {
                            dismiss()
                        })
                    }
                )
            }
        }
        .screenAppearAnalytics(name: "Paywall")
        .showCustomAlert(alert: $viewModel.showAlert)
        .task {
            await viewModel.onLoadProducts()
        }
    }

}

#Preview("Custom") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .custom)))

    return PaywallView(viewModel: PaywallViewModel(interactor: CoreInteractor(container: container)))
        .previewEnvironment()
}
#Preview("StoreKit") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .storeKit)))

    return PaywallView(viewModel: PaywallViewModel(interactor: CoreInteractor(container: container)))
        .previewEnvironment()
}
#Preview("RevenueCat") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .revenueCat)))

    return PaywallView(viewModel: PaywallViewModel(interactor: CoreInteractor(container: container)))
        .previewEnvironment()
}
