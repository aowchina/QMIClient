//
//  DDQUserDiaryViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserDiaryViewCell.h"

@implementation DDQUserDiaryViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *topview = [[UIView alloc] init];
        [self addSubview:topview];
        [topview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(self.mas_height).with.multipliedBy(0.1);
            make.width.equalTo(self.mas_width);
        }];
        topview.backgroundColor = [UIColor myGrayColor];
        
        
        UIImageView *cicrleImage = [[UIImageView alloc] init];
        [topview addSubview:cicrleImage];
        [cicrleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topview.mas_centerY);
            make.left.equalTo(topview.mas_left).with.offset(10);
            if (kScreenHeight == 480) {
                make.height.offset(30);
                make.width.offset(30);
            } else if (kScreenHeight == 568) {
                make.height.offset(40);
                make.width.offset(40);
            } else {
                make.height.offset(50);
                make.width.offset(50);
            }
            
        }];
        cicrleImage.image = [UIImage  imageNamed:@"apptheme_btn_radio_on_disabled_holo_light"];
        
        
        
        self.floorNum = [[UILabel alloc] init];
        [cicrleImage addSubview:self.floorNum];
        [self.floorNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cicrleImage.mas_centerX);
            make.centerY.equalTo(cicrleImage.mas_centerY);
            make.width.offset(15);
            make.height.offset(15);
        }];
        self.floorNum.font = [UIFont systemFontOfSize:9.0f];
        self.floorNum.textColor = [UIColor whiteColor];
        self.floorNum.textAlignment = NSTextAlignmentCenter;
        self.floorNum.text = @"11";
        
        self.tempView = [[UIView alloc] init];
        [self addSubview:self.tempView];
        [self.tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(self.mas_height).with.multipliedBy(0.9);
        }];
        self.tempView.backgroundColor = [UIColor whiteColor];
        
        UIView *view1 = [[UIView alloc] init];
        [topview addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cicrleImage.mas_centerX);
            make.top.equalTo(self.mas_bottom);
            make.height.offset(self.frame.size.height*0.2-2);
            make.width.offset(2);
        }];
        view1.backgroundColor = [UIColor blackColor];
        
        UIView *view2 = [[UIView alloc] init];
        [topview addSubview:view2];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cicrleImage.mas_centerX);
            make.bottom.equalTo(self.tempView.mas_top);
            make.height.offset(self.frame.size.height*0.2-2);
            make.width.offset(2);
        }];
        view2.backgroundColor = [UIColor blackColor];
        
        //这个评论的label需要自适应
        self.commpentLabel = [[UILabel alloc] init];
        [self.tempView addSubview:self.commpentLabel];
        [self.commpentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tempView.mas_left);
            make.right.equalTo(self.tempView.mas_right);
            make.top.equalTo(self.tempView.mas_top);
            make.height.equalTo(self.tempView.mas_height).with.multipliedBy(0.3);
        }];
        self.commpentLabel.numberOfLines = 0;
        self.commpentLabel.text = @"你是我的小呀小苹果,怎么爱你都不嫌多。你是我的小呀小苹果,怎么爱你都不嫌多。你是我的小呀小苹果,怎么爱你都不嫌多。";
    
        self.userImage = [[UIImageView alloc] init];
        [self.tempView addSubview:self.userImage];
        [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commpentLabel.mas_bottom);
            make.left.equalTo(self.tempView.mas_left).with.offset(5);
            make.height.equalTo(self.tempView.mas_height).with.multipliedBy(0.3);
            make.width.equalTo(self.tempView.mas_width).with.multipliedBy(0.5);
        }];
        self.userImage.backgroundColor = [UIColor cyanColor];
        
        self.replyNum = [[UILabel alloc] init];
        [self.tempView addSubview:self.replyNum];
        [self.replyNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImage.mas_bottom).with.offset(20);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.width.offset(15);
            make.height.offset(15);
        }];
        [self.replyNum setFont:[UIFont systemFontOfSize:13.0f]];
        self.replyNum.text = @"2";
        self.replyNum.textAlignment = NSTextAlignmentCenter;

        self.replyImageView = [[UIImageView alloc] init];
        [self.tempView addSubview:self.replyImageView];
        [self.replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.replyNum.mas_centerY);
            make.width.equalTo(self.replyNum.mas_width);
            make.height.equalTo(self.replyNum.mas_height);
            make.right.equalTo(self.replyNum.mas_left);
        }];
        self.replyImageView.image = [UIImage imageNamed:@"review"];

        self.thumbUpNum = [[UILabel alloc] init];
        [self.tempView addSubview:self.thumbUpNum];
        [self.thumbUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.replyNum.mas_centerY);
            make.right.equalTo(self.replyImageView.mas_left);
            make.width.offset(40);
            make.height.offset(40);
        }];
        [self.thumbUpNum setFont:[UIFont systemFontOfSize:13.0f]];
        self.thumbUpNum.text = @"156";

        self.thumbImageView = [[UIImageView alloc] init];
        [self.tempView addSubview:self.thumbImageView];
        [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.replyNum.mas_centerY);
            make.width.equalTo(self.replyNum.mas_width);
            make.height.equalTo(self.replyNum.mas_height);
            make.right.equalTo(self.thumbUpNum.mas_left).with.offset(-5);
        }];
        self.thumbImageView.image = [UIImage imageNamed:@"like"];
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.equalTo(self.replyNum.mas_bottom).with.offset(15);
            make.height.offset(1);
        }];
        lineView.backgroundColor = [UIColor myGrayColor];
        
        self.firstCommentUserLabel = [[UILabel alloc] init];
        [self.tempView addSubview:self.firstCommentUserLabel];
        [self.firstCommentUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_left);
            make.right.equalTo(lineView.mas_right);
            make.top.equalTo(lineView.mas_top);
            make.height.equalTo(self.tempView.mas_height).with.multipliedBy(0.1);
        }];
        self.firstCommentUserLabel.numberOfLines = 0;
        self.firstCommentUserLabel.font = [UIFont systemFontOfSize:14.0f];
        self.firstCommentUserLabel.text = @"用户1:我是你的小苹果";
        
        self.secondCommentUserLabel = [[UILabel alloc] init];
        [self.tempView addSubview:self.secondCommentUserLabel];
        [self.secondCommentUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstCommentUserLabel.mas_left);
            make.right.equalTo(self.firstCommentUserLabel.mas_right);
            make.top.equalTo(self.firstCommentUserLabel.mas_bottom);
            make.height.equalTo(self.tempView.mas_height).with.multipliedBy(0.1);
        }];
        self.secondCommentUserLabel.numberOfLines = 0;
        self.secondCommentUserLabel.font = [UIFont systemFontOfSize:14.0f];
        self.secondCommentUserLabel.text = @"用户2:我是你的小水果";
        
        
    }
    return self;
}

-(void)setDiaryModel:(DDQDiaryModel *)diaryModel {

}

@end
