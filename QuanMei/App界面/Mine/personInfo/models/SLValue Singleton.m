//
//  SLValue Singleton.m
//  pickView
//
//  Created by superlian on 15/12/1.
//  Copyright © 2015年 superlian. All rights reserved.
//

#import "SLValue Singleton.h"

@implementation SLValue_Singleton

+(instancetype)shareInstance {
    static SLValue_Singleton *valueSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        valueSingleton = [[SLValue_Singleton alloc] init];
        
    });
    return valueSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pickTimeStr = [[NSString alloc] init];
        self.pickCityStr = [[NSString alloc] init];
        self.province = [[NSString alloc] init];
        self.provinceID = [[NSString alloc] init];
        self.city = [[NSString alloc] init];
        self.cityID = [[NSString alloc] init];
    }
    return self;
}

@end
