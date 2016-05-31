//
//  DDQHospitalCommentCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQHospitalCommentCell : UITableViewCell

-(void)judgeStarLight:(int)lightNum goodRate:(NSString *)goodRate;

-(void)layOutCommentFirstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent commentNum:(NSString *)commentNum;

@end
