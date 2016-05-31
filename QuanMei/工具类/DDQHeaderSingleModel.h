//
//  DDQHeaderSingleModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/14.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  这是运用在小组header的单例，用于传值
 */
@interface DDQHeaderSingleModel : NSObject
/**
 *  项目简介
 */
@property (strong,nonatomic) NSString *introString;
/**
 *  部位对应的id
 */
@property (copy,nonatomic) NSString *groupId;
/**
 *  部位的图片
 */
@property (copy,nonatomic) NSString *iconUrl;
/**
 *  部位名
 */
@property (copy,nonatomic) NSString *name;
/**
 *  小组id
 */
@property (copy,nonatomic) NSString *tagId;

@property (copy,nonatomic) NSString *ctime;

@property (copy,nonatomic) NSString *articleId;

@property (copy,nonatomic) NSString *userId;

+(instancetype)singleModelByValue;

@end
