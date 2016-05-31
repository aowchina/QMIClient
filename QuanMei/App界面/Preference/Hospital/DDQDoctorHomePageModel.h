//
//  DDQDoctorHomePageModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/29.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQDoctorHomePageModel : NSObject
/**
 *  主攻方向
 */
@property (copy,nonatomic) NSString *direction;
/**
 *  医生id
 */
@property (copy,nonatomic) NSString *Id;
/**
 *  医生头像
 */
@property (copy,nonatomic) NSString *img;
/**
 *  简介
 */
@property (copy,nonatomic) NSString *intro;
/**
 *  姓名
 */
@property (copy,nonatomic) NSString *name;
/**
 *  职称
 */
@property (copy,nonatomic) NSString *pos;
@end
