//
//  DDQGroupHeaderViewItem.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQGroupHeaderViewItem.h"

@implementation DDQGroupHeaderViewItem

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kScreenWidth == 320) {
                make.left.equalTo(self.mas_left).with.offset(10);
                make.width.equalTo(@60);
                make.height.equalTo(@60);
                if (kScreenHeight == 480) {//4s
                    make.top.equalTo(self.mas_top).with.offset(10);
                } else if (kScreenHeight == 568) {//5/5s/5c
                    make.top.equalTo(self.mas_top).with.offset(15);
                }
            } else if (kScreenWidth == 375) {//6
                make.left.equalTo(self.mas_left).with.offset(12);
                make.width.equalTo(@70);
                make.height.equalTo(@70);
                make.top.equalTo(self.mas_top).with.offset(23);
            } else {//6p
                make.left.equalTo(self.mas_left).with.offset(11.5);
                make.width.equalTo(@80);
                make.height.equalTo(@80);
                make.top.equalTo(self.mas_top).with.offset(27);
            }
            
        }];
        if (kScreenWidth == 320) {
            [self.headerImageView.layer setCornerRadius:30.0f];
        } else if (kScreenWidth == 375) {
            [self.headerImageView.layer setCornerRadius:35.0f];
        } else {
            [self.headerImageView.layer setCornerRadius:40.0f];
        }
        
        self.headerLabel = [[UILabel alloc] init];
        [self addSubview:self.headerLabel];
        [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.headerImageView.mas_bottom);
            make.height.equalTo(self.mas_height).with.multipliedBy(0.3);
        }];
        [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

@end
