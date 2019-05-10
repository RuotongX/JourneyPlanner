//
//  FavouriteManager.h
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FavouriteManager : NSObject

@property (nonatomic, copy) NSMutableArray *favourites;

+ (FavouriteManager *)sharedInstance;

@end
