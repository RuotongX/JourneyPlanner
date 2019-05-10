//
//  FavouriteDao.h
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persistent.h"
#import "Favourite.h"
@interface FavouriteDao : NSObject


@property(nonatomic, readwrite) NSString* defaultDataBase;

// 初始化
+ (void)init:(NSString *)dataBase;

+ (void)addFavouriteWithFavouriteModel:(Favourite*)favourite;

+ (void)removeFavourite:(Favourite*)favourite;

+ (NSArray*)getAllMyFavourites;

@end
