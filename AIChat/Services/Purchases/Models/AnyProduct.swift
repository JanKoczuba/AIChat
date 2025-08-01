//
//  AnyProduct.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//
import SwiftUI

public struct AnyProduct: Identifiable, Codable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let priceString: String
    public let productDuration: ProductDurationOption?

    public init(
        id: String,
        title: String,
        subtitle: String,
        priceString: String,
        productDuration: ProductDurationOption?
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.priceString = priceString
        self.productDuration = productDuration
    }

    public var priceStringWithDuration: String {
        if let productDuration {
            return "\(priceString) / \(productDuration.rawValue)"
        } else {
            return "\(priceString)"
        }
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case priceString = "price_string"
        case productDuration = "product_duration"
    }

    public var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "product_\(CodingKeys.id.rawValue)": id,
            "product_\(CodingKeys.title.rawValue)": title,
            "product_\(CodingKeys.subtitle.rawValue)": subtitle,
            "product_\(CodingKeys.priceString.rawValue)": priceString,
            "product_\(CodingKeys.productDuration.rawValue)": productDuration?.rawValue
        ]
        return dict.compactMapValues({ $0 })
    }

    public static let mockYearly: AnyProduct = AnyProduct(
        id: "mock.yearly.id",
        title: "Yearly subscription",
        subtitle: "This is a yearly subscription description.",
        priceString: "$99",
        productDuration: .year
    )
    public static let mockMonthly: AnyProduct = AnyProduct(
        id: "mock.monthly.id",
        title: "Monthly subscription",
        subtitle: "This is a monthly subscription description.",
        priceString: "$10",
        productDuration: .month
    )

    public static var mocks: [AnyProduct] {
        [mockYearly, mockMonthly]
    }
}

extension Array where Element == AnyProduct {
    
    public var eventParameters: [String: Any] {
        var dict: [String: Any?] = [
            "products_count": self.count,
            "products_ids": self.compactMap({ $0.id }).sorted().joined(separator: ", "),
            "products_titles": self.compactMap({ $0.title }).sorted().joined(separator: ", "),
        ]
        for product in self {
            for (key, value) in product.eventParameters {
                let uniqueKey = "\(key)_\(product.id)"
                dict[uniqueKey] = value
            }
        }
        return dict.compactMapValues({ $0 })
    }
}

public enum ProductDurationOption: String, Codable, Sendable {
    case year, month, week, day
}
