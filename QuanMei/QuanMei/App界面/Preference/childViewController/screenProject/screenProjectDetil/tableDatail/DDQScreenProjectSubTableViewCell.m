//
//  DDQScreenProjectSubTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectSubTableViewCell.h"

@implementation DDQScreenProjectSubTableViewCell

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
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.05, 0, self.contentView.frame.size.width/3, self.contentView.frame.size.height)];
        
        [self.contentView addSubview:_typeLabel];
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/4*3, 0, self.contentView.frame.size.width/4, self.contentView.frame.size.height)];
        
        [self.contentView addSubview: _imgView];
        
    }
    return self;
}

@end
