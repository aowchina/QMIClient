//
//  DDQUserDiaryViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQDiaryModel.h"

@interface DDQUserDiaryViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *floorNum;
/**
 *  更新的时间
 */
@property (strong,nonatomic) UILabel *freshDate;
/**
 *  评论view
 */
@property (strong,nonatomic) UIView *tempView;
/**
 *  评论详情
 */
@property (strong,nonatomic) UILabel *commpentLabel;
/**
 *  用户上传的头像
 */
@property (strong,nonatomic) UIImageView *userImage;
/**
 *  点赞
 */
@property (strong,nonatomic) UIImageView *thumbImageView;
/**
 *  点赞人数
 */
@property (strong,nonatomic) UILabel *thumbUpNum;
/**
 *  回帖
 */
@property (strong,nonatomic) UIImageView *replyImageView;
/**
 *  回帖人数
 */
@property (strong,nonatomic) UILabel *replyNum;
/**
 *  盖楼的用户1
 */
@property (strong,nonatomic) UILabel *firstCommentUserLabel;
/**
 *  盖楼的用户2
 */
@property (strong,nonatomic) UILabel *secondCommentUserLabel;

@property (strong,nonatomic) DDQDiaryModel *diaryModel;

@end
