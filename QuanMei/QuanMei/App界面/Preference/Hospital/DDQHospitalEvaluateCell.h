//
//  DDQHospitalEvaluateCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQHospitalEvaluateCell : UITableViewCell

@property (assign,nonatomic) CGRect newRect;

-(void)cellWithUserImageUrl:(NSString *)userImage andUserName:(NSString *)userName andDate:(NSString *)date andStarCount:(int)count andUserComment:(NSString *)userComment andProjectInto:(NSString *)projectIntro andProjectImg:(NSString *)img;

@end
