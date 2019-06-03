//
//  preferrenceuiTest.swift
//  JourneyPlannerUITests
//
//  Created by Dalton Chen on 4/06/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import XCTest

class preferrenceuiTest: XCTestCase {

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

    func testExample() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["User"].tap()
        app.buttons["User Preference"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element(boundBy: 1).tap()
        
        let standerdPickerWheel = app.pickerWheels["Standerd"]
        standerdPickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        standerdPickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        XCTAssert(app.staticTexts["Satellite"].exists)
    }

}
