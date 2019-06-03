//
//  Perference.h
//  JourneyPlanner
//
//  Created by 周启畅 on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

// This is favourite Model View Controller 
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Perference : NSObject

@property (nonatomic, copy  ) NSString *perferenceid;
@property (nonatomic, copy  ) NSString *name;

+ (Perference *)getModelWithData:(NSDictionary*)data;


@end

NS_ASSUME_NONNULL_END
