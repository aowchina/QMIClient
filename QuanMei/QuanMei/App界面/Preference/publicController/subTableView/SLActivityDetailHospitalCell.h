//
//  SLActivityDetailHospitalCell.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailBaseCell.h"

@interface SLActivityDetailHospitalCell : SLActivityDetailBaseCell
//医院介绍
@property (nonatomic, strong) UILabel *headerLabel;
//医院院标
@property (nonatomic, strong) UIImageView *icon;
//医院名
@property (nonatomic, strong) UILabel *hospitalNameLbel;
@property (nonatomic, strong) UIButton *inButton;


@end
