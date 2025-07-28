//
//  ABTestManager.swift
//  AIChat
//
//  Created by Jan Koczuba on 27/07/2025.
//
import SwiftUI

enum CategoryRowTestOption: String, Codable, CaseIterable {
    case original, top, hidden

    static var `default`: Self {
        .original
    }
}

struct ActiveABTests: Codable {

    private(set) var createAccountTest: Bool
    private(set) var onboardingCommunityTest: Bool
    private(set) var categoryRowTest: CategoryRowTestOption

    init(createAccountTest: Bool, onboardingCommunityTest: Bool, categoryRowTest: CategoryRowTestOption) {
        self.createAccountTest = createAccountTest
        self.onboardingCommunityTest = onboardingCommunityTest
        self.categoryRowTest = categoryRowTest
    }

    enum CodingKeys: String, CodingKey {
        case createAccountTest = "_202507_CreateAccTest"
        case onboardingCommunityTest = "_202507_OnbCommunityTest"
        case categoryRowTest = "_202507_CategoryRowTest"
    }

    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "test\(CodingKeys.createAccountTest.rawValue)": createAccountTest,
            "test\(CodingKeys.onboardingCommunityTest.rawValue)": onboardingCommunityTest,
            "test\(CodingKeys.categoryRowTest.rawValue)": categoryRowTest.rawValue
        ]
        return dict.compactMapValues({ $0 })
    }

    mutating func update(createAccountTest newValue: Bool) {
        createAccountTest = newValue
    }

    mutating func update(onboardingCommunityTest newValue: Bool) {
        onboardingCommunityTest = newValue
    }

    mutating func update(categoryRowTest newValue: CategoryRowTestOption) {
        categoryRowTest = newValue
    }
}

protocol ABTestService {
    var activeTests: ActiveABTests { get }
    func saveUpdatedConfig(updatedTests: ActiveABTests) throws
}

class MockABTestService: ABTestService {

    var activeTests: ActiveABTests

    init(
        createAccountTest: Bool? = nil,
        onboardingCommunityTest: Bool? = nil,
        categoryRowTest: CategoryRowTestOption? = nil
    ) {
        self.activeTests = ActiveABTests(
            createAccountTest: createAccountTest ?? false,
            onboardingCommunityTest: onboardingCommunityTest ?? false,
            categoryRowTest: categoryRowTest ?? .default
        )
    }

    func saveUpdatedConfig(updatedTests: ActiveABTests) throws {
        activeTests = updatedTests
    }
}

class LocalABTestService: ABTestService {

    @UserDefault(key: ActiveABTests.CodingKeys.createAccountTest.rawValue, startingValue: .random())
    private var createAccountTest: Bool

    @UserDefault(key: ActiveABTests.CodingKeys.onboardingCommunityTest.rawValue, startingValue: .random())
    private var onboardingCommunityTest: Bool

    @UserDefaultEnum(key: ActiveABTests.CodingKeys.categoryRowTest.rawValue, startingValue: CategoryRowTestOption.allCases.randomElement()!)
    private var categoryRowTest: CategoryRowTestOption

    var activeTests: ActiveABTests {
        ActiveABTests(
            createAccountTest: createAccountTest,
            onboardingCommunityTest: onboardingCommunityTest,
            categoryRowTest: categoryRowTest
        )
    }

    func saveUpdatedConfig(updatedTests: ActiveABTests) throws {
        createAccountTest = updatedTests.createAccountTest
        onboardingCommunityTest = updatedTests.onboardingCommunityTest
        categoryRowTest = updatedTests.categoryRowTest
    }
}

@MainActor
@Observable
class ABTestManager {

    private let service: ABTestService
    private let logManager: LogManager?

    var activeTests: ActiveABTests

    init(service: ABTestService, logManager: LogManager? = nil) {
        self.logManager = logManager
        self.service = service
        self.activeTests = service.activeTests
        self.configure()
    }

    private func configure() {
        activeTests = service.activeTests
        logManager?.addUserProperties(dict: activeTests.eventParameters, isHighPriority: false)
    }

    func override(updateTests: ActiveABTests) throws {
        try service.saveUpdatedConfig(updatedTests: updateTests)
        configure()
    }

}

