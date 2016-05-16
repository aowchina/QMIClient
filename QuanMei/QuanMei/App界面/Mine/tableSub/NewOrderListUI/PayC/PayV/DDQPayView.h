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
} PayType;

typedef enum : NSUInteger {
    ZhifuBao = 1,
    Weixin = 2,
} PayWay;

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


@end
