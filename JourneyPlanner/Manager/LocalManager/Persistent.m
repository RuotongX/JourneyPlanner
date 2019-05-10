//
//  Persistent.m
//  EasyEducation
//
//  Created by zhouqichang.
//  Copyright © 2018年 Kario. All rights reserved.
//

#import "Persistent.h"

@implementation Persistent

+ (Persistent*)getInstance {
    static Persistent *instance = nil;
    if (nil == instance) {
        instance = [[Persistent alloc] init];
    }
    return instance;
}

- (void)setDefaultDataBase:(NSString *)defaultDataBase {
    _defaultDataBase = defaultDataBase;

    NSString *dataBasePath = [self dataBasePath];
    _db = [FMDatabase databaseWithPath:dataBasePath];

    if (nil == _dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    }
}

- (void)dbClose {
    [_db close];
}

- (NSString *)dataBasePath {
    NSArray *filePath      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath   = [documentPath stringByAppendingPathComponent:self.defaultDataBase];
    return dbFilePath;
}

- (NSDictionary *)resultToDict:(FMResultSet *)resultSet {
    NSDictionary *result = [NSMutableDictionary new];
    for (int i = 0; i < [resultSet columnCount]; i ++) {
        [result setValue:[resultSet objectForColumnIndex:i]  forKey:[resultSet columnNameForIndex:i]];
    }
    return result;
}

- (NSArray *)query:(NSString *)query {
    __block NSMutableArray *result = [NSMutableArray new];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            [NSException raise:@"FileOpenException" format:@"DBerror:Couldn't open specified db file:%@",[self dataBasePath]];
        } else {
            FMResultSet *resultSet = [db executeQuery:query];
            if (nil == resultSet) {
                [resultSet close];
            } else {
                while ([resultSet next]) {
                    [result addObject:[self resultToDict:resultSet]];
                }
                [resultSet close];
                
                if ([db hadError]) {
                    NSString *error = [NSString stringWithString:[[db lastError] description]];
                    [NSException raise:@"ExecuteException"
                                format:@"Error:%@\nQuery:%@",error,query];
                }
            }
        }
    }];
    
    return (NSArray*)result;
}

- (void)query:(NSString *)query callBack:(void (^)(NSDictionary *))callBack {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            [NSException raise:@"FileOpenException" format:@"DBerror:Couldn't open specified db file:%@",[self dataBasePath]];
        } else {
            FMResultSet *resultSet = [db executeQuery:query];
            if (nil == resultSet) {
                [resultSet close];
            } else {
                while ([resultSet next]) {
                    callBack([self resultToDict:resultSet]);
                }
                [resultSet close];
                
                if([db hadError]) {
                    NSString *error = [NSString stringWithString:[[db lastError] description]];
                    [NSException raise:@"ExecuteException"
                                format:@"Error:%@\nQuery:%@",error,query];
                }
            }
        }
    }];
}

- (void)updateAll:(NSArray*)sqls {
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db open]) {
            [NSException raise:@"FileOpenException" format:@"DBerror:Couldn't open specified db file:%@",[self dataBasePath]];
        } else {
            for (int i = 0; i < sqls.count; i++) {
                NSString* sql = [sqls objectAtIndex:i];
                if( ![db executeUpdate:sql] ){
                    NSLog(@"DBerror:%@\nQuery:%@",[[db lastError] description],sql);
                    [db rollback];
                    return;
                }
            }
        }
    }];
}

- (BOOL)update:(NSString *)sql {
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db open]) {
            [NSException raise:@"FileOpenException" format:@"DBerror:Couldn't open specified db file:%@",[self dataBasePath]];
        } else {
            [db executeUpdate:sql];
        }
    }];
    return YES;
}

- (void)truncateTable:(NSString*)table {
    [self update:[NSString stringWithFormat:@"DELETE FROM %@",table]];
    [self update:[NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=1 WHERE name='%@'",table]];
}

- (void)destroy:(NSString*)table value:(int)value {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE uid='%d'", table, value];
    [self update:sql];
}



@end
