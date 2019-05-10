//
//  Favourite.h
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favourite : NSObject

@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, assign) double timeValue;

+ (Favourite*)getModelWithData:(NSDictionary*)data;

@end

