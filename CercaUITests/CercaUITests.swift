import XCTest

final class CercaUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSplashSaysSurplus() {
        let app = launch(["--hold-splash"])

        XCTAssertTrue(app.staticTexts["Surplus"].waitForExistence(timeout: 4), app.debugDescription)
        shot("splash")
    }

    func testOnboardingReachesTheMap() {
        let app = XCUIApplication()
        app.launchArguments = ["--show-onboarding"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Food you already know."].waitForExistence(timeout: 4), app.debugDescription)
        shot("onboarding")
        app.buttons["next"].tap()
        let start = app.buttons["start"]
        XCTAssertTrue(start.waitForExistence(timeout: 3), app.debugDescription)
        shot("onboarding-gesto")
        start.tap()
        XCTAssertTrue(waitUntilOnScreen(app.otherElements["map"]), app.debugDescription)
    }

    func testDeckEndsWhenNothingIsLeft() {
        let app = launch()
        openFoods(app)

        for _ in 0..<20 {
            app.swipeLeft()
        }

        let empty = app.staticTexts["deck-empty"]
        XCTAssertTrue(empty.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(app.staticTexts["No restaurants nearby"].exists)
        XCTAssertFalse(app.buttons["take"].exists)
        shot("deck-empty")
    }

    func testCarouselListsEveryFood() {
        let app = launch()

        XCTAssertTrue(waitForMap(app), app.debugDescription)
        XCTAssertEqual(
            app.staticTexts.matching(NSPredicate(format: "label == %@", "The pot, 4 min")).count,
            1
        )

        openFoods(app)
        XCTAssertTrue(app.buttons["pass"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["take"].exists)
        shot("arroz")

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Aji chicken"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(labelIsOnScreen(app, "The pot"))
        shot("aji")

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Potato causa"].waitForExistence(timeout: 3), app.debugDescription)
        shot("causa")

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Egg bread"].waitForExistence(timeout: 3), app.debugDescription)
        shot("pan")
    }

    func testPayOpensABoleta() {
        let app = launch()

        openFoods(app)
        let check = visibleButton(app, "take")
        XCTAssertTrue(check.waitForExistence(timeout: 3), app.debugDescription)
        check.tap()
        let pay = visibleButton(app, "pay")
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)
        pay.tap()
        let sheet = app.buttons["sheet"]
        XCTAssertTrue(sheet.waitForExistence(timeout: 3), app.debugDescription)
        app.swipeDown()
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)

        pay.tap()
        XCTAssertTrue(sheet.waitForExistence(timeout: 3))
        sheet.tap()
        XCTAssertTrue(app.otherElements["boleta"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(labelIsOnScreen(app, "Chicken and rice"))
        XCTAssertTrue(labelIsOnScreen(app, "S/ 8.50"))
        shot("boleta")

        app.buttons["back-deck"].tap()
        XCTAssertTrue(app.staticTexts["Aji chicken"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertFalse(labelIsOnScreen(app, "Chicken and rice"))
    }

    func testWearerFlow() {
        let app = launch()

        XCTAssertTrue(waitForMap(app), app.debugDescription)
        shot("map")
        XCTAssertTrue(app.staticTexts["The pot, 4 min"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["foods"].exists)

        openFoods(app)
        shot("aviso")
        let check = visibleButton(app, "take")
        XCTAssertTrue(check.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertFalse(app.buttons["pay"].exists)

        check.tap()
        let pay = visibleButton(app, "pay")
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)
        shot("pay")

        pay.tap()
        let sheet = app.buttons["sheet"]
        XCTAssertTrue(sheet.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(app.staticTexts["Visa"].exists)
        XCTAssertTrue(app.staticTexts["4242"].exists)
        shot("hoja")
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Mastercard"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(app.staticTexts["S/ 8.50"].exists)

        app.swipeDown()
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertFalse(app.staticTexts["120"].exists)
    }

    func testEmptyHasNothingToSwipe() {
        let app = launch(["--empty"])

        let empty = app.staticTexts["empty"]
        XCTAssertTrue(empty.waitForExistence(timeout: 6), app.debugDescription)
        shot("vacio")
        XCTAssertTrue(app.staticTexts["No restaurants nearby"].exists)
        XCTAssertFalse(app.buttons["foods"].exists)
        XCTAssertFalse(app.buttons["take"].exists)
    }

    private func waitForMap(_ app: XCUIApplication) -> Bool {
        let deadline = Date().addingTimeInterval(6)
        while Date() < deadline {
            if app.staticTexts["Surplus"].exists == false, onScreen(app.otherElements["map"]) {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return false
    }

    private func openFoods(_ app: XCUIApplication) {
        XCTAssertTrue(waitForMap(app), app.debugDescription)
        app.buttons["foods"].tap()
        XCTAssertTrue(app.staticTexts["Chicken and rice"].waitForExistence(timeout: 3), app.debugDescription)
    }

    private func launch(_ arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--skip-onboarding"] + arguments
        app.launch()
        return app
    }

    private func visibleButton(_ app: XCUIApplication, _ identifier: String) -> XCUIElement {
        let matches = app.buttons.matching(identifier: identifier)
        for index in 0..<matches.count {
            let button = matches.element(boundBy: index)
            if onScreen(button) {
                return button
            }
        }
        return matches.firstMatch
    }

    private func hasPayButtonOnScreen(_ app: XCUIApplication) -> Bool {
        let matches = app.buttons.matching(identifier: "take")
        for index in 0..<matches.count where onScreen(matches.element(boundBy: index)) {
            return true
        }
        return false
    }

    private func labelIsOnScreen(_ app: XCUIApplication, _ label: String) -> Bool {
        let matches = app.staticTexts.matching(NSPredicate(format: "label == %@", label))
        for index in 0..<matches.count where onScreen(matches.element(boundBy: index)) {
            return true
        }
        return false
    }

    private func onScreen(_ element: XCUIElement) -> Bool {
        guard element.exists else { return false }
        let frame = element.frame
        return frame.minX >= -1 && frame.maxX <= 185 && frame.width > 1
    }

    private func waitUntilOnScreen(_ element: XCUIElement) -> Bool {
        let deadline = Date().addingTimeInterval(6)
        while Date() < deadline {
            if onScreen(element) { return true }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return onScreen(element)
    }

    private func shot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
