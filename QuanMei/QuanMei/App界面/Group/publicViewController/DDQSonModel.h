//
//  DDQSonModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQSonModel : NSObject
/**
 *  回复的评论者
 */
@property (copy,nonatomic) NSString *iD;
/**
 *  回复的时间
 */
@property (copy,nonatomic) NSString *pubtime;

/**
 *  回复内容
 */
@property (copy,nonatomic) NSString *text;
/**
 *  评论者的id
 */
@property (copy,nonatomic) NSString *userid;
/**
 *  被评论者的id
 */
@property (copy,nonatomic) NSString *userid2;
/**
 *  评论者用户名
 */
@property (copy,nonatomic) NSString *username;
/**
 *  被评论者用户名
 */
@property (strong,nonatomic) NSString *username2;
/**
 *  文章id
 */
@property (copy,nonatomic) NSString *wid;

@property (assign,nonatomic) BOOL isShow;
@end
