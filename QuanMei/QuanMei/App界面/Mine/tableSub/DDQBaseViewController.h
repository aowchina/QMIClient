//
//  DDQBaseViewController.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQBaseViewController : UIViewController
/**
 *  控制器的名字
 */
@property ( strong, nonatomic) UILabel *title_label;

/**
 *  用以等待的hud
 */
@property ( strong, nonatomic) MBProgressHUD *wait_hud;



@end
