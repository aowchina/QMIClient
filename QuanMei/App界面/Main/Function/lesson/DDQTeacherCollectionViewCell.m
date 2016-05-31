//
//  DDQTeacherCollectionViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQTeacherCollectionViewCell.h"

@implementation DDQTeacherCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        CGFloat img_W;
        if (kScreenWidth > 375) {
            img_W = 120;
        } else {
            img_W = 90;
        }
        self.teacher_img = [[UIImageView alloc] init];
        [self.contentView addSubview:self.teacher_img];
        [self.teacher_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
            if (kScreenWidth <= 375) {
                make.width.offset(img_W);
                make.height.offset(img_W);
            } else {
                make.width.offset(img_W);
                make.height.offset(img_W);
            }
        }];
        [self.teacher_img.layer setCornerRadius:img_W*0.5];
        
        self.teacher_name = [[UILabel alloc] init];
        [self.contentView addSubview:self.teacher_name];
        [self.teacher_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.teacher_img.mas_bottom).offset(5);
            make.centerX.equalTo(self.teacher_img.mas_centerX);
            make.height.offset(20);
        }];
        self.teacher_name.font = [UIFont systemFontOfSize:15.0f];
        self.teacher_name.textColor = [UIColor lightGrayColor];
        
    }
    return self;
}


@end
