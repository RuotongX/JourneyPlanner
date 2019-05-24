//
//  PerferenceDao.m
//  JourneyPlanner
//
//  Created by 周启畅 on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "PerferenceDao.h"
#import "Perference.h"
#define NAME_THIS_TABLE @"NameTable"
#define PERFERENCEID @"perferenceid"

@implementation PerferenceDao

+ (void)init:(NSString *)dataBase {
    [[Persistent getInstance] setDefaultDataBase:dataBase];
    NSString *sql;
    sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(perferenceid TEXT PRIMARY KEY, name TEXT)", NAME_THIS_TABLE];
    [[Persistent getInstance] update:sql];
}

+ (void)addPerferenceModel:(Perference *)model {
    NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE perferenceid ='%@' ",NAME_THIS_TABLE,PERFERENCEID];
    NSArray *results    = [[Persistent getInstance] query:selectStr];
    if (results && results.count > 0) {
        NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET name = '%@',perferenceid = '%@'  ",NAME_THIS_TABLE,PERFERENCEID,model.name];
        [[Persistent getInstance] update:updateStr];
    } else {
        NSString *insertStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'(perferenceid,name)values('%@','%@')",NAME_THIS_TABLE,PERFERENCEID,model.name];
        [[Persistent getInstance] update:insertStr];
    }
}

+ (Perference *)searchPerferenceName {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE perferenceid = '%@'",NAME_THIS_TABLE,PERFERENCEID];
    NSArray *results    = [[Persistent getInstance] query:sqlString];
    if (results && results.count >0) {
        Perference *model = [Perference getModelWithData:results[0]];
        return model;
    }
    return nil;
}



@end
