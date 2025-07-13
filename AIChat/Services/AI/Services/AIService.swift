//
//  AIService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//

import SwiftUI

protocol AIService: Sendable {
    func generateImage(input: String) async throws -> UIImage
}
