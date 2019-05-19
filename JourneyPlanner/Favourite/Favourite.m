//
//  Favourite.m
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "Favourite.h"

@implementation Favourite

+ (Favourite *)getModelWithData:(NSDictionary*)data {
    Favourite *model = [[Favourite alloc] init];
    if (data && [data.allKeys containsObject:@"name"]) {
        model.name = data[@"name"];
    }
    if (data && [data.allKeys containsObject:@"address"]) {
        model.address = data[@"address"];
    }
    if (data && [data.allKeys containsObject:@"timeValue"]) {
        model.timeValue = [data[@"timeValue"] doubleValue];
    }
    return model;
}

@end
