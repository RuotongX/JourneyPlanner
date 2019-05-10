//
//  NSObject+SQL.h
//  EasyEducation
//
//  Created by zhouqichang.
//  Copyright © 2018年 Kario. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SQL)

+ (BOOL)table:(NSString *)table hasColumn:(NSString *)column;

+ (void)alterOneColumn:(NSString*)column table:(NSString*)table;

+ (void)alterStringColumn:(NSString*)column table:(NSString*)table;

+ (void)alterDoubleColumn:(NSString*)column table:(NSString*)table;

/**
 *  删除表
 *
 *  @param tableName 表名
 */
+ (void)dropTable:(NSString*)tableName;

/**
 *  返回表总数据条数
 *
 *  @param tableName 表名
 *
 *  @return 条数
 */
+ (int)totalRows:(NSString*)tableName;

/**
 *  判断表是否存在
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
+ (BOOL)hasTable:(NSString*)tableName;

/**
 *  重命名表名
 *
 *  @param tableName 原表名
 *  @param newName   新表名
 */
+ (void)renameTable:(NSString*)tableName to:(NSString*)newName;

@end
