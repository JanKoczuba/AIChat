//
//  CategoryRowTestOption.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//
import SwiftUI

enum CategoryRowTestOption: String, Codable, CaseIterable {
    case original, top, hidden

    static var `default`: Self {
        .original
    }
}
