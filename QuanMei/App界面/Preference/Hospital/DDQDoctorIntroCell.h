//
//  DDQDoctorIntroCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQDoctorIntroCell : UITableViewCell

@property (assign,nonatomic) CGRect newRect;

-(void)cellWithDoctorIntro:(NSString *)intro andImageStr:(NSString *)imageStr andDoctorName:(NSString *)doctorName andDoctorSkill:(NSString *)doctorSkill andDoctorMajor:(NSString *)doctorMajor;

@end
