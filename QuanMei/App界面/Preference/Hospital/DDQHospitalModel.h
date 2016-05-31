//
//  DDQHospitalModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/30.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQHospitalModel : NSObject
/**
 *  案例图url数组
 */
@property (strong,nonatomic) NSArray *alimg;
/**
 *  医院id
 */
@property (copy,nonatomic) NSString *ID;
/**
 *  医院介绍
 */
@property (copy,nonatomic) NSString *intro;
/**
 *  医院图片
 */
@property (copy,nonatomic) NSString *logo;
/**
 *  医院名
 */
@property (copy,nonatomic) NSString *name;
/**
 *  宣传图
 */
@property (strong,nonatomic) NSArray *xcimg;
@end
