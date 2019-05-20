//
//  NSObject+SQL.m
//  EasyEducation
//
//  Created by zhouqichang.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "NSObject+SQL.h"
#import "Persistent.h"

@implementation NSObject (SQL)

+ (BOOL)table:(NSString *)table hasColumn:(NSString *)column {
    
    NSString* sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')", table];
    NSArray* result = [[Persistent getInstance] query:sql];
    if (result) {
        for (int i = 0; i < result.count; i++) {
            if ([[[result objectAtIndex:i] objectForKey:@"name"] isEqualToString:column]) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (void)alterOneColumn:(NSString*)column table:(NSString*)table {
    
    // 判断是否存在该字段
    if ([self table:table hasColumn:column]) {
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' INTEGER DEFAULT(0)", table, column];
    [[Persistent getInstance] update:sql];
}

+ (void)alterStringColumn:(NSString*)column table:(NSString*)table {
    
    // 判断是否存在该字段
    if ([self table:table hasColumn:column]) {
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' TEXT", table, column];
    [[Persistent getInstance] update:sql];
}

+ (void)alterDoubleColumn:(NSString*)column table:(NSString*)table {
    
    // 判断是否存在该字段
    if ([self table:table hasColumn:column]) {
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' REAL DEFAULT(0)", table, column];
    [[Persistent getInstance] update:sql];
}

/**
 *  删除表
 *
 *  @param tableName 表名
 */
+ (void)dropTable:(NSString*)tableName {
    
    NSString* sql = [NSString stringWithFormat:@"DROP TABLE '%@'", tableName];
    [[Persistent getInstance] update:sql];
}

/**
 *  返回表总数据条数
 *
 *  @param tableName 表名
 *
 *  @return 条数
 */
+ (int)totalRows:(NSString*)tableName {
    
    NSString* sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM '%@'", tableName];
    NSArray* result = [[Persistent getInstance] query:sql];
    if (result && result.count) {
        return [[[result firstObject] objectForKey:@"COUNT(*)"] intValue];
    }
    return 0;
}

/**
 *  判断表是否存在
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
+ (BOOL)hasTable:(NSString*)tableName {
    NSString* sql = [NSString stringWithFormat:@"SELECT COUNT(*) as 'count' from sqlite_master where type ='table' and name = '%@'", tableName];
    NSArray* result = [[Persistent getInstance] query:sql];
    if (result && result.count) {
        NSDictionary* dict = [result firstObject];
        return [[dict objectForKey:@"count"] boolValue];
    }
    return NO;
}

/**
 *  重命名表名
 *
 *  @param tableName 原表名
 *  @param newName   新表名
 */
+ (void)renameTable:(NSString*)tableName to:(NSString*)newName {
    
    if ([self hasTable:tableName]) {
        NSString* sql = [NSString stringWithFormat:@"ALTER TABLE '%@' RENAME TO '%@'", tableName, newName];
        [[Persistent getInstance] update:sql];
    }
    
}

@end
