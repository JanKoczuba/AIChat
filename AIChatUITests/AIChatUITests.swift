//
//  AIChatUITests.swift
//  AIChatUITests
//
//  Created by Jan Koczuba on 03/08/2025.
//

import XCTest

@MainActor
final class AIChatUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {

    }

    func testOnboardingFlow() throws {
        // UI tests must launch the application that they test.
                        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"] // "SIGNED_IN"
        app.launch()

        // Welcome View
        app.buttons["StartButton"].tap()

        // Onboarding Intro View
        app.buttons["ContinueButton"].tap()

        // Onboarding Color View
        let colorCircles = app.otherElements.matching(identifier: "ColorCircle")
        let randomIndex = Int.random(in: 0..<colorCircles.count)
        let colorCircle = colorCircles.element(boundBy: randomIndex)
        colorCircle.tap()
        app.buttons["ContinueButton"].tap()

        // Onboarding Completed View
        app.buttons["FinishButton"].tap()

        // Explore View
        let exploreExists = app.navigationBars["Explore"].waitForExistence(timeout: 1)
        XCTAssertTrue(exploreExists)
    }
}
