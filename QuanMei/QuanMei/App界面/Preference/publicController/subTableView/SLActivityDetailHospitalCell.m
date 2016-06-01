//
//  SLActivityDetailHospitalCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailHospitalCell.h"

#import "SLActivityModel.h"


#define SLDescLabelFontSize 12.f
#define SLSpace 80.f
#define SLDescLabelMagin 6.f


@interface SLActivityDetailHospitalCell ()

@end

@implementation SLActivityDetailHospitalCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubView];
        
    }
    return self;
}
#pragma mark - builder SubView
- (void)buildSubView {
    //12-14
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SLGetScreenWidth(), 40)];
    self.headerLabel.text = @"  医院介绍";
    
    self.headerLabel.backgroundColor = [UIColor backgroundColor];
    
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.headerLabel];

    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40 + 10, 50, 50)];
  //  [self.icon setImage:[UIImage imageNamed:@"示例图片.jpg"]];
    [self.contentView addSubview:self.icon];

    //名字
    self.hospitalNameLbel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40 + 20, 200, 30)];
    
    [self.contentView addSubview:self.hospitalNameLbel];

    self.inButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inButton.frame = CGRectMake(5, 40 + 70, SLGetScreenWidth() - 10.f, 30);
    
    self.inButton.backgroundColor = [UIColor meiHongSe];
    
    self.inButton.layer.cornerRadius =5;
    
    self.inButton.titleLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    [self.inButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [self.inButton addTarget:self action:@selector(handleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.inButton];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];

    
    //医院名,图片
    self.hospitalNameLbel.text = activity.hname;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:activity.himg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [self.inButton setTitle:@"进入医院主页>>>" forState:(UIControlStateNormal)];
}

+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    return 150.f;
}

#pragma mark - buttonAction
- (void)handleButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityDetailBaseCell:didSelectedHospitalID:HospitalName:)]) {
        [self.delegate activityDetailBaseCell:self didSelectedHospitalID:self.activity.hid HospitalName:self.activity.hname];
    }
}

@end
