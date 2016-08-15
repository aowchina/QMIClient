//
//  DDQUserDiaryViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserDiaryViewController.h"

#import "DDQUserDiaryViewCell.h"
#import "DDQUserCommentViewCell.h"

#import "DDQReplayViewController.h"


@interface DDQUserDiaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *mainTableView;

@end

@implementation DDQUserDiaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(popBackToViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [[UINavigationBar appearance] setTintColor:[UIColor meiHongSe]];
    self.navigationItem.title = @"日记详情";
    //调个小方法
    [self initTableView];
    
    
    [self replyButton];
}

#pragma mark - item target and action
-(void)popBackToViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
-(void)initTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-30) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableHeaderView = [self setAHeaderView];
}



#pragma mark - 回复按钮
- (void)replyButton
{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0   , self.view.bounds.size.height-30 -49 ,   self.view.bounds.size.width   , 30)];
    
    blackView.alpha = 0.8f;
    
    blackView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:blackView];
    
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    button1.frame = CGRectMake(0  ,  0  , blackView.frame.size.width/2-1, blackView.frame.size.height);
    
    [button1 setTitle:@"很有用" forState:(UIControlStateNormal)];
    [blackView addSubview:button1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(blackView.frame.size.width/2-1, 0, 2, blackView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    [blackView addSubview:view];
    
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    button2.frame = CGRectMake(blackView.frame.size.width/2-2 ,  0  , button1.frame.size.width , button1.frame.size.height);
    
    
    [button2 setTitle:@"回复" forState:(UIControlStateNormal)];
    
    [button2 addTarget:self action:@selector(replayButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    [blackView addSubview:button2];
    
}
- (void)replayButtonClicked
{
	if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] > 0 && [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]) {
		
		DDQReplayViewController * replayVC = [[DDQReplayViewController alloc] init];
		
		replayVC.hidesBottomBarWhenPushed  = YES;
		
		[self.navigationController pushViewController:replayVC animated:YES];

	} else {
	
		DDQLoginViewController *loignC = [[DDQLoginViewController alloc] init];
		loignC.hidesBottomBarWhenPushed = YES;
		
		[self.navigationController pushViewController:loignC animated:YES];
		
	}
	
}

/**
 *  布局头视图
 *
 *  @return 返回一个布局好的头视图
 */
-(UIView *)setAHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.2)];
    [headerView setBackgroundColor:[UIColor myGrayColor]];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.1)];
    [headerView addSubview:userView];
    [userView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *userImage = [[UIImageView alloc] init];
    [userView addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView.mas_centerY);
        make.left.equalTo(userView.mas_left).with.offset(self.view.bounds.size.width*0.01);
        if (kScreenHeight == 480) {
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        } else if (kScreenHeight == 568) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        } else if (kScreenHeight == 667) {
            make.width.equalTo(@45);
            make.height.equalTo(@45);
        } else {
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }
    }];
    if (kScreenHeight == 480) {
        [userImage.layer setCornerRadius:15.0f];
        
    } else if (kScreenHeight == 568) {
        [userImage.layer setCornerRadius:20.0f];
        
    } else if (kScreenHeight == 667) {
        [userImage.layer setCornerRadius:22.5f];
        
    } else {
        [userImage.layer setCornerRadius:25.0f];
        
    }
    [userImage setBackgroundColor:[UIColor orangeColor]];
    
    UILabel *userLabel = [[UILabel alloc] init];
    [userView addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImage.mas_right).with.offset(5);
        make.bottom.equalTo(userImage.mas_centerX);
        make.height.equalTo(userImage.mas_height).with.multipliedBy(0.5);
        make.width.offset(self.view.bounds.size.width*0.2);
    }];
    [userLabel setBackgroundColor:[UIColor redColor]];
    [userLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    UILabel *releaseTime = [[UILabel alloc] init];
    [userView addSubview:releaseTime];
    [releaseTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userLabel.mas_left).with.offset(5);
        make.top.equalTo(userView.mas_centerY);
        make.width.equalTo(userLabel.mas_width);
        make.height.equalTo(userLabel.mas_height);
    }];
    [releaseTime setBackgroundColor:[UIColor cyanColor]];
    [releaseTime setFont:[UIFont systemFontOfSize:12.0f]];
    
    UIImageView *userType = [[UIImageView alloc] init];
    [userView addSubview:userType];
    [userType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView.mas_centerY);
        make.right.equalTo(userView.mas_right);
        make.width.equalTo(userView.mas_width).with.multipliedBy(0.15);
        make.height.equalTo(releaseTime.mas_height);
    }];
    userType.image = [UIImage imageNamed:@"lz"];
    
    UILabel *diaryTitleLabel = [[UILabel alloc] init];
    [headerView addSubview:diaryTitleLabel];
    [diaryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).with.offset(5);
        make.top.equalTo(userView.mas_bottom).with.offset(10);
        make.width.equalTo(headerView.mas_width);
        make.height.equalTo(headerView.mas_height).with.multipliedBy(0.2);
    }];
    [diaryTitleLabel setNumberOfLines:0];
    [diaryTitleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    diaryTitleLabel.text = @"我叫咚咚枪";
    
    UILabel *hospitalLabel = [[UILabel alloc] init];
    [headerView addSubview:hospitalLabel];
    [hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(diaryTitleLabel.mas_bottom);
        make.height.offset(20);
        make.width.equalTo(headerView.mas_width).with.multipliedBy(0.6);
        make.left.equalTo(diaryTitleLabel.mas_left);
    }];
    NSString *str = [NSString stringWithFormat:@"医院:%@",@"北京市京城医院"];
    hospitalLabel.text = str;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [headerView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hospitalLabel.mas_right);
        make.width.equalTo(headerView.mas_width).with.multipliedBy(0.4);
        make.height.equalTo(hospitalLabel.mas_height);
        make.centerY.equalTo(hospitalLabel.mas_centerY);
    }];
    NSString *string = [NSString stringWithFormat:@"花费:%@",@"1万-100万"];
    priceLabel.text = string;
    return headerView;
}

#pragma mark - delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        static NSString *identifier1 = @"diary";
        if ([indexPath row] == 10) {
            UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
//            UILabel *moreLabel = [[UILabel alloc]init];
//            
//            moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
//            moreLabel.text = @"查看更多";
//            
//            moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
//            [moreCell.contentView addSubview:moreLabel];
//            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
//            imageView.image = [UIImage imageNamed:@"puss_load_more"];
//            
//            [moreCell.contentView addSubview:imageView];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 45)];
            [moreCell.contentView addSubview:view];
            moreCell.backgroundColor = [UIColor backgroundColor];
            view.backgroundColor = [UIColor whiteColor];
            return moreCell;
            
        } else {
            DDQUserDiaryViewCell *diaryCell = [[DDQUserDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return diaryCell;
//            DDQGroupArticleModel *articleModel = [_articleModelArray objectAtIndex:indexPath.row];
//            DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
//            diaryCell.articleModel = articleModel;
//            diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
//            diaryCell.backgroundColor = [UIColor myGrayColor];
//            return diaryCell;
        }

        
    } else {
        static NSString *identifier = @"cell";
        DDQUserCommentViewCell *commentCell = [[DDQUserCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        commentCell.backgroundColor = [UIColor backgroundColor];
        
        return commentCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 10) {
            return 50;
        } else {
            return kScreenHeight*0.6;
        }
    } else {
        return kScreenHeight * 0.6;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 30;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        [view setBackgroundColor:[UIColor myGrayColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        [label setText:@"全部评论(134)"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
        return view;
        
    } else {
        return nil;
    }
}

@end
