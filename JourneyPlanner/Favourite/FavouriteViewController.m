//
//  FavouriteViewController.m
//  JourneyPlanner
//
//  Created by zhouqichang on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "FavouriteViewController.h"
#import "SWTableViewCell.h"
#import "Favourite.h"
#import "DBManager.h"
@interface FavouriteViewController () <UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *favourites;
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFavourites];
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favourites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"favouriteCell";
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightUtilityButtons = [self rightButtons];
    }
    Favourite *favourite = self.favourites[indexPath.row];
    cell.textLabel.text = favourite.name;
    cell.detailTextLabel.text = favourite.address;
    return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Favourite *favourite = self.favourites[indexPath.row];
            [[DBManager sharedInstance] deleteMyFavourite:favourite];
            [self refreshFavourites];
            break;
        }
        default:
            break;
    }
}

- (void)refreshFavourites {
    self.favourites = [NSMutableArray arrayWithArray:[DBManager sharedInstance].favourites];
    [self.tableView reloadData];
}

#pragma mark - Setters && Getters
- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)favourites {
    if (nil == _favourites) {
        _favourites = [NSMutableArray array];
    }
    return _favourites;
}

@end
