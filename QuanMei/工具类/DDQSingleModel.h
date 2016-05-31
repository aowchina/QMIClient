//
//  DDQSingleModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQSingleModel : NSObject
@property (copy,nonatomic) NSString *iconString;
@property (copy,nonatomic) NSString *positionString;
@property (strong,nonatomic) NSString *projectId;

//特惠类别数组
@property (copy,nonatomic) NSMutableArray *TH_TypesArray;
//特惠类比的名字用于显示
@property (copy,nonatomic) NSMutableArray *TH_TypesNameArray;

+(instancetype)singleModelByValue;
@end
