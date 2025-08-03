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
        app.launchArguments = ["UI_TESTING"]
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

    func testOnboardingFlowWithCommunityScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "ONBCOMMTEST"] // "SIGNED_IN"
        app.launch()

        // Welcome View
        app.buttons["StartButton"].tap()

        // Onboarding Intro View
        app.buttons["ContinueButton"].tap()

        // Onboarding Community View
        app.buttons["OnboardingCommunityContinueButton"].tap()

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

    func testTabBarFlow() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "SIGNED_IN"]
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]

        // Explore View
        let exploreExists = app.navigationBars["Explore"].exists
        XCTAssertTrue(exploreExists)

        // Click hero cell
        app.collectionViews.scrollViews.otherElements.buttons.firstMatch.tap()

        // Chat View
        let textFieldExists = app.textFields["ChatTextField"].exists
        XCTAssertTrue(textFieldExists)

        app.navigationBars.buttons.firstMatch.tap()
        let exploreExists2 = app.navigationBars["Explore"].exists
        XCTAssertTrue(exploreExists2)

        tabBar.buttons["Chats"].tap()
        let chatsExists = app.navigationBars["Chats"].exists
        XCTAssertTrue(chatsExists)

        app.collectionViews.scrollViews.otherElements.buttons.firstMatch.tap()

        let textFieldExists2 = app.textFields["ChatTextField"].exists
        XCTAssertTrue(textFieldExists2)

        app.navigationBars.buttons.firstMatch.tap()
        let chatsExists2 = app.navigationBars["Chats"].exists
        XCTAssertTrue(chatsExists2)

        tabBar.buttons["Profile"].tap()
        let profileExists = app.navigationBars["Profile"].exists
        XCTAssertTrue(profileExists)

        app.collectionViews.buttons.element(boundBy: 1).tap()

        let textFieldExists3 = app.textFields["ChatTextField"].exists
        XCTAssertTrue(textFieldExists3)

        app.navigationBars.buttons.firstMatch.tap()

        let profileExists2 = app.navigationBars["Profile"].exists
        XCTAssertTrue(profileExists2)

        tabBar.buttons["Explore"].tap()
        let exploreExists3 = app.navigationBars["Explore"].exists
        XCTAssertTrue(exploreExists3)
    }
}
