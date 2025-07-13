//
//  MockAIService.swift
//  AIChat
//
//  Created by Jan Koczuba on 13/07/2025.
//
import SwiftUI

struct MockAIService: AIService {
    func generateImage(input: String) async throws -> UIImage {
        try await Task.sleep(for: .seconds(3))
        return UIImage(systemName: "star.fill")!
    }

}
