//
//  DDQUserInfoModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/11.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserInfoModel.h"

@implementation DDQUserInfoModel
+(instancetype)singleModelByValue {
    static DDQUserInfoModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[DDQUserInfoModel alloc] init];
    });
    return model;
}
@end
