//
//  DDQProjectViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "DDQProjectViewController.h"

#import "DDQProjectDetailViewController.h"
#import "DDQDiaryViewController.h"

@interface DDQProjectViewController ()
/**
 *  详情按钮
 */
@property (strong,nonatomic) UIButton *descriptionButton;
/**
 *  日记按钮
 */
@property (strong,nonatomic) UIButton *diaryButton;

@property (strong,nonatomic) DDQDiaryViewController *diaryVC;
@property (strong,nonatomic) DDQProjectDetailViewController *projectDetailVC;
@property (strong,nonatomic)UIScrollView *scroll;

@end

@implementation DDQProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationItem.title = @"项目详情";
    self.view.backgroundColor = [UIColor backgroundColor];
    [self childViewController];
    [self addTwoButton];
}
-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;

}

#pragma mark - add childViewController and button
-(void)childViewController {
    
    self.projectDetailVC = [[DDQProjectDetailViewController alloc] init];
    [self addChildViewController:_projectDetailVC];
    [_projectDetailVC.view setFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_projectDetailVC.view];
    
    self.diaryVC = [[DDQDiaryViewController alloc] init];
    [self addChildViewController:_diaryVC];
    [_diaryVC.view setFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight)];

    
}

-(void)addTwoButton {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [self.view addSubview:view];
    
    self.descriptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.5, view.frame.size.height)];
    [self.descriptionButton setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionButton setTitle:@"项目简介" forState:UIControlStateNormal];
    [self.descriptionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.descriptionButton addTarget:self action:@selector(changeToProjectDetailViewController) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.descriptionButton];
    
    self.diaryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5, 0, self.view.bounds.size.width*0.5, view.frame.size.height)];
    [self.diaryButton setBackgroundColor:[UIColor grayColor]];
    [self.diaryButton setTitle:@"相关日记" forState:UIControlStateNormal];
    [self.diaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.diaryButton addTarget:self action:@selector(changeToUserDiaryViewController) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.diaryButton];
    
    [view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - button target action 
-(void)changeToUserDiaryViewController {
    [self.view addSubview:_diaryVC.view];

    [self.diaryButton setBackgroundColor:[UIColor whiteColor]];
    [self.diaryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//
//    [self transitionFromViewController:_projectDetailVC toViewController:_diaryVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//        if (!finished) {
//            [_diaryVC didMoveToParentViewController:self];
//            [_projectDetailVC willMoveToParentViewController:nil];
//            [_projectDetailVC removeFromParentViewController];
//        }
//    }];
    [self.descriptionButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.descriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:_diaryVC.view];

}

-(void)changeToProjectDetailViewController {
    
    [self.descriptionButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.descriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    [self transitionFromViewController:_diaryVC toViewController:_projectDetailVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//        if (!finished) {
//            [_projectDetailVC didMoveToParentViewController:self];
//            [_diaryVC willMoveToParentViewController:nil];
//            [_diaryVC removeFromParentViewController];
//        }
//    }];
    [self.diaryButton setBackgroundColor:[UIColor whiteColor]];
    [self.diaryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:_projectDetailVC.view];

}

@end
