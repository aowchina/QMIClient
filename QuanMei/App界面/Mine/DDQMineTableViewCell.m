//
//  DDQMineTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/2.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMineTableViewCell.h"

#import "Masonry.h"

@implementation DDQMineTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImageView = [[UIImageView alloc] init];
        [self addSubview:self.cellImageView];
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).with.offset(self.frame.size.height*0.2);
//            make.left.equalTo(self.mas_left).with.offset(30);
//            make.bottom.equalTo(self.mas_bottom).with.offset(-self.frame.size.height*0.2);
//            make.width.equalTo(self.mas_width).with.multipliedBy(0.1);
            make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5);
            make.width.equalTo(self.cellImageView.mas_height);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
            if (kScreenWidth > 414) {
                
                make.left.offset(40);
            } else {
                make.left.offset(30);
            }

        }];
        self.cellImageView.contentMode = UIImageResizingModeStretch;
        
        self.cellLabel = [[UILabel alloc] init];
        [self addSubview:self.cellLabel];
        [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellImageView.mas_centerY);
            make.left.equalTo(self.cellImageView.mas_right).with.offset(20);
            make.width.equalTo(self.mas_width).with.multipliedBy(0.3);
            make.height.equalTo(self.mas_height).with.multipliedBy(0.5);
        }];
        [self.cellLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}

@end
