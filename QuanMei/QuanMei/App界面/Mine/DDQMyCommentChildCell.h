//
//  DDQMyCommentChildCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQMyCommentChildModel.h"

@protocol MyCommentChildCellDelegate <NSObject>

@optional
-(void)myCommentCellDelegateWithTapMethodAndWenzhangId:(NSString *)iD;

@end

@interface DDQMyCommentChildCell : UITableViewCell

@property (weak,nonatomic) id <MyCommentChildCellDelegate> delegate;

/**
 *  cell总共高多少
 */
@property (assign,nonatomic) CGFloat cell_height;
@property (strong,nonatomic) DDQMyCommentChildModel *commentChildModel;

@property (copy,nonatomic) NSString *hfId;

@end
