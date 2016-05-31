//
//  Singleton.m
//  QuanMei
//
//  Created by minfo010 on 15/10/15.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
+(instancetype)sharedDataTool
{
    static Singleton *sl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sl = [[Singleton alloc] init];
    });
    return sl;
    
}
-(id) init
{
    if (self = [super init]) {
        self.CellID = [[NSString alloc]init];
        self.CellName = [[NSString alloc]init];
        self.TH_TypesArray = [[NSMutableArray alloc]init];
        self.TH_TypesNameArray = [[NSMutableArray alloc]init];
        self.shengID = [[NSString alloc]init];
    }
    return self;
    
}

@end
