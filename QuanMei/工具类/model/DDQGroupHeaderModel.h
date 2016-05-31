//
//  DDQGroupHeaderModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQGroupHeaderModel : NSObject
/**
 *  部位的图片
 */
@property (copy,nonatomic) NSString *iconUrl;
/**
 *  部位对应的id
 */
@property (copy,nonatomic) NSString *groupId;
/**
 *  部位名
 */
@property (copy,nonatomic) NSString *name;
/**
 *  项目简介
 */
@property (copy,nonatomic) NSString *introString;
/**
 *  项目id
 */
@property (copy,nonatomic) NSString *tagId;
@end
