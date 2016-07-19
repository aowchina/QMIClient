//
//  DDQGroupArticleModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/15.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQGroupArticleModel : NSObject

/**
 *  判断这文章是精品还是热门
 */
@property (copy,nonatomic) NSString *isJing;
/**
 *  文章标题
 */
@property (copy,nonatomic) NSString *articleTitle;
/**
 *  小组名称
 */
@property (copy,nonatomic) NSString *groupName;
/**
 *  文章类型
 */
@property (copy,nonatomic) NSString *articleType;
/**
 *  图片的数组
 */
@property (copy,nonatomic) NSArray *imgArray;
/**
 *  评论详情
 */
@property (copy,nonatomic) NSString *introString;
/**
 *  用户头像
 */
@property (copy,nonatomic) NSString *userHeaderImg;
/**
 *  用户名称
 */
@property (copy,nonatomic) NSString *userName;
/**
 *  点赞人数
 */
@property (copy,nonatomic) NSString *thumbNum;
/**
 *  评论人数
 */
@property (copy,nonatomic) NSString *replyNum;
/**
 *  文章id
 */
@property (copy,nonatomic) NSString *articleId;
/**
 *  评论时间
 */
@property (copy,nonatomic) NSString *plTime;

@property (copy,nonatomic) NSString *ctime;

//账户
@property (nonatomic ,strong)NSString *userid;

//小组人数
@property (nonatomic ,strong)NSString *amount;

//标签
@property (nonatomic ,strong)NSMutableArray *tagArray;

//是否进组
@property (nonatomic ,strong)NSString *isin;

//话题
@property (nonatomic ,strong)NSString *ht;

@property (nonatomic ,strong)NSString *intro;


@property (nonatomic ,assign)BOOL isTemp;
@property (assign,nonatomic) BOOL isChange;


@end
