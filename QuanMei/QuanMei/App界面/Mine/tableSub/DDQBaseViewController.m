//
//  DDQBaseViewController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQBaseViewController.h"

@interface DDQBaseViewController ()

@property ( strong, nonatomic, readwrite) NSString *userid;

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
    
    self.net_work = [ProjectNetWork sharedWork];
    
    self.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    self.manager = [OrderManager defaultManager];
    
}

@end

@implementation OrderManager


+ (instancetype)defaultManager {

    static OrderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[OrderManager alloc] init];
        
    });
    
    return manager;
    
}


@end

NSString *const kFreshControllerNotification = @"fresh_controller";
NSString *const kFreshCancelCNotification = @"cancel_fresh";
NSString *const kFreshOrderCNotification = @"order_fresh";
