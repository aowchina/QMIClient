//
//  DDQBaseViewController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQBaseViewController.h"

@interface DDQBaseViewController ()

@end

@implementation DDQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 50)];
    self.navigationItem.titleView = self.title_label;
    self.title_label.textAlignment = NSTextAlignmentCenter;
    self.title_label.textColor = [UIColor meiHongSe];
    
    self.wait_hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.wait_hud];
    
    self.wait_hud.detailsLabelText = @"请稍候...";
    
    
}


@end
