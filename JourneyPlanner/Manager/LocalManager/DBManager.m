//
//  DBManager.m
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "DBManager.h"
#import "FavouriteDao.h"
#define DATABASE @"JourneyPlanner_Sqlite_One.db"
@implementation DBManager

+ (DBManager *)sharedInstance {
    static DBManager *manager = nil;
    if (nil == manager) {
        manager = [[DBManager alloc] init];
    }
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initLocalDatas];
    }
    return self;
}

- (void)initLocalDatas {
    [FavouriteDao init:DATABASE];
}

- (void)addMyFavourite:(Favourite *)favourite {
    [FavouriteDao addFavouriteWithFavouriteModel:favourite];
}


- (void)deleteMyFavourite:(Favourite *)favourite {
    [FavouriteDao removeFavourite:favourite];
}

- (NSArray *)favourites {
  return [FavouriteDao getAllMyFavourites];
}

@end
