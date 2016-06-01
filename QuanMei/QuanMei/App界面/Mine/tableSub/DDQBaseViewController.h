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

@class OrderManager;

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

@property ( strong, nonatomic) OrderManager *manager;

@end

@interface OrderManager : NSObject

+ (instancetype)defaultManager;

/**
 *  是否刷新的
 */
@property ( assign, nonatomic) BOOL isFresh;

@end
/**
 *  一个控制器的数据改变后，通知下其他控制器
 */
UIKIT_EXTERN NSString *const kFreshControllerNotification;
/**
 *  取消后刷新
 */
UIKIT_EXTERN NSString *const kFreshCancelCNotification;
/**
 *  评价完后刷新
 */
UIKIT_EXTERN NSString *const kFreshOrderCNotification;
