//
//  DDQScreenProjectDetailTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectDetailTableViewCell.h"

@implementation DDQScreenProjectDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.05, kScreenHeight*0.01, self.contentView.frame.size.width/3, self.contentView.frame.size.height)];
        
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.65, kScreenHeight*0.01, kScreenWidth*0.3, self.contentView.frame.size.height)];
        
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        
        _rightLabel.font = [UIFont boldSystemFontOfSize:15];
        
        _rightLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1];
        
        
        [self.contentView addSubview: _rightLabel];
    }
    return self;
}

@end
