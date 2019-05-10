//
//  FavouriteManager.m
//  JourneyPlanner
//
//  Created by Jackie on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "FavouriteManager.h"

@implementation FavouriteManager

+ (FavouriteManager *)sharedInstance {
    static FavouriteManager *manager = nil;
    if (manager == nil) {
        manager = [[FavouriteManager alloc] init];
        [manager favourites];
    }
    return manager;
}

- (NSMutableArray *)favourites {
    if (nil == _favourites) {
        _favourites = [NSMutableArray array];
    }
    return _favourites;
}

@end
