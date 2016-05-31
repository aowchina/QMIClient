//
//  DDQHeaderSingleModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/14.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHeaderSingleModel.h"

@implementation DDQHeaderSingleModel
+(instancetype)singleModelByValue {
    static DDQHeaderSingleModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[DDQHeaderSingleModel alloc] init];
    });
    return model;
}
@end
