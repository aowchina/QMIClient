//
//  DDQDetailControllerProjectCell.m
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDetailControllerProjectCell.h"

#import "Masonry.h"

@implementation DDQDetailControllerProjectCell
@synthesize backgroundView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        [self.contentView addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        self.modelImageView = [[UIImageView alloc] init];
        [self.backgroundView addSubview:self.modelImageView];
        [self.modelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView.mas_top);
            make.left.equalTo(self.backgroundView.mas_left);
            make.bottom.equalTo(self.backgroundView.mas_bottom);
            make.width.equalTo(self.backgroundView.mas_width).with.multipliedBy(0.4);
        }];
        
        self.projectIntro = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.projectIntro];
        [self.projectIntro mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView.mas_top);
            make.right.equalTo(self.backgroundView.mas_right);
            make.left.equalTo(self.modelImageView.mas_right).with.offset(10);
            make.height.equalTo(self.modelImageView.mas_height).with.multipliedBy(0.5);
        }];
        [self.projectIntro setNumberOfLines:0];
        [self.projectIntro setFont:[UIFont systemFontOfSize:18.0f]];
        
        self.projectHospital = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.projectHospital];
        [self.projectHospital mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.projectIntro.mas_width);
            make.centerX.equalTo(self.projectIntro.mas_centerX);
            make.top.equalTo(self.projectIntro.mas_bottom).with.offset(5);
            make.height.equalTo(self.projectIntro.mas_height).with.multipliedBy(0.3);
        }];
        //[self.projectHospital setBackgroundColor:[UIColor yellowColor]];
        
        self.sellNum = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.sellNum];
        [self.sellNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backgroundView.mas_right);
            make.bottom.equalTo(self.backgroundView.mas_bottom);
            make.height.equalTo(self.projectHospital.mas_height);
            make.width.equalTo(self.projectHospital.mas_width).with.multipliedBy(0.2);
        }];
        //[self.sellNum setBackgroundColor:[UIColor purpleColor]];
        [self.sellNum setFont:[UIFont systemFontOfSize:10.0f]];

        
        self.projectPrice = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.projectPrice];
        [self.projectPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sellNum.mas_centerY).with.offset(-10);
            make.left.equalTo(self.modelImageView.mas_right).with.offset(10);
            make.width.equalTo(self.projectIntro.mas_width).with.multipliedBy(0.5);
            make.height.equalTo(self.projectIntro.mas_height).with.multipliedBy(0.45);
        }];
        //[self.projectPrice setBackgroundColor:[UIColor orangeColor]];
    }
    return self;
}


@end
