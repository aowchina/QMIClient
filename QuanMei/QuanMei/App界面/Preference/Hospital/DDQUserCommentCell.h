//
//  DDQUserCommentCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQUserCommentCell : UITableViewCell

@property (assign,nonatomic) CGRect newRect;

-(void)layOutViewWithNickName:(NSString *)nickName date:(NSString *)date intro:(NSString *)intro andStars:(int)count;

@end
