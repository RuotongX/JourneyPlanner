//
//  FavouriteDao.m
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "FavouriteDao.h"
#import "NSObject+SQL.h"
#define NAME_THIS_TABLE @"FavouriteTable"
@implementation FavouriteDao

+ (void)init:(NSString *)dataBase {
    [[Persistent getInstance] setDefaultDataBase:dataBase];
    NSString *sql;
    sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(id INTEGER PRIMARY KEY, name TEXT, address TEXT)", NAME_THIS_TABLE];
    [[Persistent getInstance] update:sql];
}

+ (void)addFavouriteWithFavouriteModel:(Favourite *)model {
    NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE name='%@' AND address='%@'",NAME_THIS_TABLE,model.name,model.address];
    NSArray *results    = [[Persistent getInstance] query:selectStr];
    if (results && results.count > 0) {
        NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET name = '%@',address = '%@'  ",NAME_THIS_TABLE,model.name,model.address];
        [[Persistent getInstance] update:updateStr];
    } else {
        NSString *insertStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'(name,address)values('%@','%@')",NAME_THIS_TABLE,model.name,model.address];
        [[Persistent getInstance] update:insertStr];
    }
}

+ (void)removeFavourite:(Favourite *)model {
    NSString *deleteStr = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE name='%@' AND address='%@'",NAME_THIS_TABLE,model.name,model.address];
    [[Persistent getInstance] update:deleteStr];
}

+ (NSArray *)getAllMyFavourites {
    NSMutableArray *favourites = [NSMutableArray new];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",NAME_THIS_TABLE];
    NSArray *results    = [[Persistent getInstance] query:sqlString];
    for (NSDictionary *dict in results) {
        Favourite *model = [Favourite getModelWithData:dict];
        [favourites addObject:model];
    }
    return favourites;
}

@end
