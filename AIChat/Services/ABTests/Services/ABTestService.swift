//
//  ABTestService.swift
//  AIChat
//
//  Created by Jan Koczuba on 30/07/2025.
//

@MainActor
protocol ABTestService: Sendable {
    var activeTests: ActiveABTests { get }
    func saveUpdatedConfig(updatedTests: ActiveABTests) throws
    func fetchUpdatedConfig() async throws -> ActiveABTests
}
