//
//  SLActivityDetailPriceCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailPriceCell.h"
#import "SLActivityModel.h"

#define SLDescLabelFontSize 17.f
#define SLSpace 80.f
#define SLDescLabelMagin 6.f

@interface SLActivityDetailPriceCell ()


@end
@implementation SLActivityDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubView];
    }
    return self;
}
#pragma mark - builder SubView
- (void)buildSubView {
    //价格
    self.priceLabel = [[UILabel alloc] init];
    
    self.priceLabel.textColor = [UIColor meiHongSe];
    
    _priceLabel.font = [UIFont systemFontOfSize:18];
    
    [self.contentView addSubview:self.priceLabel];
    
    //teHuiLabel
    self.teHuiLabel = [[UILabel alloc] init];

    _teHuiLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:self.teHuiLabel];
    
    
    //oldPriceLabel
    self.oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.5];
    [self.contentView addSubview:self.oldPriceLabel];
    
    //OrderButton
    self.OrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OrderButton.backgroundColor = [UIColor colorWithRed:134.0/255 green:220.0/255 blue:213.0/255 alpha:1];
    
    _OrderButton.layer.cornerRadius = 5;
    
    _OrderButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:self.OrderButton];
    [self.OrderButton addTarget:self action:@selector(handleButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        
    }];
    [self.teHuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        
    }];
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_left);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        
    }];

    [self.OrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.offset(100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.offset(40);
    }];
    
}
#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];
    //
    self.teHuiLabel.text = @"全美特惠价";
    
    
    //新价格.名字,旧价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元",activity.newval];
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@元",activity.oldval] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];

   self.oldPriceLabel.attributedText = attributedString;

    [self.OrderButton setTitle:[NSString stringWithFormat:@"预订(定金%@)",activity.dj] forState:(UIControlStateNormal)];
}
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    //
    CGFloat height = SLDescLabelMagin * 2 + 65.f;
    return height;
}

#pragma mark - buttonAction
- (void)handleButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityDetailBaseCell:didSelectedID:)]) {
        [self.delegate activityDetailBaseCell:self didSelectedID:self.activity.dj];
    }
}


@end
