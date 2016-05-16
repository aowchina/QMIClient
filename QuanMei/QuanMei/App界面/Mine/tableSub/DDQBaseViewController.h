//
//  DDQBaseViewController.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectNetWork.h"
#import "MJExtension.h"
#import "DDQLoginViewController.h"
@interface DDQBaseViewController : UIViewController
/**
 *  控制器的名字
 */
@property ( strong, nonatomic) UILabel *title_label;

/**
 *  用以等待的hud
 */
@property ( strong, nonatomic) MBProgressHUD *wait_hud;

/**
 *  网络请求
 */
@property ( strong, nonatomic) ProjectNetWork *net_work;

/**
 *  userid
 */
@property ( strong, nonatomic, readonly) NSString *userid;

@end
