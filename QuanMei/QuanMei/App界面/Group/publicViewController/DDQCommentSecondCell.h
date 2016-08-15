//
//  DDQCommentSecondCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/27.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQReplyModel.h"

#import "DDQSonModel.h"


typedef void(^SecondCommentBlock)();

@protocol SecondCommentCellDelegate <NSObject>

@optional
-(void)secondCommentCellPushToReplyVCWithSonModel:(DDQSonModel *)sonModel;
-(void)secondCommentReplyViewPushToReplyVCWithSonModel:(DDQReplyModel *)replyModel;
-(void)secondCommentShowMoreLabelWithReplyModel:(DDQReplyModel *)replyModel;
- (void)secondCommentCellThumbClickWithView:(UIImageView *)imageView Model:(DDQReplyModel *)model;

@end



@interface DDQCommentSecondCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) DDQReplyModel *replyModel;
@property (assign,nonatomic) CGFloat viewHeight;
@property (assign,nonatomic) CGFloat viewtop_H;
@property (assign,nonatomic) CGFloat viewBottom_H;

@property (assign,nonatomic) CGFloat cellHeight;
@property (strong,nonatomic) UITableView *reply_tableView;

@property (assign,nonatomic) CGFloat imageW;
@property (assign,nonatomic) CGFloat imageH;
@property (assign,nonatomic) CGRect totalRect;
@property (copy,nonatomic) SecondCommentBlock secondBlock;
@property (weak,nonatomic) id <SecondCommentCellDelegate> delegate;

@property (strong,nonatomic) NSMutableArray *son_sourceArray;

@property (strong,nonatomic) NSMutableArray *temp_array;

@property (assign,nonatomic) NSInteger view_tag;

-(void)cellWithReplyModel:(DDQReplyModel *)replyModel;

-(void)cellWithCallBack:(SecondCommentBlock)secondBlock;

@end
