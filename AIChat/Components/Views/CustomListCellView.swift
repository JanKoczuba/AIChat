//
//  CustomListCellView.swift
//  AIChat
//
//  Created by Jan Koczuba on 25/05/2025.
//

import SwiftUI

struct CustomListCellView: View {

    @Environment(\.colorScheme) private var colorScheme

    var imageName: String? = Constants.randomImage
    var title: String? = "Alpha"
    var subtitle: String? = "An alien that is smiling in the park."

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 60)
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.headline)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .padding(.vertical, 4)
        .background(colorScheme.backgroundPrimary)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            CustomListCellView()
            CustomListCellView(imageName: nil)
            CustomListCellView(title: nil)
            CustomListCellView(subtitle: nil)

        }

    }
}
