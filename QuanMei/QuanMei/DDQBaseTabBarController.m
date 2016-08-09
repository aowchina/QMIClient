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
#import "DDQLoginViewController.h"

@interface DDQBaseTabBarController ()<UITabBarControllerDelegate>

@property (strong,nonatomic) UINavigationController *mainNavigation;
@property (strong,nonatomic) UINavigationController *groupNavigation;
@property (strong,nonatomic) UINavigationController *preferenceNavigation;
@property (strong,nonatomic) UINavigationController *mineNavigation;

@property (strong, nonatomic) UIButton *mineButton;
@property (strong, nonatomic) UILabel *mineLabel;

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
	
	self.delegate = self;

	if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] == 0) {
		
		
		_mineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.75, 0, kScreenWidth * 0.2, 49)];
		_mineView.backgroundColor = [UIColor backgroundColor];
		[self.tabBar addSubview:_mineView];
		self.mineButton = [UIButton buttonWithType:0];
		[_mineView addSubview:self.mineButton];
		
		self.mineButton.frame = CGRectMake(self.mineView.frame.size.width*0.5 - 10, self.mineView.frame.size.height*0.5 - 15, 20, 20);
		[self.mineButton setBackgroundImage:[UIImage imageNamed:@"wode-0"] forState:UIControlStateNormal];
		
		[self.mineButton addTarget:self action:@selector(judge) forControlEvents:UIControlEventTouchUpInside];
		
		self.mineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mineButton.frame.origin.y + self.mineButton.frame.size.height + 8, self.mineView.frame.size.width, 10)];
		[self.mineView addSubview:self.mineLabel];
		self.mineLabel.text = @"我的";
		self.mineLabel.textAlignment= NSTextAlignmentCenter;
		self.mineLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
		self.mineLabel.font = [UIFont systemFontOfSize:11];
	}
	
//	[self addObserver:self forKeyPath:@"selectedViewController" options:NSKeyValueObservingOptionNew | NSKeyVa
////	lueObservingOptionOld context:nil];
//	
}
//
//- (UIView *)mineView {
//
//	if (!_mineView) {
//		
//		_mineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.75, 0, kScreenWidth * 0.2, 49)];
//		_mineView.backgroundColor = [UIColor backgroundColor];
//		[self.tabBar addSubview:_mineView];
//		self.mineButton = [UIButton buttonWithType:0];
//		[_mineView addSubview:self.mineButton];
//		
//		self.mineButton.frame = CGRectMake(self.mineView.frame.size.width*0.5 - 10, self.mineView.frame.size.height*0.5 - 15, 20, 20);
//		[self.mineButton setBackgroundImage:[UIImage imageNamed:@"wode-0"] forState:UIControlStateNormal];
//		
//		[self.mineButton addTarget:self action:@selector(judge) forControlEvents:UIControlEventTouchUpInside];
//		
//		self.mineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mineButton.frame.origin.y + self.mineButton.frame.size.height + 8, self.mineView.frame.size.width, 10)];
//		[self.mineView addSubview:self.mineLabel];
//		self.mineLabel.text = @"我的";
//		self.mineLabel.textAlignment= NSTextAlignmentCenter;
//		self.mineLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
//		self.mineLabel.font = [UIFont systemFontOfSize:11];
//
//	}
//	
//	return _mineView;
//	
//}

- (UIView *)defaultMineView {

	self.mineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.75, 0, kScreenWidth * 0.2, 49)];
	self.mineView.backgroundColor = [UIColor backgroundColor];
	
	self.mineButton = [UIButton buttonWithType:0];
	[self.mineView addSubview:self.mineButton];
	
	self.mineButton.frame = CGRectMake(self.mineView.frame.size.width*0.5 - 10, self.mineView.frame.size.height*0.5 - 15, 20, 20);
	[self.mineButton setBackgroundImage:[UIImage imageNamed:@"wode-0"] forState:UIControlStateNormal];
	
	[self.mineButton addTarget:self action:@selector(judge) forControlEvents:UIControlEventTouchUpInside];
	
	self.mineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mineButton.frame.origin.y + self.mineButton.frame.size.height + 8, self.mineView.frame.size.width, 10)];
	[self.mineView addSubview:self.mineLabel];
	self.mineLabel.text = @"我的";
	self.mineLabel.textAlignment= NSTextAlignmentCenter;
	self.mineLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
	self.mineLabel.font = [UIFont systemFontOfSize:11];
	
	return self.mineView;
	
}

- (void)judge {

	if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] == 0) {
		//
					DDQLoginViewController *login = [[DDQLoginViewController alloc] init];
					login.hidesBottomBarWhenPushed = YES;
		
		UINavigationController *nav = self.selectedViewController;
		[nav pushViewController:login animated:YES];
		//			self.selectedViewController = oldC;
//					[newC pushViewController:login animated:YES];
		
	}
	
}



//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//
//	UINavigationController *newC = change[@"new"];
//	
//	if (newC == self.mineNavigation) {
//		
//		if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] == 0) {
//			
//			DDQLoginViewController *login = [[DDQLoginViewController alloc] init];
//			login.hidesBottomBarWhenPushed = YES;
//		
////			self.selectedViewController = oldC;
//			[newC pushViewController:login animated:YES];
//
//		}
//		
//	}
//	
//}

@end
