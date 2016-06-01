//
//  DDQPayView.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/9.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DingJin = 1,
    QuanKuan = 2,
    WeiKuan
} PayType;

typedef enum : NSUInteger {
    ZhifuBao = 1,
    Weixin = 2,
} PayWay;

/**
 区分是否已经支付完成，判断是否显示倒计时
 */
typedef enum : NSUInteger {
    notPay = 1,
    isPay
} WhatPay;

@protocol PayViewDelegate <NSObject>

@optional
- (void)pay_viewChangeType;
- (void)pay_viewChangeWay;
- (void)pay_viewSurePay:(NSString *)total Jifen:(NSString *)jifen Type:(PayType)type Way:(PayWay)way Error:(NSError *)error;

@end

@interface DDQPayView : UIView

@property ( strong, nonatomic) NSDictionary *param_dic;
@property ( weak, nonatomic) id <PayViewDelegate> delegate;
@property ( assign, nonatomic) PayType pay_type;
@property ( assign, nonatomic) PayWay pay_way;
@property ( assign, nonatomic) WhatPay what_pay;

@end

//UIKIT_EXTERN NSString *const OrderInvalidNotification;//订单失效的通知