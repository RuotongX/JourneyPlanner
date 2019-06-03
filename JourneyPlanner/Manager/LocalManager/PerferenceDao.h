//
//  PerferenceDao.h
//  JourneyPlanner
//
//  Created by 周启畅 on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persistent.h"
#import "Perference.h"

NS_ASSUME_NONNULL_BEGIN


// Initialize
@interface PerferenceDao : NSObject

+ (void)init:(NSString *)dataBase;

+ (void)addPerferenceModel:(Perference*)perference;

+ (Perference*)searchPerferenceName;




@end

NS_ASSUME_NONNULL_END
