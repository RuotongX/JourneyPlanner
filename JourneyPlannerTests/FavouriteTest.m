//
//  FavouriteTest.m
//  JourneyPlannerTests
//
//  Created by Jackie on 2019/5/30.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FavouriteViewController.h"
@interface FavouriteTest : XCTestCase

@property (nonatomic, strong) FavouriteViewController *favourite;

@end

@implementation FavouriteTest

- (void)setUp {
    self.favourite = [[FavouriteViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testDeleteFavourite {
    [self.favourite deleteMyFavourite];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
