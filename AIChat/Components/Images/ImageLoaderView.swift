//
//  ImageLoaderView.swift
//  AIChat
//
//  Created by Jan Koczuba on 18/05/2025.
//

import SDWebImageSwiftUI
import SwiftUI

struct ImageLoaderView: View {

    var urlString: String = Constants.randomImage
    var resizingMode: ContentMode = .fill

    var body: some View {
        Rectangle()
            .opacity(0)
            .overlay(
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            )
            .clipped()

    }
}

#Preview {
    ImageLoaderView()
}
