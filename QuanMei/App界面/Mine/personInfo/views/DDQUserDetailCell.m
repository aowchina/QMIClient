//
//  DDQUserDetailCell.m
//  QuanMei
//
//  Created by superlian on 15/12/3.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQUserDetailCell.h"

@implementation DDQUserDetailCell

- (void)awakeFromNib {
    // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
