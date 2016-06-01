//
//  DDQRowOneTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQRowOneTableViewCell.h"

@implementation DDQRowOneTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
//        CGRect rect = [atrributedString boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        self.RO_priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.RO_priceLabel];
        [self.RO_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        self.RO_priceLabel.font = [UIFont systemFontOfSize:15.0f];
        self.RO_priceLabel.textAlignment = NSTextAlignmentLeft;
        
        self.RO_lessonLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.RO_lessonLabel];
        [self.RO_lessonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.RO_priceLabel.mas_right).offset(5);
            make.centerY.equalTo(self.RO_priceLabel.mas_centerY);
        }];
        self.RO_lessonLabel.font = [UIFont systemFontOfSize:16.0f];
        self.RO_lessonLabel.textAlignment = NSTextAlignmentLeft;
        
        UIView *lineview = [UIView new];
        [self.contentView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.offset(1);
        }];
        lineview.backgroundColor = [UIColor backgroundColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
