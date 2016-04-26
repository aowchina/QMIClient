//
//  DDQCommentFirstCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/27.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQCommentModel.h"

@interface DDQCommentFirstCell : UITableViewCell

@property (strong,nonatomic) DDQCommentModel *commentModel;
@property (assign,nonatomic) CGFloat newHeight;

-(void)cellWithCommentModel:(DDQCommentModel *)commentModel;


@end
