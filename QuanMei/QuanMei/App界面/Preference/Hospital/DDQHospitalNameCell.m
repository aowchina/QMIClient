//
//  DDQHospitalNameCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalNameCell.h"

#import "DDQDashesLine.h"

@implementation DDQHospitalNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            }
    return self;
}
-(void)cellWithLogo:(NSString *)logo andHospitalName:(NSString *)hospitalName {
    self.hospitalImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.hospitalImage];
    [self.hospitalImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        if (kScreenHeight == 480) {
            make.width.offset(40);
            make.height.offset(40);
        } else if (kScreenHeight == 568) {
            make.width.offset(45);
            make.height.offset(45);
        } else if (kScreenHeight == 667) {
            make.width.offset(55);
            make.height.offset(55);
        } else {
            make.width.offset(60);
            make.height.offset(60);
        }
    }];
    [self.hospitalImage sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    self.hospitalName = [[UILabel alloc] init];
    [self.contentView addSubview:self.hospitalName];
    [self.hospitalName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hospitalImage.mas_right);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.hospitalImage.mas_height);
        make.centerY.equalTo(self.hospitalImage.mas_centerY);
    }];
    self.hospitalName.font          = [UIFont systemFontOfSize:18.0f];
    self.hospitalName.textAlignment = NSTextAlignmentLeft;
    self.hospitalName.text          = hospitalName;
    
    DDQDashesLine *dashesLine = [[DDQDashesLine alloc] init];
    dashesLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:dashesLine];
    [dashesLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hospitalImage.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.offset(5);
    }];
    dashesLine.startPoint = CGPointMake(0, 3);
    dashesLine.endPoint = CGPointMake(kScreenWidth, 3);
    dashesLine.lineColor = [UIColor grayColor];

}
@end
