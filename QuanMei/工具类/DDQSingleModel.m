//
//  DDQSingleModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSingleModel.h"

@implementation DDQSingleModel

+(instancetype)singleModelByValue {
    static DDQSingleModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[DDQSingleModel alloc] init];
    });
    return model;
}
-(NSMutableArray *)TH_TypesArray
{
    if (!_TH_TypesArray) {
        _TH_TypesArray = [NSMutableArray array];
    }
    return _TH_TypesArray;
}
-(NSMutableArray *)TH_TypesNameArray
{
    if (!_TH_TypesNameArray) {
        _TH_TypesNameArray = [NSMutableArray array];
    }
    return _TH_TypesNameArray;
    
}

@end
