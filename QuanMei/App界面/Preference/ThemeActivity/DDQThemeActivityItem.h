//
//  DDQThemeActivityItem.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhutiModel.h"

@interface DDQThemeActivityItem : UICollectionViewCell
/**
 *  整容要多少毛爷爷
 */
@property (strong,nonatomic) UILabel *priceLabel;
/**
 *  模特都是骗人的
 */
@property (strong,nonatomic) UIImageView *beautyImageView;
/**
 *  描述这产品有多好多好
 */
@property (strong,nonatomic) UILabel *descrptionLabel;
/**
 *  我要拿着钱去哪里整
 */
@property (strong,nonatomic) UILabel *hospitalName;

@property (strong,nonatomic) UILabel *oldPriceLabel;

@property (strong,nonatomic) UILabel *hospitalLabel;


@property (strong,nonatomic) zhutiModel *model;

@property ( assign, nonatomic) CGFloat item_height;

@end
