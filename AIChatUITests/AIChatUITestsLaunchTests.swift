//
//  AIChatUITestsLaunchTests.swift
//  AIChatUITests
//
//  Created by Jan Koczuba on 03/08/2025.
//

import XCTest

final class AIChatUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testSignOutFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "SIGNED_IN"]
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]

        // Explore View
        let exploreExists = app.navigationBars["Explore"].exists
        XCTAssertTrue(exploreExists)

        tabBar.buttons["Profile"].tap()
        let profileExists = app.navigationBars["Profile"].exists
        XCTAssertTrue(profileExists)

        app.navigationBars["Profile"].buttons["Settings"].tap()

        app.collectionViews.buttons["Sign out"].tap()

        let startButtonExists = app.buttons["StartButton"].waitForExistence(timeout: 2)
        XCTAssertTrue(startButtonExists)
    }

    func testCreateAvatarScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "SIGNED_IN", "STARTSCREEN_CREATEAVATAR"]
        app.launch()

        let screenExists = app.navigationBars["Create Avatar"].exists
        XCTAssertTrue(screenExists)
    }
}
