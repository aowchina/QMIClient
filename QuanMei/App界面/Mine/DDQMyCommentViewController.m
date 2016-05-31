//
//  DDQMyCommentViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyCommentViewController.h"
#import "DDQFirstChildViewController.h"
#import "DDQSecondChildViewController.h"

@interface DDQMyCommentViewController ()
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
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

@property (strong,nonatomic) DDQFirstChildViewController *firstChildVC;
@property (strong,nonatomic) DDQSecondChildViewController *secondChildVC;

@end

@implementation DDQMyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1
    self.navigationItem.title = @"我的回帖";
    //2
    [self layOutChangeButton];  

    //3
    self.firstChildVC  = [[DDQFirstChildViewController alloc] init];
    self.secondChildVC = [[DDQSecondChildViewController alloc] init];
    
    self.firstChildVC.view.frame  = CGRectMake(0, 114 - 64, kScreenWidth, kScreenHeight - 114);
    self.secondChildVC.view.frame = CGRectMake(0, 114 - 64, kScreenWidth, kScreenHeight - 114);
    
    [self addChildViewController:self.firstChildVC];
    [self addChildViewController:self.secondChildVC];
    [self.view addSubview:self.firstChildVC.view];
    [self.view addSubview:self.secondChildVC.view];

    [self.view insertSubview:self.firstChildVC.view aboveSubview:self.secondChildVC.view];
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
    self.second_Button.backgroundColor = kLeftColor;
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
    
    self.temp_button.backgroundColor = kLeftColor;
    [self.temp_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.temp_button = btn;
    
    if (btn.tag == 2) {
        [self.view bringSubviewToFront:self.secondChildVC.view];
        
    } else {
        [self.view bringSubviewToFront:self.firstChildVC.view];
    }
}


@end
