//
//  Perference.m
//  JourneyPlanner
//
//  Created by 周启畅 on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "Perference.h"

@implementation Perference
+ (Perference *)getModelWithData:(NSDictionary*)data {
    Perference *model = [[Perference alloc] init];
    if (data && [data.allKeys containsObject:@"name"]) {
        model.name = data[@"name"];
    }
    if (data && [data.allKeys containsObject:@"perferenceid"]) {
       model.perferenceid = data[@"perferenceid"];
    }
    return model;
}
@end
