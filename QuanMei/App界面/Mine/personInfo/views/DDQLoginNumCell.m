//
//  DDQLoginNumCell.m
//  QuanMei
//
//  Created by superlian on 15/12/3.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQLoginNumCell.h"

@interface DDQLoginNumCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBottomLabel;

@end
@implementation DDQLoginNumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildLeftLabel];
        [self buildRightTopLabel];
        [self buildRightBottomLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftLabel.frame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(self.contentView.frame) / 5,
                                      CGRectGetHeight(self.contentView.frame));
    self.rightTopLabel.frame = CGRectMake(CGRectGetWidth(self.leftLabel.frame),
                                          0,
                                          CGRectGetWidth(self.contentView.frame) * 4 / 5,
                                          CGRectGetHeight(self.contentView.frame) / 2);
    self.rightBottomLabel.frame = CGRectMake(CGRectGetWidth(self.leftLabel.frame),
                                             CGRectGetHeight(self.contentView.frame) / 2,
                                             CGRectGetWidth(self.contentView.frame) * 4 / 5,
                                             CGRectGetHeight(self.contentView.frame) / 2);
    
}

- (void)buildLeftLabel {
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = [UIFont systemFontOfSize:13.f];
    self.leftLabel.text = @"等级增长";
    self.leftLabel.textColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1];
    [self.contentView addSubview:self.leftLabel];
}
- (void)buildRightTopLabel {
    self.rightTopLabel = [[UILabel alloc] init];
    self.rightTopLabel.font = [UIFont systemFontOfSize:13.f];
    self.rightTopLabel.text = @"登陆次数";
    self.rightTopLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTopLabel.textColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255 blue:73.f / 255 alpha:1];
    [self.contentView addSubview:self.rightTopLabel];
}
- (void)buildRightBottomLabel {
    self.rightBottomLabel = [[UILabel alloc] init];
    self.rightBottomLabel.font = [UIFont systemFontOfSize:13.f];
    self.rightBottomLabel.textColor = [UIColor colorWithRed:144.f / 255 green:144.f / 255 blue:144.f / 255 alpha:1];
    self.rightBottomLabel.textAlignment = NSTextAlignmentCenter;
    self.rightBottomLabel.text = @"（每日0点前登陆计1次，重复登陆不计算）";
    [self.contentView addSubview:self.rightBottomLabel];
}
@end
