//
//  DBManager.h
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"
@interface DBManager : NSObject

+ (DBManager*)sharedInstance;

- (void)addMyFavourite:(Favourite*)favourite;

- (void)deleteMyFavourite:(Favourite*)favourite;

- (NSArray*)favourites;

@end

