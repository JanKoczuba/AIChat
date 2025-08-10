//
//  PaywallView.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//
import SwiftUI

struct PaywallView: View {
    
    @State var presenter: PaywallPresenter

    var body: some View {
        ZStack {
            switch presenter.paywallTest {
            case .custom:
                if presenter.products.isEmpty {
                    ProgressView()
                } else {
                    CustomPaywallView(
                        products: presenter.products,
                        onBackButtonPressed: {
                            presenter.onBackButtonPressed()
                        },
                        onRestorePurchasePressed: {
                            presenter.onRestorePurchasePressed()
                        },
                        onPurchaseProductPressed: { product in
                            presenter.onPurchaseProductPressed(product: product)
                        }
                    )
                }
            case .revenueCat:
                RevenueCatPaywallView()
            case .storeKit:
                StoreKitPaywallView(
                    productIds: presenter.productIds,
                    onInAppPurchaseStart: presenter.onPurchaseStart,
                    onInAppPurchaseCompletion: { (product, result) in
                        presenter.onPurchaseComplete(product: product, result: result)
                    }
                )
            }
        }
        .screenAppearAnalytics(name: "Paywall")
        .task {
            await presenter.onLoadProducts()
        }
    }
    
}

#Preview("Custom") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .custom)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.paywallView(router: router)
    }
    .previewEnvironment()
}
#Preview("StoreKit") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .storeKit)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.paywallView(router: router)
    }
    .previewEnvironment()
}
#Preview("RevenueCat") {
    let container = DevPreview.shared.container
    container.register(ABTestManager.self, service: ABTestManager(service: MockABTestService(paywallTest: .revenueCat)))
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))

    return RouterView { router in
        builder.paywallView(router: router)
    }
    .previewEnvironment()
}
