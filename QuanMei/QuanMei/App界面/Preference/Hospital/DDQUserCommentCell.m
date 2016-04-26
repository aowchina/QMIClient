//
//  DDQUserCommentCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserCommentCell.h"

@implementation DDQUserCommentCell

-(void)layOutViewWithNickName:(NSString *)nickName date:(NSString *)date intro:(NSString *)intro andStars:(int)count {
    UIView *tempView = [[UIView alloc] init];
    [self.contentView addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    
    UIView *currentView = [[UIView alloc] init];
    [self.contentView addSubview:currentView];
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(self.contentView.mas_height).offset(-20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.offset(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    lineView.backgroundColor = [UIColor backgroundColor];
    
    CGFloat imageWidth = kScreenWidth * 0.3/ 5/2;
    CGFloat imageHeight = 10;
    for (int i = 0; i<count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth*i + 5*i , 5, imageWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:@"icon_little_star_fill"];
        [tempView addSubview:imageView];
    }
    
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [tempView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tempView.mas_right).offset(-5);
        make.height.equalTo(tempView.mas_height);
        make.centerY.equalTo(tempView.mas_centerY);
    }];
    dateLabel.text = date;
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    [tempView addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dateLabel.mas_left).offset(-5);
        make.centerY.equalTo(tempView.mas_centerY);
        make.width.equalTo(tempView.mas_width).multipliedBy(0.3);
        make.height.equalTo(tempView.mas_height);
    }];
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    nickNameLabel.text = nickName;
    nickNameLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _newRect = [intro boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _newRect.size.width, _newRect.size.height)];
    [self.contentView addSubview:introLabel];
    
    introLabel.numberOfLines = 0;
    introLabel.text = intro;
    introLabel.font = [UIFont systemFontOfSize:13.0f];
}

@end
