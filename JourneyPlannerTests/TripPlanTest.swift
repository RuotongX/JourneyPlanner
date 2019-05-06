//
//  TripPlanTest.swift
//  JourneyPlannerTests
//
//  Created by Dalton Chen on 6/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import XCTest
import CoreLocation
@testable import JourneyPlanner

class TripPlanTest: XCTestCase {
    
    var testPlan : TripPlan!

    override func setUp() {
        super.setUp()
        
        var trips : [SmallTripInformation] = []
        var testTrip = SmallTripInformation(name: "ABC", location: CLLocation(latitude: -36.8657943, longitude: 174.7615962), staylength: 1, arrangement: 2)
        trips.append(testTrip)
        
        var locationInformation = LocationInformation(cityName: "Test", lontitude: -36.8657943, latitude: 174.7615962, zipCode: "123")
        
        testPlan = TripPlan(trips: trips, firstCity: locationInformation, distances: 123.0, PlanName: "my plan")
    }

    override func tearDown() {
        testPlan = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAdding(){
        var testTrip = SmallTripInformation(name: "test2", location: CLLocation(latitude: -32.8653943, longitude: 164.7615162), staylength: 12, arrangement: 1)
        testPlan.addTrip(trip: testTrip)
        
        XCTAssert(testPlan.trips.count == 2, "Nope")
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
