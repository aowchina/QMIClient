//
//  DDQMyDiaryViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyDiaryViewController.h"
#import "DDQPostingViewController.h"
#import "DDQGroupHeaderModel.h"
#import "DDQFirstDiaryChildController.h"
#import "DDQSecondDiaryChildController.h"


@interface DDQMyDiaryViewController () 
/**
 *  主tableview
 */
@property (strong,nonatomic) UITableView *mainTableView;
///**
// *  子tableview
// */
//@property (strong,nonatomic) UITableView *childTableView;
///**
// *  抽屉页面
// */
//@property (strong,nonatomic) UIView *drawerView;
//
//@property (strong,nonatomic) NSMutableArray *headerModelArray;
/**
 *  第一个按钮
 */
@property (strong,nonatomic) UIButton *first_Button;
/**
 *  第二个按钮
 */
@property (strong,nonatomic) UIButton *second_Button;

@property (strong,nonatomic) UIButton *temp_button;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat new_cellHeight;

@property (strong,nonatomic) DDQFirstDiaryChildController *firstChildVC;
@property (strong,nonatomic) DDQSecondDiaryChildController *secondChildVC;
@end

@implementation DDQMyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1
    self.navigationItem.title = @"我的日记";
    
    //2
    [self layOutChangeButton];

    //3
    self.firstChildVC  = [[DDQFirstDiaryChildController alloc] init];
    self.secondChildVC = [[DDQSecondDiaryChildController alloc] init];
    
    self.firstChildVC.view.frame  = CGRectMake(0, 114 - 64, kScreenWidth, kScreenHeight - 114);
    self.secondChildVC.view.frame = CGRectMake(0, 114 - 64, kScreenWidth, kScreenHeight - 114);
    
    [self addChildViewController:self.firstChildVC];
    [self addChildViewController:self.secondChildVC];
    [self.view addSubview:self.firstChildVC.view];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;

}


-(void)layOutChangeButton {
    
    self.first_Button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.first_Button];
    self.first_Button.tag             = 1;
    self.first_Button.frame           = CGRectMake(0, 0, kScreenWidth * 0.5, 50);
    self.first_Button.backgroundColor = [UIColor whiteColor];
    self.first_Button.titleLabel.font = [UIFont systemFontOfSize:15.0f weight:2.0f];
    [self.first_Button setTitle:@"我发布的" forState:UIControlStateNormal];
    [self.first_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.first_Button addTarget:self action:@selector(changeViewContent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.temp_button = self.first_Button;
    
    self.second_Button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.second_Button];
    self.second_Button.tag             = 2;
    self.second_Button.frame           = CGRectMake(kScreenWidth * 0.5, 0, kScreenWidth * 0.5, 50);
    self.second_Button.backgroundColor = [UIColor grayColor];
    self.second_Button.titleLabel.font = [UIFont systemFontOfSize:15.0f weight:2.0f];
    [self.second_Button setTitle:@"我回复的" forState:UIControlStateNormal];
    [self.second_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.second_Button addTarget:self action:@selector(changeViewContent:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button target
-(void)changeViewContent:(UIButton *)btn {
    
    if(btn == self.temp_button) return;
    //判断点击的是哪个button
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.temp_button.backgroundColor = [UIColor grayColor];
    [self.temp_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.temp_button = btn;
    
    if (btn.tag == 2) {
        [self.view addSubview:self.secondChildVC.view];
        [self.view bringSubviewToFront:self.secondChildVC.view];
        
    } else {
        [self.view bringSubviewToFront:self.firstChildVC.view];
    }
}

//-(void)initWithDrawerPage {
//    
//    self.drawerView                 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 64, kScreenWidth * 0.8, kScreenHeight)];
//    self.drawerView.backgroundColor = [UIColor backgroundColor];
//    [self.view addSubview:self.drawerView];
//    
//    self.childTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.drawerView.frame.size.width, self.drawerView.frame.size.height) style:UITableViewStylePlain];
//    [self.childTableView setDelegate:self];
//    [self.childTableView setDataSource:self];
//    [self.drawerView addSubview:self.childTableView];
//    
//    self.childTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.childTableView.backgroundColor = [UIColor backgroundColor];
//    self.childTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
//    //self.childTableView.scrollEnabled   = NO;
//}

#pragma mark - delegate and datasource
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    if (tableView == self.mainTableView) {
//        //当没发布日记的时候返回一个
//        return 1;
//        
//    } else {
//        return self.headerModelArray.count;
//    }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (tableView == self.mainTableView) {
//        return self.view.frame.size.height * 0.15;
//        
//    } else {
//        return self.view.frame.size.height * 0.1;
//    }
//}
//
//static NSString *identifier = @"cell";
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.mainTableView) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            
//            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UIImage *image = [UIImage imageNamed:@"topic_upload_pic"];
//            [self addControlToContentView:cell.contentView imageUrl:nil text:@"发布新的日记"];
//            UIImageView *imageView = [cell.contentView viewWithTag:1];
//            imageView.image = image;
//        }
//        return cell;
//        
//    } else {
//        static NSString *identifier = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////        if (!cell) {
//            DDQGroupHeaderModel *model = self.headerModelArray[indexPath.row];
//            
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [self addControlToContentView:cell.contentView imageUrl:[NSURL URLWithString:model.iconUrl] text:model.name];
////        }
//        return cell;
//    }
//    
//}
////为cell添加控件
//-(void)addControlToContentView:(UIView *)contentView imageUrl:(NSURL *)imageUrl text:(NSString *)text{
//
//    UIImageView *add_imgaeView = [[UIImageView alloc] init];
//    [contentView addSubview:add_imgaeView];
//    [add_imgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(contentView.mas_centerY);
//        make.height.equalTo(contentView.mas_height).multipliedBy(0.7);
//        make.width.equalTo(add_imgaeView.mas_height);
//        make.left.equalTo(contentView.mas_left).offset(10);
//    }];
//    add_imgaeView.tag         = 1;
//    add_imgaeView.contentMode = UIImageResizingModeStretch;//图片自动拉伸
//    [add_imgaeView sd_setImageWithURL:imageUrl];
//    
//    
//    CGRect newRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:3.0f]} context:nil];
//    
//    UILabel *add_diary = [[UILabel alloc] init];
//    [contentView addSubview:add_diary];
//    [add_diary mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(add_imgaeView.mas_right).offset(10);
//        make.centerY.equalTo(contentView.mas_centerY);
//        make.width.offset(newRect.size.width);
//        make.height.equalTo(add_imgaeView.mas_height).multipliedBy(0.5);
//    }];
//    add_diary.tag  = 2;
//    add_diary.text = text;
//    add_diary.font = [UIFont systemFontOfSize:16.0f weight:3.0f];
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.mainTableView) {
//        
//        [UIView animateWithDuration:1.0f animations:^{
//            self.drawerView.frame = CGRectMake(kScreenWidth * 0.2, 64, kScreenWidth * 0.8, kScreenHeight - 64);
//        }];
//        
//    } else {
//        
//        [UIView animateWithDuration:1.0f animations:^{
//            
//            DDQGroupHeaderModel *model = self.headerModelArray[indexPath.row];
//            DDQPostingViewController *postingVC = [DDQPostingViewController new];
//            [self.navigationController pushViewController:postingVC animated:YES];
////            self.drawerView.frame = CGRectMake(kScreenWidth, 64, kScr eenWidth * 0.8, kScreenHeight - 64);
//        }];
//    }
//    
//}
//
//#pragma mark - other methods
//-(void)alertController:(NSString *)message {
//    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [userNameAlert addAction:actionOne];
//    [userNameAlert addAction:actionTwo];
//    [self presentViewController:userNameAlert animated:YES completion:nil];
//}
@end
