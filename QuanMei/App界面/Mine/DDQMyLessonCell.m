//
//  DDQMyLessonCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/24.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQMyLessonCell.h"

@implementation DDQMyLessonCell

-(void)setLesson_model:(DDQMyLessonModel *)lesson_model {

    CGFloat splite_t = 5;
    CGFloat splite_l = 5;
    
    NSString *st = [NSString stringWithFormat:@"%@ x%@",lesson_model.name,lesson_model.amount];
    CGRect rect = [st boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} context:nil];
    
    self.title_label = [UILabel new];
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(splite_l);
        make.top.equalTo(self.contentView.mas_top).offset(splite_t);
        make.right.equalTo(self.contentView.mas_right).offset(-splite_l);
        make.height.offset(rect.size.height);
    }];
    self.title_label.text = st;
    self.title_label.textAlignment = NSTextAlignmentLeft;
    
    NSString *str = @"订单号:";
    CGRect dd_rect = [str boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} context:nil];
    
    UILabel *dd_label = [UILabel new];
    [self.contentView addSubview:dd_label];
    [dd_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label.mas_left);
        make.top.equalTo(self.title_label.mas_bottom).offset(20);
        make.width.offset(dd_rect.size.width);
        make.height.offset(dd_rect.size.height);
    }];
    dd_label.font = [UIFont systemFontOfSize:19.0f];
    dd_label.text = str;
    
    CGRect new_rect = [lesson_model.orderid boundingRectWithSize:CGSizeMake(self.frame.size.width - dd_rect.size.width - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} context:nil];
    self.dingdan_label = [UILabel new];
    [self.contentView addSubview:self.dingdan_label];
    [self.dingdan_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dd_label.mas_right).offset(splite_l);
        make.top.equalTo(dd_label.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.height.offset(new_rect.size.height);
    }];
    self.dingdan_label.numberOfLines = 0;
    self.dingdan_label.font = [UIFont systemFontOfSize:19.0f];
    self.dingdan_label.text = lesson_model.orderid;
    
    self.new_rect = splite_t + rect.size.height + 10 + new_rect.size.height + 15;
    
    UIView *line_view = [UIView new];
    [self.contentView addSubview:line_view];
    [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.offset(1);
    }];
    line_view.backgroundColor = [UIColor backgroundColor];
}

@end
