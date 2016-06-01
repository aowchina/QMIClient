//
//  DDQSetMessageCell.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/15.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQSetMessageCell.h"


@interface DDQSetMessageCell ()

@property (nonatomic, strong)UISwitch *setSwitch;

@end

@implementation DDQSetMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSwitch];
    }
    return self;
}
- (void)dealloc {
    self.setSwitch = nil;
}
- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    self.textLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.center = CGPointMake(self.textLabel.center.x, CGRectGetMidY(self.contentView.bounds));
    
    self.setSwitch.center = CGPointMake(self.contentView.bounds.size.width - 12 - self.setSwitch.bounds.size.width / 2, CGRectGetMidY(self.contentView.bounds));
}
- (void)buildSwitch {
    
    self.setSwitch = [[UISwitch alloc] init];

    [self.setSwitch addTarget:self action:@selector(handleSetSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.setSwitch];
}

- (void)handleSetSwitchChanged:(UISwitch *)setSwitch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DDQSettingCell:DidChangeSwitchState:)]) {
        [self.delegate DDQSettingCell:self DidChangeSwitchState:self.setSwitch.isOn];
        
    }
}


@end
