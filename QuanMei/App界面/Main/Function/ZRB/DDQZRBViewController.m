//
//  DDQZRBViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQZRBViewController.h"

@interface DDQZRBViewController ()

@property (strong,nonatomic) UIScrollView *mainScrollView;

@end

@implementation DDQZRBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UILabel *label = [[UILabel alloc] init];
    self.navigationItem.titleView = label;
    label.text = @"整容宝";
    label.textColor = [UIColor meiHongSe];
    
    [self addControl];
    
}

#pragma mark - controls
-(void)addControl {
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    UIImage *image = [UIImage imageNamed:@"美容宝"];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, image.size.height);
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.width)];
    [self.mainScrollView addSubview:firstImageView];
    firstImageView.image = image;
//
//    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight*0.7, kScreenWidth, kScreenHeight*0.4)];
//    [self.mainScrollView addSubview:secondImageView];
//    secondImageView.image = [UIImage imageNamed:@"cosmetic_guide2"];
//    
//    UIImageView *thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight*1.1, kScreenWidth, kScreenHeight*0.4)];
//    [self.mainScrollView addSubview:thirdImageView];
//    thirdImageView.image = [UIImage imageNamed:@"cosmetic_guide3"];
//    
//    UIImageView *fourthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight*1.5, kScreenWidth, kScreenHeight*0.7)];
//    [self.mainScrollView addSubview:fourthImageView];
//    fourthImageView.image = [UIImage imageNamed:@"cosmetic_guide4"];
//    
//    UIImageView *fifthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight*2.2, kScreenWidth, kScreenHeight*0.7)];
//    [self.mainScrollView addSubview:fifthImageView];
//    fifthImageView.image = [UIImage imageNamed:@"cosmetic_guide5"];
}



@end
