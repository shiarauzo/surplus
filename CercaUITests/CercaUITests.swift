import XCTest

final class CercaUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSplashSaysSurplus() {
        let app = XCUIApplication()
        app.launchArguments = ["--hold-splash"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Surplus"].waitForExistence(timeout: 4), app.debugDescription)
    }

    func testWearerFlow() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.otherElements["mapa"].waitForExistence(timeout: 6), app.debugDescription)
        shot("mapa")
        XCTAssertTrue(app.staticTexts["La olla, 4 min"].exists)
        XCTAssertTrue(app.staticTexts["Rosa, 10 min"].exists)
        XCTAssertTrue(app.staticTexts["Don Pan, 14 min"].exists)

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Arroz con pollo"].waitForExistence(timeout: 3), app.debugDescription)
        shot("aviso")
        let pay = visiblePayButton(app)
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)

        pay.tap()
        let sheet = app.buttons["hoja"]
        XCTAssertTrue(sheet.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(app.staticTexts["Doble clic para pagar"].exists)
        shot("hoja")
        XCTAssertTrue(app.staticTexts["S/ 8.50"].exists)

        app.swipeDown()
        XCTAssertTrue(pay.waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertFalse(app.staticTexts["Listo"].exists)

        pay.tap()
        XCTAssertTrue(sheet.waitForExistence(timeout: 3))
        sheet.tap()
        XCTAssertTrue(app.staticTexts["Listo"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(onScreen(app.staticTexts["Arroz con pollo"]))
        shot("listo")
        XCTAssertFalse(hasPayButtonOnScreen(app))

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Causa limeña"].waitForExistence(timeout: 3), app.debugDescription)
        shot("causa")
        XCTAssertTrue(onScreen(app.staticTexts["Menú Rosa"]))
        XCTAssertTrue(hasPayButtonOnScreen(app))
        XCTAssertFalse(onScreen(app.staticTexts["Listo"]))

        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Pan de yema"].waitForExistence(timeout: 3), app.debugDescription)
        XCTAssertTrue(app.staticTexts["Don Pan"].exists)
        XCTAssertTrue(visiblePayButton(app).exists)

        app.swipeRight()
        app.swipeRight()
        app.swipeRight()
        XCTAssertTrue(app.otherElements["mapa"].waitForExistence(timeout: 3), app.debugDescription)
    }

    func testEmptyHasNothingToSwipe() {
        let app = XCUIApplication()
        app.launchArguments = ["--empty"]
        app.launch()

        let empty = app.staticTexts["vacio"]
        XCTAssertTrue(empty.waitForExistence(timeout: 6), app.debugDescription)
        shot("vacio")
        XCTAssertTrue(app.staticTexts["Nada cerca"].exists)
        XCTAssertTrue(app.staticTexts["Sin listados"].exists)
        app.swipeLeft()
        XCTAssertTrue(empty.waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["pagar"].exists)
    }

    private func visiblePayButton(_ app: XCUIApplication) -> XCUIElement {
        let matches = app.buttons.matching(identifier: "pagar")
        for index in 0..<matches.count {
            let button = matches.element(boundBy: index)
            if onScreen(button) {
                return button
            }
        }
        return matches.firstMatch
    }

    private func hasPayButtonOnScreen(_ app: XCUIApplication) -> Bool {
        let matches = app.buttons.matching(identifier: "pagar")
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

    private func shot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
