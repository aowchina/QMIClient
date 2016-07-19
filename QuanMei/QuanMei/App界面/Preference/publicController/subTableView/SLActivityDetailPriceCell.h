//
//  SLActivityDetailPriceCell.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailBaseCell.h"


//貌似价格
@interface SLActivityDetailPriceCell : SLActivityDetailBaseCell

@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *teHuiLabel;
@property (nonatomic, strong) UIButton *OrderButton;
/** 小喇叭 */
@property (nonatomic, strong) UIImageView *trumpetImg;
/** 价格备注 */
@property (nonatomic, strong) UIButton *remarkButton;
/** 用来改变的图片 */
@property (nonatomic, strong) UIImageView *changeImg;
/** 展示价格备注 */
@property (nonatomic, strong) UILabel *showTipLabel;

@end
