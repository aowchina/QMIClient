//
//  DDQReplyModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQReplyModel : NSObject
/**
 *  第一个回复的评论者
 */
@property (copy,nonatomic) NSString *iD;
/**
 *  回复的时间
 */
@property (copy,nonatomic) NSString *pubtime;
/**
 *  盖楼的人员
 */
@property (strong,nonatomic) NSArray *son;
/**
 *  是否被点过赞
 */
@property (copy,nonatomic) NSString *status;
/**
 *  回复内容
 */
@property (copy,nonatomic) NSString *text;
/**
 *  最初评论者的id
 */
@property (copy,nonatomic) NSString *userid;
/**
 *  被评论者的id
 */
@property (copy,nonatomic) NSString *userid2;
/**
 *  用户头像
 */
@property (copy,nonatomic) NSString *userimg;
/**
 *  用户名
 */
@property (copy,nonatomic) NSString *username;
/**
 *  文章id
 */
@property (copy,nonatomic) NSString *wid;

@property (copy,nonatomic) NSString *more_hf;
@property (assign,nonatomic) BOOL isReuse;

@end
