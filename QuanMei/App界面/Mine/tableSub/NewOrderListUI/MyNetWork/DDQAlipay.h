//
//  DDQAlipay.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQAlipay : NSObject

+ (void)alipay_creatSignWithParam:(NSDictionary *)param_c PaySuccess:(void(^)())success PayFailure:(void(^)(NSDictionary *reslut_dic))failure;

@end
