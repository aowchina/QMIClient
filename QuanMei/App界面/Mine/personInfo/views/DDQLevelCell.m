//
//  DDQLevelCell.m
//  QuanMei
//
//  Created by superlian on 15/12/2.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQLevelCell.h"


@interface DDQLevelCell ()

@property (nonatomic, strong, readwrite) UILabel *leftLabel;
@property (nonatomic, strong, readwrite) UILabel *rightLabel;

@end
@implementation DDQLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildLeftLabel];
        [self buildRightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) / 5 - 1, CGRectGetHeight(self.contentView.frame));
    self.rightLabel.frame = CGRectMake(CGRectGetWidth(self.leftLabel.frame) + 1, 0, CGRectGetWidth(self.contentView.frame) * 4 / 5, CGRectGetHeight(self.contentView.frame));
}

#pragma mark - Public
- (void)setUserHighlighted:(BOOL)userHighlighted {
    _userHighlighted = userHighlighted;
    
    [self reloadSubviewThemeWithUserHighlighted:_userHighlighted];
}
/**
 * @ author SuperLian
 *
 * @ date   12.3
 *
 * @ func   初始化子视图
 */
#pragma mark - build SubView
- (void)buildLeftLabel {
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.backgroundColor = [UIColor colorWithRed:211.f / 255 green:211.f / 255 blue:211.f / 255 alpha:1];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.leftLabel];
}
- (void)buildRightLabel {
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
        self.rightLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.rightLabel];
}

#pragma mark - Private
- (void)reloadSubviewThemeWithUserHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.leftLabel.backgroundColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255
                                                          blue:73.f / 255 alpha:1];
        self.leftLabel.textColor = [UIColor whiteColor];
        
        self.rightLabel.backgroundColor = [UIColor whiteColor];
        self.rightLabel.textColor = [UIColor colorWithRed:251.f / 255 green:31.f / 255
                                                     blue:73.f / 255 alpha:1];
    } else {
        self.leftLabel.backgroundColor = self.leftLabel.backgroundColor = [UIColor colorWithRed:211.f / 255 green:211.f / 255 blue:211.f / 255 alpha:1];
        self.leftLabel.textColor = [UIColor blackColor];
        
        self.rightLabel.backgroundColor = [UIColor whiteColor];
        self.rightLabel.textColor = [UIColor blackColor];
    }
}

@end
