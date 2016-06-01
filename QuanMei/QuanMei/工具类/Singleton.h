//
//  Singleton.h
//  QuanMei
//
//  Created by minfo010 on 15/10/15.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
//cell name 标示的id
@property (copy,nonatomic) NSString *CellID;
//用于显示在cell 上的name
@property (copy,nonatomic) NSString *CellName;
//特惠类别数组
@property (strong,nonatomic) NSMutableArray *TH_TypesArray;
//特惠类比的名字用于显示
@property (strong,nonatomic) NSMutableArray *TH_TypesNameArray;
//保存省id
@property (copy,nonatomic) NSString *shengID;
+(instancetype)sharedDataTool;

@end
