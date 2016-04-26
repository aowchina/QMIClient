//
//  DDQZanedCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQZanedCell.h"

@implementation DDQZanedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.mz_userimg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.mz_userimg];
        [self.mz_userimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.offset(35);
            make.height.offset(35);
        }];
        
        [self.mz_userimg.layer setCornerRadius:17.5f];
        
        self.mz_username = [[UILabel alloc] init];
        [self.contentView addSubview:self.mz_username];
        [self.mz_username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(15);
            make.left.equalTo(self.mz_userimg.mas_right).offset(10);
            make.height.offset(20);
            make.top.equalTo(self.mz_userimg.mas_top);
        }];
        self.mz_username.font = [UIFont systemFontOfSize:16.0f];
        
        self.mz_pubtime = [[UILabel alloc] init];
        [self.contentView addSubview:self.mz_pubtime];
        [self.mz_pubtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mz_username.mas_left);
            make.top.equalTo(self.mz_username.mas_bottom).offset(5);
            make.height.offset(15);
        }];
        self.mz_pubtime.font = [UIFont systemFontOfSize:12.0f];

        UILabel *temp_label = [[UILabel alloc] init];
        [self.contentView addSubview:temp_label];
        [temp_label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mz_pubtime.mas_left);
            make.top.equalTo(self.mz_pubtime.mas_bottom).offset(10);
            make.height.offset(20);
        }];
        
        temp_label.font = [UIFont systemFontOfSize:14.0f];
        temp_label.text = @"对您点赞";
        
        UIView *line_view = [[UIView alloc] init];
        [self.contentView addSubview:line_view];
        [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(temp_label.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(10);
            make.top.equalTo(temp_label.mas_bottom).offset(5);
            make.height.offset(1);
        }];
        line_view.backgroundColor = [UIColor backgroundColor];
        
        NSString *temp_string = @"对你的帖子:";
        CGRect temp_rect = [temp_string boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
        UILabel *type_label = [[UILabel alloc] init];
        [self.contentView addSubview:type_label];
        [type_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(temp_rect.size.width);
            make.top.equalTo(line_view.mas_bottom).offset(5);
            make.height.offset(20);
            make.left.equalTo(line_view.mas_left);
        }];
        
        type_label.text = temp_string;
        type_label.font = [UIFont systemFontOfSize:12.0f];
        type_label.textColor = [UIColor meiHongSe];
        
        self.mz_content = [[UILabel alloc] init];
        [self.contentView addSubview:self.mz_content];
        [self.mz_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(type_label.mas_right);
            make.top.equalTo(type_label.mas_top);
            make.height.equalTo(type_label.mas_height);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        self.mz_content.font = [UIFont systemFontOfSize:14.0f];
    }
    return self;

}

@end
