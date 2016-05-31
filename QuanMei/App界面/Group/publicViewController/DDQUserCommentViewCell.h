//
//  DDQUserCommentViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/20.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQCommentModel.h"

@interface DDQUserCommentViewCell : UITableViewCell

/**
 *  数据源model
 */
@property (strong,nonatomic) DDQCommentModel *commentModel;
/**
 *  当前view
 */
@property (strong,nonatomic) UIView *currentView;
/**
 *  评论用户头像
 */
@property (strong,nonatomic) UIImageView *replyUserImage;
/**
 *  评论用户昵称
 */
@property (strong,nonatomic) UILabel *replyNameLabel;
/**
 *  评论日期
 */
@property (strong,nonatomic) UILabel *replyDateLabel;
/**
 *  评论内容
 */
@property (strong,nonatomic) UILabel *replyIntroLabel;
/**
 *  回复的载体view
 */
@property (strong,nonatomic) UIView *replyView;
/**
 *  放在view上的一张小图片
 */
@property (strong,nonatomic) UIImageView *replyImage;
/**
 *  回复label
 */
@property (strong,nonatomic) UILabel *replyLabel;
/**
 *  盖楼的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
@end
