//
//  DDQNewPayController.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/9.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQBaseViewController.h"

#import "DDQPayView.h"

typedef enum : NSUInteger {
    
    kServerController = 1,
    kPayController
    
} ControllerType;

@interface DDQNewPayController : DDQBaseViewController

@property ( strong, nonatomic) NSString *orderid;
@property ( assign, nonatomic) PayType pay_type;
@property ( assign, nonatomic) WhatPay what_pay;

@property ( assign, nonatomic) ControllerType c_type;

@end
