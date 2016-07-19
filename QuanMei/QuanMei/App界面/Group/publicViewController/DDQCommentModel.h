//
//  DDQCommentModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/20.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQCommentModel : NSObject
/**
 *  评论内容
 */
@property (copy,nonatomic) NSString *text;
/**
 *  图片数组
 */
@property (strong,nonatomic) NSArray *imgs;
@property (strong,nonatomic) NSArray *pluser;
/** 是否被收藏 */
@property (nonatomic, strong) id isSc;
/**
 *  标题
 */
@property (copy,nonatomic) NSString *title;
/**
 *  用户id
 */
@property (copy,nonatomic) NSString *userid;
/**
 *  用户头像
 */
@property (copy,nonatomic) NSString *userimg;
/**
 *  用户昵称
 */
@property (copy,nonatomic) NSString *username;
/**
 *  评论时间
 */
@property (copy,nonatomic) NSString *pubtime;
/**
 *  用户有没有点赞
 */
@property (copy,nonatomic) NSString *iszan;
/**
 *  parentId
 */
@property (copy,nonatomic) NSString *parentid;
/**
 *  文章类型
 */
@property (copy,nonatomic) NSString *type;
/**
 *  文章id
 */
@property (copy,nonatomic) NSString *id;
@property (copy,nonatomic) NSString *zan;

@end
