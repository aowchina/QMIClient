//
//  DDQMyCommentCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQGroupArticleModel.h"

@protocol MyCommentCellDelegate <NSObject>

@optional
-(void)myCommentCellDelegateWithTapMethodAndWenzhangId:(NSString *)iD;

@end


@interface DDQMyCommentCell : UITableViewCell
@property (copy,nonatomic) NSString *wenzhangId;

@property (weak,nonatomic) id <MyCommentCellDelegate> delegate;
/**
 *  背景View
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  是日记或者评论
 */
@property (strong,nonatomic) UILabel *typeLabel;
/**
 *  日记或评论的标题
 */
@property (strong,nonatomic) UILabel *titleLabel;
/**
 *  显示热门或精选
 */
@property (strong,nonatomic) UIImageView *reOrJing;
/**
 *  用来提示评论是否有图片
 */
@property (strong,nonatomic) UIImageView *placeholderImage;

/**
 *  给cell赋值的model了类
 */
@property (strong,nonatomic) DDQGroupArticleModel *articleModel;
/**
 *  文章来源
 */
@property (strong,nonatomic) UILabel *articleSource;
/**
 *  小组名
 */
@property (strong,nonatomic) UILabel *sourceName;

//判断是图片还是文字
/**
 *  评论内容
 */
@property (strong,nonatomic) UILabel *commentInto;
/**
 *  用户图片
 */
@property (strong,nonatomic) UIImageView *user_img;
/**
 *  记录文字自适应完以后的rect,方便tableView的高度
 */
@property (assign,nonatomic) CGRect newRect;
@property (assign,nonatomic) CGFloat cell_height;
/**
 *  用户头像
 */
@property (strong,nonatomic) UIImageView *user_headerImg;
/**
 *  用户名称
 */
@property (strong,nonatomic) UILabel *user_name;
/**
 *  评论时间
 */
@property (strong,nonatomic) UILabel *plTime;
/**
 *  点赞
 */
@property (strong,nonatomic) UIImageView *deleteImage;
/**
 *  点赞人数
 */
@property (strong,nonatomic) UILabel *deleteLabel;

@end
