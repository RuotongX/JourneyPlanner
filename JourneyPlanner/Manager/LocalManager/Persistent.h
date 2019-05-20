//
//  Persistent.h
//  EasyEducation
//
//  Created by zhouqichang.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface Persistent : NSObject

@property (nonatomic, copy  ) NSString        *defaultDataBase;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) FMDatabase      *db;

+ (Persistent*)getInstance;

- (NSString*)dataBasePath;
- (NSDictionary*)resultToDict:(FMResultSet*)resultSet;

- (BOOL)update:(NSString*)sql;
- (void)updateAll:(NSArray*)sqls;

- (NSArray*)query:(NSString*)sql;
- (void)query:(NSString*)query callBack:(void (^)(NSDictionary* point))callBack;
- (void)truncateTable:(NSString*)table;

- (void)dbClose;

@end
