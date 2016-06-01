//
//  DDQLevelViewController.m
//  QuanMei
//
//  Created by superlian on 15/12/2.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQLevelViewController.h"

#import "DDQUserDetailCell.h"
#import "DDQLevelCell.h"
#import "DDQLoginNumCell.h"

#import "DDQMineInfoModel.h"

@interface DDQLevelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *starAry;
@property (nonatomic, strong) NSArray *activeAry;
@property (nonatomic, strong) NSMutableArray *levelAry;
@property (nonatomic, strong) NSArray *numAry;

@end

@implementation DDQLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的等级";
    self.navigationItem.titleView.tintColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255
                                                               blue:73.f / 255 alpha:1];
    [self localData];
    [self buildTableView];
}

- (void)localData {
    self.starAry = @[@"星级增长",
                     @"新手",
                     @"1星",
                     @"2星",
                     @"3星",
                     @"4星",
                     @"5星",
                     @"1钻",
                     @"2钻",
                     @"3钻",
                     @"4钻",
                     @"5钻",
                     @"皇冠"];
    self.activeAry = @[@"活跃值",
                       @"0-19",
                       @"20-199",
                       @"200-499",
                       @"500-999",
                       @"1000-2999",
                       @"3000-4999",
                       @"5000-9999",
                       @"10000-49999",
                       @"50000-99999",
                       @"100000-499999",
                       @"500000-1999999",
                       @"2000000+"];
    self.levelAry = [NSMutableArray array];
    for (int i = 1; i < 11; i++) {
        NSString *level = [[NSString alloc] init];
        level = [NSString stringWithFormat:@"LV%d",i];
        [self.levelAry addObject:level];
    }
    self.numAry = @[@"注册后首次登陆-9次",
                    @"10-29次",
                    @"30-99次",
                    @"100-199次",
                    @"200-299次",
                    @"300-599次",
                    @"600-999次",
                    @"1000-1399次",
                    @"1400-1999次",
                    @"2000次以上"];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
//buildSubView
- (void)buildTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark  - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 13;
    }else {
        return 11;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DDQUserDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DDQUserDetailCell class])];
        DDQUserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQUserDetailCell class])];
        NSURL *url = [NSURL URLWithString:self.model.userimg];
        [cell.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user1"]];
        cell.userNameLabel.text = self.model.username;
        cell.level.text = [NSString stringWithFormat:@"LV%@",self.model.level];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"活跃值10  新发帖+2  回复+1"];
//        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1] range:NSMakeRange(3, 2)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1] range:NSMakeRange(10, 2)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1] range:NSMakeRange(16, 2)];
        cell.descriptionLabel.attributedText = text;
        return cell;
    }else if (indexPath.section == 1) {
        [tableView registerClass:[DDQLevelCell class] forCellReuseIdentifier:NSStringFromClass([DDQLevelCell class])];
        DDQLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQLevelCell class])];
        cell.leftLabel.text = self.starAry[indexPath.row];
        cell.rightLabel.text = self.activeAry[indexPath.row];
        if (indexPath.row == 0) {
            cell.leftLabel.textColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1];
            cell.rightLabel.textColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1];
            cell.leftLabel.backgroundColor = [UIColor whiteColor];
        } else {
            BOOL userHighlighted = [self.model.star integerValue] == indexPath.row - 1;
            cell.userHighlighted = userHighlighted;
        }
        return cell;
    }else {
        if (indexPath.row == 0) {
            [tableView registerClass:[DDQLoginNumCell class] forCellReuseIdentifier:NSStringFromClass([DDQLoginNumCell class])];
            DDQLoginNumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQLoginNumCell class])];
            return cell;
        }else {
            [tableView registerClass:[DDQLevelCell class] forCellReuseIdentifier:NSStringFromClass([DDQLevelCell class])];
            DDQLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQLevelCell class])];
            cell.leftLabel.text = self.levelAry[indexPath.row - 1];
            cell.rightLabel.text = self.numAry[indexPath.row - 1];
            
            BOOL userHighlighted = [self.model.level integerValue] == indexPath.row;
            cell.userHighlighted = userHighlighted;
            
            return cell;
        }
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 10;
    }
}


@end
