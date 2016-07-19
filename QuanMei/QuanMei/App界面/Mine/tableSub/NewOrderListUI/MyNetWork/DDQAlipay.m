//
//  DDQAlipay.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQAlipay.h"
#import "Order.h"
#import "DataSigner.h"

#import <AlipaySDK/AlipaySDK.h>

@implementation DDQAlipay

+ (void)alipay_creatSignWithParam:(NSDictionary *)param_c PaySuccess:(void (^)())success PayFailure:(void (^)(NSDictionary *))failure {
    
    NSString *partner = kAlipayPartner;
    NSString *seller = kAlipaySeller;
    NSString *privateKey = kAlipayPrivateKey;

//    NSString *partner = @"2088121000537625";
//    NSString *seller = @"846846@qq.com";
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWuQ1WaXHjQcp3EOEfWhIezMJ0006VIsYNaaEyle4MoooWhk00vctcBYTdd6VQjIIeQdk2u5oDJCPAG a0fL0mesdF31dlw4l6zUoDS5eSA5wVYtNkFeYcKt972XClaeBivjdZA6ZghfstKEYz+d4WTn2gOvChB5Zm6iWlfVUqQTAgMBAAECgYB75sbTf8XX/6bnVdaEyGMW/uxI jJTfcxm4H9FhwRMSWUTMh0JhTY0oT/gUEOuvTbkU3yoXdLmLHPZaI1vYi1sbfcXb F/FotGmkfSKoQSk/lokQxfcW8i4LOJLOfyKoEQhqhAedG5Q96TMiaHAbOPdwq6oC 7tuN4sw1zqnRTmxoUQJBAP95kdPuq0TDt3egirBaUUf7UenCwySPtifKJduMlcDg S2dIIkss3Sm1D5++dzOrAtFb2lYC1zteP5+2AK7ocakCQQDGFkg/F6tujNy1yBuj I8bpl8DMvB+oJJeF8oRrTosQL8hdGlh4NgmEUs7uIDnj6rn+C79CBBJbgOD75qt+wHVbAkBN2LuI+tcRcxn6x9668iqGZpyFQKW6BFibM0vp5KLVTQNtC1v30EnsJZIH OUCVa+zF4tlbEC6JlqSIhCsdIRNRAkBsa7/JgMwda05W1RuDdM6oBp7JsOJm5vhk oXQnQ8tL5ct2YjgwO+uDmMuYfN0SyeRZj9Z0bMQbf3QljIErlG3nAkEAo0bBRYWJ NDT7qYbLI5zaMDthr9E+K9/x8fLBRlTd38ghUxlzfg2i1fwoGUgCLtMBcjG8RuGI Q7/yxavY7RuJMQ==";
//    NSString *partner = @"2088021102567879";
//    NSString *seller = @"yanxiaoyi@min-fo.com";
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWuQ1WaXHjQcp3EOEfWhIezMJ0006VIsYNaaEyle4MoooWhk00vctcBYTdd6VQjIIeQdk2u5oDJCPAG a0fL0mesdF31dlw4l6zUoDS5eSA5wVYtNkFeYcKt972XClaeBivjdZA6ZghfstKEYz+d4WTn2gOvChB5Zm6iWlfVUqQTAgMBAAECgYB75sbTf8XX/6bnVdaEyGMW/uxI jJTfcxm4H9FhwRMSWUTMh0JhTY0oT/gUEOuvTbkU3yoXdLmLHPZaI1vYi1sbfcXb F/FotGmkfSKoQSk/lokQxfcW8i4LOJLOfyKoEQhqhAedG5Q96TMiaHAbOPdwq6oC 7tuN4sw1zqnRTmxoUQJBAP95kdPuq0TDt3egirBaUUf7UenCwySPtifKJduMlcDg S2dIIkss3Sm1D5++dzOrAtFb2lYC1zteP5+2AK7ocakCQQDGFkg/F6tujNy1yBuj I8bpl8DMvB+oJJeF8oRrTosQL8hdGlh4NgmEUs7uIDnj6rn+C79CBBJbgOD75qt+wHVbAkBN2LuI+tcRcxn6x9668iqGZpyFQKW6BFibM0vp5KLVTQNtC1v30EnsJZIH OUCVa+zF4tlbEC6JlqSIhCsdIRNRAkBsa7/JgMwda05W1RuDdM6oBp7JsOJm5vhk oXQnQ8tL5ct2YjgwO+uDmMuYfN0SyeRZj9Z0bMQbf3QljIErlG3nAkEAo0bBRYWJ NDT7qYbLI5zaMDthr9E+K9/x8fLBRlTd38ghUxlzfg2i1fwoGUgCLtMBcjG8RuGI Q7/yxavY7RuJMQ==";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = param_c[@"orderid"]; //订单ID（由商家自行制定）
    order.productName = param_c[@"name"]; //商品标题
    order.productDescription = @"无"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[param_c[@"price"] floatValue]]; //商品价格
    //    order.amount = @"0.01"; //商品价格
    
    order.notifyURL =  kOrder_zfbUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"QuanMei";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil) {
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {

                success();
                
            } else {
                

                failure(resultDic);
            }
            
        }];
    }

}

@end
