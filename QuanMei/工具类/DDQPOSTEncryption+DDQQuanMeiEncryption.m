//
//  DDQPOSTEncryption+DDQQuanMeiEncryption.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/1.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQPOSTEncryption+DDQQuanMeiEncryption.h"

@implementation DDQPOSTEncryption (DDQQuanMeiEncryption)

+(id)judgePOSTDic:(NSDictionary *)dic {

    //分析服务器返给的字典
    if (dic!=nil) {
        
        //这里表示没加密
        if ([dic[@"active"] intValue] == 2) {
            
            //data不为空
            if (dic[@"data"] != nil && ![dic[@"data"] isKindOfClass:[NSNull class]]) {
                NSString *string = dic[@"data"];
                NSDictionary *dic = [[[SBJsonParser alloc] init] objectWithString:string];
                return dic;
                
            } else {
                return nil;
            }
            
        } else {//加密了
            
            //data不为空
            if (dic[@"data"] != nil && ![dic[@"data"] isKindOfClass:[NSNull class]]) {
                
                //解密
                DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
                NSString *string = [post stringWithDic:dic];
                
                //转换
                NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                return dic;
                
            } else {
                return nil;
            }
        }
        
    } else {
        return nil;
    }
}

@end
