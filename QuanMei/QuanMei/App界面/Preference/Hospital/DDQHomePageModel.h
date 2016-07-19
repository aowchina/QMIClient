//
//  DDQHomePageModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQHomePageModel : NSObject
/**
 *  医生
 */
@property (strong,nonatomic) NSArray *doctor;
/**
 *  服务
 */
@property (copy,nonatomic) NSString *fw;
/**
 *  环境
 */
@property (copy,nonatomic) NSString *hj;
/**
 *  审美
 */
@property (copy,nonatomic) NSString *sm;
/**
 *  好评
 */
@property (copy,nonatomic) NSString *hp;
/**
 *  医院id
 */
@property (copy,nonatomic) NSString *Id;
/**
 *  医院logo
 */
@property (copy,nonatomic) NSString *logo;
@property (strong,nonatomic) NSString *plamount;
/**
 *  星级
 */
@property (copy,nonatomic) NSString *stars;

@property (copy,nonatomic) NSString *name;

@property (strong,nonatomic) NSArray *pl;
@end

