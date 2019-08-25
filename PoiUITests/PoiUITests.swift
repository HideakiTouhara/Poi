//
//  PoiUITests.swift
//  PoiUITests
//
//  Created by HideakiTouhara on 2019/08/25.
//  Copyright © 2019 HideakiTouhara. All rights reserved.
//

import XCTest

class PoiUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testButtonIsEnabled() {
        let app = XCUIApplication()
        var buttons = [XCUIElement]()
        buttons.append(app.buttons["goodButton"])
        buttons.append(app.buttons["badButton"])
        buttons.append(app.buttons["reloadButton"])
        buttons.append(app.buttons["undoButton"])
        buttons.forEach { (button) in
            XCTAssertTrue(button.isEnabled)
        }
    }

}
