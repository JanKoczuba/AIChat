//
//  ColorScheme.swift
//  AIChat
//
//  Created by Jan Koczuba on 27/07/2025.
//

import SwiftUI

extension ColorScheme {

    var backgroundPrimary: Color {
        self == .dark ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground)
    }

    var backgroundSecondary: Color {
        self == .dark ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground)
    }

}
