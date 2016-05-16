//
//  DDQDoctorIntroCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDoctorIntroCell.h"

@implementation DDQDoctorIntroCell

-(void)cellWithDoctorIntro:(NSString *)intro andImageStr:(NSString *)imageStr andDoctorName:(NSString *)doctorName andDoctorSkill:(NSString *)doctorSkill andDoctorMajor:(NSString *)doctorMajor {

    UIView *tempView = [[UIView alloc] init];
    [self.contentView addSubview:tempView];
    if (kScreenHeight == 480) {
        
        tempView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 60);
    
    } else if (kScreenHeight == 568) {
        
        tempView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 65);

    } else if (kScreenHeight == 667) {
        
        tempView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 75);

    } else {
        
        tempView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 80);
    }
    tempView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    [tempView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left);
        make.bottom.equalTo(tempView.mas_bottom);
        make.height.offset(1);
        make.width.equalTo(self.contentView.mas_width);
    }];
    lineView.backgroundColor = [UIColor backgroundColor];
    
    UIImageView *doctor_image = [[UIImageView alloc] init];
    [tempView addSubview:doctor_image];
    [doctor_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempView.mas_left).offset(10);
        make.centerY.equalTo(tempView.mas_centerY);
        if (kScreenHeight == 480) {
            make.width.offset(40);
            make.height.offset(40);
        } else if (kScreenHeight == 568) {
            make.width.offset(45);
            make.height.offset(45);
        } else if (kScreenHeight == 667) {
            make.width.offset(55);
            make.height.offset(55);
        } else {
            make.width.offset(65);
            make.height.offset(65);
        }
    }];
    
    //这是是适配为了偷懒，写到一起了
    UILabel *doctor_name = [[UILabel alloc] init];
    [tempView addSubview:doctor_name];
    CGRect nameRect;
    
    UILabel *doctor_skill = [[UILabel alloc] init];
    [tempView addSubview:doctor_skill];
    CGRect skillRect;
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    [self.contentView addSubview:bottomLabel];
    //CGRect labelRect;
    
    if (kScreenHeight == 480) {
        
        doctor_image.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 50);
        doctor_image.layer.cornerRadius  = 20.0f;
        doctor_image.layer.masksToBounds = YES;
        [doctor_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        doctor_image.backgroundColor     = [UIColor redColor];
        
        nameRect = [doctorName boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:3.0f]} context:nil];
        doctor_name.frame = CGRectMake(55, 10, nameRect.size.width, nameRect.size.height);
        doctor_name.font  = [UIFont systemFontOfSize:15.0f weight:3.0f];
        doctor_name.text  = doctorName;
        
        skillRect          = [doctorSkill boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, nameRect.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor backgroundColor]} context:nil];
        doctor_skill.frame = CGRectMake(55, 15+nameRect.size.height, skillRect.size.width, skillRect.size.height);
        doctor_skill.font  = [UIFont systemFontOfSize:13.0f];
        doctor_skill.text  = doctorSkill;
        
        _newRect                  = [intro boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
        bottomLabel.frame         = CGRectMake(0, 60, _newRect.size.width, _newRect.size.height);
        bottomLabel.text          = intro;
        bottomLabel.font          = [UIFont systemFontOfSize:13.0f];
        bottomLabel.numberOfLines = 0;

    } else if (kScreenHeight == 568) {
        
        doctor_image.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 55);
        doctor_image.layer.cornerRadius  = 22.5f;
        doctor_image.layer.masksToBounds = YES;
        [doctor_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        doctor_image.backgroundColor     = [UIColor redColor];
        
        nameRect = [doctorName boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:3.0f]} context:nil];
        doctor_name.frame = CGRectMake(60, 10, nameRect.size.width, nameRect.size.height);
        doctor_name.font  = [UIFont systemFontOfSize:15.0f weight:3.0f];
        doctor_name.text  = doctorName;
        
        skillRect          = [doctorSkill boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, nameRect.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor backgroundColor]} context:nil];
        doctor_skill.frame = CGRectMake(60, 15+nameRect.size.height, skillRect.size.width, skillRect.size.height);
        doctor_skill.font  = [UIFont systemFontOfSize:13.0f];
        doctor_skill.text  = doctorSkill;

        _newRect                  = [intro boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
        bottomLabel.frame         = CGRectMake(3, 65, _newRect.size.width, _newRect.size.height);
        bottomLabel.text          = intro;
        bottomLabel.font          = [UIFont systemFontOfSize:13.0f];
        bottomLabel.numberOfLines = 0;
        
    } else if (kScreenHeight == 667) {
        
        doctor_image.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 65);
        doctor_image.layer.cornerRadius  = 27.5f;
        doctor_image.layer.masksToBounds = YES;
        [doctor_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        doctor_image.backgroundColor     = [UIColor redColor];
        
        nameRect = [doctorName boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:3.0f]} context:nil];
        doctor_name.frame = CGRectMake(70, 10, nameRect.size.width, nameRect.size.height);
        doctor_name.font  = [UIFont systemFontOfSize:15.0f weight:3.0f];
        doctor_name.text  = doctorName;
        
        skillRect          = [doctorSkill boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, nameRect.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor backgroundColor]} context:nil];
        doctor_skill.frame = CGRectMake(70, 15+nameRect.size.height, skillRect.size.width, skillRect.size.height);
        doctor_skill.font  = [UIFont systemFontOfSize:13.0f];
        doctor_skill.text  = doctorSkill;
        
        _newRect                  = [intro boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
        bottomLabel.frame         = CGRectMake(3, 70, _newRect.size.width, _newRect.size.height);
        bottomLabel.text          = intro;
        bottomLabel.font          = [UIFont systemFontOfSize:13.0f];
        bottomLabel.numberOfLines = 0;
        
    } else {
        
        doctor_image.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 70);
        doctor_image.layer.cornerRadius  = 30.0f;
        doctor_image.layer.masksToBounds = YES;
        [doctor_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        doctor_image.backgroundColor     = [UIColor redColor];
        
        nameRect = [doctorName boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:3.0f]} context:nil];
        doctor_name.frame = CGRectMake(75, 10, nameRect.size.width, nameRect.size.height);
        doctor_name.font  = [UIFont systemFontOfSize:15.0f weight:3.0f];
        doctor_name.text  = doctorName;
        
        skillRect          = [doctorSkill boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, nameRect.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor backgroundColor]} context:nil];
        doctor_skill.frame = CGRectMake(75, 15+nameRect.size.height, skillRect.size.width, skillRect.size.height);
        doctor_skill.font  = [UIFont systemFontOfSize:13.0f];
        doctor_skill.text  = doctorSkill;
        
        _newRect                  = [intro boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
        bottomLabel.frame         = CGRectMake(4, 80, _newRect.size.width, _newRect.size.height);
        bottomLabel.text          = intro;
        bottomLabel.font          = [UIFont systemFontOfSize:13.0f];
        bottomLabel.numberOfLines = 0;

    }
    
    UILabel *doctor_major = [[UILabel alloc] init];
    [tempView addSubview:doctor_major];
    [doctor_major mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(doctor_name.mas_centerY);
        make.left.equalTo(doctor_name.mas_right);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.25);
        make.height.equalTo(doctor_name.mas_height);
    }];
    doctor_major.layer.cornerRadius  = nameRect.size.height/2;
    doctor_major.layer.masksToBounds = YES;
    doctor_major.backgroundColor     = [UIColor orangeColor];
    doctor_major.font                = [UIFont systemFontOfSize:11.0f];
    doctor_major.textColor           = [UIColor whiteColor];
    doctor_major.text                = doctorMajor;
    doctor_major.textAlignment       = NSTextAlignmentCenter;
}


@end
