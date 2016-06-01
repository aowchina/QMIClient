//
//  DDQBaseTabBarController.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/11.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQBaseTabBarController.h"

#import "DDQMainViewController.h"
#import "DDQGroupViewController.h"
#import "DDQMineViewController.h"
#import "DDQPreferenceViewController.h"

@interface DDQBaseTabBarController ()

@property (strong,nonatomic) UINavigationController *mainNavigation;
@property (strong,nonatomic) UINavigationController *groupNavigation;
@property (strong,nonatomic) UINavigationController *preferenceNavigation;
@property (strong,nonatomic) UINavigationController *mineNavigation;

@end

@implementation DDQBaseTabBarController

+ (instancetype)sharedController {

    static DDQBaseTabBarController *barC = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        barC = [[DDQBaseTabBarController alloc] init];
        
    });
    
    return barC;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    DDQMainViewController *mainController = [[DDQMainViewController alloc] init];
    self.mainNavigation = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDQGroupViewController *groupController = [[DDQGroupViewController alloc] init];
    self.groupNavigation = [[UINavigationController alloc] initWithRootViewController:groupController];
    
    DDQPreferenceViewController *preferenceController = [[DDQPreferenceViewController alloc] init];
    self.preferenceNavigation = [[UINavigationController alloc] initWithRootViewController:preferenceController];
    
    DDQMineViewController *mineController = [[DDQMineViewController alloc] init];
    self.mineNavigation = [[UINavigationController alloc] initWithRootViewController:mineController];
    
    self.viewControllers = @[_mainNavigation,_groupNavigation,_preferenceNavigation,_mineNavigation];
    
    UITabBar *tabBar = self.tabBar;
    [tabBar setTintColor:[UIColor meiHongSe]];
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item0.selectedImage = [[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [[UIImage imageNamed:@"全美_首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.title = @"首页";
    
    item1.selectedImage = [[UIImage imageNamed:@"美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"首页－美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = @"美人圈";
    
    item2.selectedImage = [[UIImage imageNamed:@"特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item2.image = [[UIImage imageNamed:@"首页_特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"特惠";
    
    item3.selectedImage = [[UIImage imageNamed:@"6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item3.image = [[UIImage imageNamed:@"wode-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title = @"我的";
    
}
@end
