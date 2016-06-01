//
//  DDQRowThreeTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/24.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQRowThreeTableViewCell.h"

@implementation DDQRowThreeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *intro = [UILabel new];
        [self.contentView addSubview:intro];
        [intro mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth* 0.05);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        intro.text = @"介绍";
        intro.font = [UIFont systemFontOfSize:18.0f];
        intro.textColor = [UIColor lightGrayColor];
        
        self.temp_view = [UIView new];
        [self.contentView addSubview:self.temp_view];
        [self.temp_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}

-(void)setIntro_model:(DDQTeacherIntroModel *)intro_model {

//    if (intro_model.teacher_name != nil && ![intro_model.teacher_name isEqualToString:@""]) {
    UILabel *name_label = [UILabel new];
    [self.temp_view addSubview:name_label];
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth* 0.05 + 15);
        make.top.equalTo(self.contentView.mas_top).offset(45);
    }];
    name_label.text = intro_model.teacher_name;
    name_label.font = [UIFont systemFontOfSize:17.0f];
    name_label.textColor = [UIColor lightGrayColor];
//    }
    
    CGRect t_rect = [intro_model.teacher_intro boundingRectWithSize:CGSizeMake(self.frame.size.width - kScreenWidth* 0.1, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    UILabel *teacher_intro = [UILabel new];
    [self.temp_view addSubview:teacher_intro];
    [teacher_intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(name_label.mas_bottom);
        make.width.offset(t_rect.size.width);
        make.height.offset(t_rect.size.height);
    }];
    teacher_intro.text = intro_model.teacher_intro;
    teacher_intro.font = [UIFont systemFontOfSize:16.0f];
    teacher_intro.textColor = [UIColor lightGrayColor];
    teacher_intro.numberOfLines = 0;
    
    CGRect c_rect = [intro_model.course_intro boundingRectWithSize:CGSizeMake(self.frame.size.width - kScreenWidth* 0.1, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    
    UILabel *course_intro = [UILabel new];
    [self.temp_view addSubview:course_intro];
    [course_intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(teacher_intro.mas_bottom);
        make.width.offset(c_rect.size.width);
        make.height.offset(c_rect.size.height);
    }];
    course_intro.text = intro_model.course_intro;
    course_intro.font = [UIFont systemFontOfSize:16.0f];
    course_intro.textColor = [UIColor lightGrayColor];
    course_intro.numberOfLines = 0;

    self.row_h = 45 + 25 + t_rect.size.height + c_rect.size.height ;
    
}

@end
