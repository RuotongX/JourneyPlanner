//
//  JourneyPlannerUITests.swift
//  JourneyPlannerUITests
//
//  Created by Dalton Chen on 4/06/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import XCTest

class planCreatorButton: XCTestCase {

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

    func testSelectAttraction(){
        
        let app = XCUIApplication()
        app.buttons["Home plan"].tap()
        app.buttons["Plan White Whiteadd new 1x"].tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        aKey.tap()
        
        let bKey = app/*@START_MENU_TOKEN@*/.keys["b"]/*[[".keyboards.keys[\"b\"]",".keys[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()
        bKey.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        cKey.tap()
        app.alerts["Plan Name"].buttons["OK"].tap()
        app.buttons["Plan White Whitereturn key 1x"].tap()
        
        app.buttons["Home plan"].tap()
        XCTAssert(app.staticTexts["abcd"].exists)
    }

}
