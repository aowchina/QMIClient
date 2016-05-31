//
//  DDQWXPay.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

@interface DDQWXPay : NSObject<WXApiDelegate>

+ (BOOL)weixinPay_param:(NSDictionary *)param;

@end
