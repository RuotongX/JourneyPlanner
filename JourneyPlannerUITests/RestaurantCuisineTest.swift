//
//  RestaurantCuisineTest.swift
//  JourneyPlannerUITests
//
//  Created by Dalton Chen on 4/06/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import XCTest

class RestaurantCuisineTest: XCTestCase {

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
        app.tabBars.buttons["Explore"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Chinese"]/*[[".cells.staticTexts[\"Chinese\"]",".staticTexts[\"Chinese\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
    }

}
