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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.text = @"整容宝";
    label.textColor = [UIColor meiHongSe];
    
    self.navigationItem.titleView = label;

    [self addControl];
    
}

#pragma mark - controls
-(void)addControl {
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    UIImage *image = [UIImage imageNamed:@"cosmeticBG"];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, image.size.height);
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.height)];
    [self.mainScrollView addSubview:firstImageView];
    firstImageView.image = image;

}



@end
