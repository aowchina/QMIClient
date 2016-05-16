//
//  DDQWXPay.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQWXPay.h"
#import "payRequsestHandler.h"
@implementation DDQWXPay

+ (BOOL)weixinPay_param:(NSDictionary *)param {

    PayReq *pay_req = [[PayReq alloc] init];
    pay_req.openID = kWeChatKey;
    //微信支付分配的商户号
    pay_req.partnerId = kWeChatPartner;
    //微信返回的支付交易回话id
    pay_req.prepayId= param[@"pid"];

    //填写固定值sign = WXPay
    pay_req.package = @"Sign=WXPay";
    //
    pay_req.nonceStr= param[@"nonce_str"];
    //时间戳
    pay_req.timeStamp = [param[@"timestamp"] floatValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWeChatKey forKey:@"appid"];
    [params setObject:pay_req.partnerId forKey:@"partnerid"];
    [params setObject:pay_req.prepayId forKey:@"prepayid"];
    [params setObject:[NSString stringWithFormat:@"%.0u",(unsigned int)pay_req.timeStamp] forKey:@"timestamp"];
    
    [params setObject:pay_req.nonceStr forKey:@"noncestr"];
    [params setObject:pay_req.package forKey:@"package"];
    //签名
    payRequsestHandler *pay = [[payRequsestHandler alloc]init];
    
    NSString *sign  = [pay createMd5Sign:params];
    
    pay_req.sign= sign;
    
    BOOL OK = [WXApi sendReq:pay_req];
    return OK;
    
}


@end
