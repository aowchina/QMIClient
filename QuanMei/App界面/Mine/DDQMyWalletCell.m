//
//  DDQMyWalletCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/2/20.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQMyWalletCell.h"

@implementation DDQMyWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
         *  周几
         */
        self.zhouji = [UILabel new];
        [self.contentView addSubview:self.zhouji];
        [self.zhouji mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.height.offset(30);
            make.width.offset(60);
        }];
        self.zhouji.textAlignment = NSTextAlignmentCenter;
        self.zhouji.textColor = [UIColor lightGrayColor];
        
        /**
         *  时间
         */
        self.shijian = [UILabel new];
        [self.contentView addSubview:self.shijian];
        [self.shijian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.height.offset(30);
            make.width.offset(60);
        }];
        self.shijian.textAlignment = NSTextAlignmentCenter;
        self.shijian.textColor = [UIColor lightGrayColor];
        
        /**
         *  图片
         */
        self.tupian = [UIImageView new];
        [self.contentView addSubview:self.tupian];
        [self.tupian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.offset(60);
            make.width.offset(60);
            make.left.equalTo(self.shijian.mas_right).offset(10);
        }];
        
        /**
         *  积分
         */
        self.jifen = [UILabel new];
        [self.contentView addSubview:self.jifen];
        [self.jifen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
            make.left.equalTo(self.tupian.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.offset(40);
        }];
        self.jifen.textAlignment = NSTextAlignmentLeft;
        self.jifen.font = [UIFont systemFontOfSize:20.0f];
        
        /**
         *  内容
         */
        self.neirong = [UILabel new];
        [self.contentView addSubview:self.neirong];
        [self.neirong mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shijian.mas_centerY);
            make.left.equalTo(self.tupian.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.offset(30);
        }];
        self.neirong.textAlignment = NSTextAlignmentLeft;
        self.neirong.font = [UIFont systemFontOfSize:17.0f];
    }
    return self;
}

- (void)layoutSubviews {

   
}


@end
