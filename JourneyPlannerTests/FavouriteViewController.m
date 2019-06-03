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
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface FavouriteViewController () <UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *remindText;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *favourites;
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.remindText];
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
    if (self.favourites && self.favourites.count > 0) {
        self.remindText.hidden = YES;
    } else {
        self.remindText.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)deleteMyFavourite {
    if (self.favourites && self.favourites.count > 0) {
        Favourite *favourite = self.favourites[0];
        [[DBManager sharedInstance] deleteMyFavourite:favourite];
        [self refreshFavourites];
    }
}

#pragma mark - Setters && Getters
- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        CGFloat height = 20;
        if (iPhoneX) {
            height = 44;
        }
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height+26, KWidth, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"Favourite";
        _titleLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightLight];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)remindText {
    if (nil == _remindText) {
        CGFloat height = 20;
        if (iPhoneX) {
            height = 44;
        }
        CGFloat titleH = 26+height+49;
        CGFloat centerY = (KHeight-titleH)*0.5;
        _remindText = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY-15, KWidth, 30)];
        _remindText.textColor = [UIColor grayColor];
        _remindText.text = @"No Favourite";
        _remindText.font = [UIFont systemFontOfSize:21 weight:UIFontWeightLight];
        _remindText.textAlignment = NSTextAlignmentCenter;
        _remindText.hidden = YES;
    }
    return _remindText;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        CGFloat maxY   = CGRectGetMaxY(self.titleLabel.frame)+13;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, maxY, KWidth, KHeight-maxY)];
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
