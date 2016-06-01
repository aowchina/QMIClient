//
//  DDQMainHotProjectTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/15.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMainHotProjectTableViewCell.h"

@implementation DDQMainHotProjectTableViewCell
@synthesize backgroundView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView = [[UIView alloc] init];
        [self addSubview:self.backgroundView];
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
            make.width.equalTo(self.modelImageView.mas_height);
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
        [self.projectHospital setFont:[UIFont systemFontOfSize:15.0f]];
        _projectHospital.textColor =[UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1];
        
        
        self.sellNum = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.sellNum];
        [self.sellNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backgroundView.mas_right);
            make.bottom.equalTo(self.backgroundView.mas_bottom);
            make.height.equalTo(self.projectHospital.mas_height);
            make.width.equalTo(self.projectHospital.mas_width).with.multipliedBy(0.4);
        }];
        [self.sellNum setFont:[UIFont systemFontOfSize:10.0f]];
        [self.sellNum setTextAlignment:NSTextAlignmentRight];
        _sellNum.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1];
        
        self.projectPrice = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.projectPrice];
        [self.projectPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundView.mas_bottom);
            make.left.equalTo(self.modelImageView.mas_right).with.offset(10);
            make.width.equalTo(self.projectIntro.mas_width).with.multipliedBy(0.4);
            make.height.equalTo(self.projectIntro.mas_height).with.multipliedBy(0.40);
        }];
        _projectPrice.textColor = [UIColor colorWithRed:238.0/255.0 green:129.0/255.0 blue:126.0/255.0 alpha:1];
        self.projectIntro.font = [UIFont systemFontOfSize:15.0f];
        
        
        self.oldPrice = [[UILabel alloc] init];
        [self.backgroundView addSubview:self.oldPrice];
        [self.oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.projectPrice.mas_right);
            make.width.equalTo(self.projectPrice.mas_width);
            make.bottom.equalTo(self.projectPrice.mas_bottom).with.offset(-2);
            make.height.equalTo(self.projectPrice.mas_height).with.multipliedBy(0.6);
        }];
        
        _oldPrice.textColor =[UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1];
        
    }
    return self;
}
@end
