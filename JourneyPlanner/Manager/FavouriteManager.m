//
//  FavouriteManager.m
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
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

- (NSMutableDictionary *)favourites {
    if (nil == _favourites) {
        _favourites = [NSMutableDictionary dictionary];
    }
    return _favourites;
}

@end
