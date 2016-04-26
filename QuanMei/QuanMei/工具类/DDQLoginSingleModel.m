//
//  DDQLoginSingleModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQLoginSingleModel.h"

@implementation DDQLoginSingleModel
+(instancetype)singleModelByValue {
    static DDQLoginSingleModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[DDQLoginSingleModel alloc] init];
    });
    return model;
}
@end
