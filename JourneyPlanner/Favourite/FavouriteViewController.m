//
//  FavouriteViewController.m
//  JourneyPlanner
//
//  Created by Jackie on 2019/5/10.
//  Copyright © 2019 RuotongX. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteManager.h"
#import "SWTableViewCell.h"
#import "Favourite.h"
@interface FavouriteViewController () <UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FavouriteManager *manager;

@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.manager = [FavouriteManager sharedInstance];
    [self.tableView reloadData];
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.favourites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"favouriteCell";
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightUtilityButtons = [self rightButtons];
    }
    Favourite *favourite = self.manager.favourites[indexPath.row];
    cell.textLabel.text = favourite.name;
    cell.detailTextLabel.text = favourite.address;
    return cell;
}

- (NSArray *)rightButtons
{
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
            [self.manager.favourites removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
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

- (FavouriteManager *)manager {
    if (nil == _manager) {
        _manager = [FavouriteManager sharedInstance];
    }
    return _manager;
}

@end
