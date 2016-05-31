//
//  DDQPublic.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/29.
//  Copyright © 2015年 min-fo. All rights reserved.
//

//10-29
#import <Foundation/Foundation.h>

@interface DDQPublic : NSObject

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;

//12-21
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic;

@end
