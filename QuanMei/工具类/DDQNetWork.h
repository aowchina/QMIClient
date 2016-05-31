//
//  DDQNetWork.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/8.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^netWorkError)(NSDictionary *errorDic);


@interface DDQNetWork : NSObject

@property (copy,nonatomic) netWorkError error;

+(void)checkNetWorkWithError:(netWorkError)error;


@end
