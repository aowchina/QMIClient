//
//  DDQBaseTabBarController.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/11.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQBaseTabBarController : UITabBarController

//+ (instancetype)sharedController;
@property (strong, nonatomic) UIView *mineView;

- (UIView *)defaultMineView;

@end
