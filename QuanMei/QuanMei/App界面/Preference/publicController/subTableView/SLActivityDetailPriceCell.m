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

/** 第一条细线 */
@property (nonatomic, strong) UIView *lineOne;
/** 第二条细线 */
@property (nonatomic, strong) UIView *lineTwo;
/** 用来显示收起，展开的 */
@property (nonatomic, strong) UILabel *tipLabel;

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
    
    //标题
    self.title_label = [[UILabel alloc] init];
    self.title_label.font = [UIFont systemFontOfSize:16.0];
    self.title_label.textAlignment = NSTextAlignmentLeft;
    self.title_label.numberOfLines = 0;
    [self.contentView addSubview:self.title_label];

    //价格
    self.priceLabel = [[UILabel alloc] init];
    
    self.priceLabel.textColor = [UIColor meiHongSe];
    
    _priceLabel.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:self.priceLabel];
    
    //teHuiLabel
    self.teHuiLabel = [[UILabel alloc] init];
    _teHuiLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:self.teHuiLabel];
    
    
    //oldPriceLabel
    self.oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.5];
    self.oldPriceLabel.font = [UIFont systemFontOfSize:12.0];

    [self.contentView addSubview:self.oldPriceLabel];
    
    //OrderButton
    self.OrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OrderButton.backgroundColor = [UIColor colorWithRed:134.0/255 green:220.0/255 blue:213.0/255 alpha:1];
    
    _OrderButton.layer.cornerRadius = 5;
    
    _OrderButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:self.OrderButton];
    [self.OrderButton addTarget:self action:@selector(handleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //下喇叭图片
    self.trumpetImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.trumpetImg];
    
    self.trumpetImg.image = [UIImage imageNamed:@"Volume-2"];
    
    //一条小虚线
    self.lineOne = [[UIView alloc] init];
    [self.contentView addSubview:self.lineOne];
    
    self.lineOne.backgroundColor = [UIColor backgroundColor];
    
    //价格提示
    self.remarkButton = [UIButton buttonWithType:0];
    [self.contentView addSubview:self.remarkButton];
    
    self.remarkButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.remarkButton setTitle:@"价格备注" forState:UIControlStateNormal];
    [self.remarkButton setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
    [self.remarkButton addTarget:self action:@selector(showTip) forControlEvents:UIControlEventTouchUpInside];
    
    //向下的小箭头
    self.changeImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.changeImg];
    
    self.changeImg.image = [UIImage imageNamed:@"图层-4"];
    
    //价格备注
    self.showTipLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.showTipLabel];
    
    self.showTipLabel.font = [UIFont systemFontOfSize:14.0];
    self.showTipLabel.textColor = kTextColor;
    self.showTipLabel.numberOfLines = 0;
    
    //第二条细线
    self.lineTwo = [[UIView alloc] init];
    [self.contentView addSubview:self.lineTwo];
    
    self.lineTwo.backgroundColor = [UIColor backgroundColor];
    
    //收起展开
    self.tipLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLabel];
    
    self.tipLabel.textColor = kTextColor;
    self.tipLabel.font = [UIFont systemFontOfSize:12.0];
    self.tipLabel.text = @"展开";
    
}

/*
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.top.equalTo(self.title_label.mas_bottom).offset(8);
        
    }];
    
    [self.teHuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_left);
        make.top.equalTo(self.priceLabel.mas_bottom);
        
    }];

    [self.OrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.equalTo(self.oldPriceLabel.mas_bottom);
        make.height.mas_equalTo(35.0);
        
    }];
    
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.oldPriceLabel.mas_bottom).offset(12.5);
        make.height.mas_equalTo(1.0);
        make.right.equalTo(self.contentView.mas_right);
        
    }];
    
    [self.trumpetImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20.0);
        make.top.equalTo(self.lineOne.mas_bottom).offset(5.0);
        
    }];
    
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.left.equalTo(self.trumpetImg.mas_right).offset(5.0);
        
    }];
    
    [self.changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.left.equalTo(self.remarkButton.mas_right).offset(5.0);
        
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.trumpetImg.mas_bottom).offset(5.0);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1.0);
        
    }];
    
    [self.showTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.lineTwo.mas_bottom).offset(5);
        
    }];
    
}
*/
#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    
    [super reloadWithActivityModel:activity];
    
    self.teHuiLabel.text = @"全美特惠价";
    
    if (activity.fname == nil) {
        
        activity.fname = @"";
        
    }
    
    if (activity.name == nil) {
        
        activity.name = @"";
        
    }
    
    NSString *title = [NSString stringWithFormat:@"【%@】%@", activity.fname, activity.name];
    CGRect titleRect = [title boundStringRect_size:CGSizeMake(kScreenWidth - 20, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.5]}];
    self.title_label.text = title;

    //新价格.名字,旧价格
    if (activity.newval == nil) {
        
        activity.newval = @"";
        
    }
    NSMutableAttributedString *mutedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@元",activity.newval]];
    [mutedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor meiHongSe]} range:NSMakeRange(0, 1)];
    [mutedString setAttributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe], NSFontAttributeName:[UIFont systemFontOfSize:17.5 weight:0.2], NSKernAttributeName:@(-1)} range:NSMakeRange(1, mutedString.string.length - 1)];
    
    self.priceLabel.attributedText = mutedString;

    if (activity.oldval == nil) {
        
        activity.oldval = @"";
        
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@元",activity.oldval] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle), NSKernAttributeName:@(-1), NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];

    self.oldPriceLabel.attributedText = attributedString;

    if (activity.dj == nil) {
        
        activity.dj = @"";
        
    }
    
    [self.OrderButton setTitle:[NSString stringWithFormat:@"  预订(定金%@)  ",activity.dj] forState:(UIControlStateNormal)];
    
    CGRect desRect = [activity.val_desc boundStringRect_size:CGSizeMake(kScreenWidth - 20, 10000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]}];
    
    if (activity.isClicked == NO) {
        
        self.showTipLabel.hidden = YES;
        self.tipLabel.text = @"展开";
        
    } else {
    
        self.showTipLabel.hidden = NO;
        self.showTipLabel.text = activity.val_desc;
        self.tipLabel.text = @"收起";

    }
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(8.0);
        make.width.mas_equalTo(titleRect.size.width);
        make.height.mas_equalTo(titleRect.size.height);
        
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.top.equalTo(self.title_label.mas_bottom).offset(8);
        
    }];
    
    [self.teHuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLabel.mas_left);
        make.top.equalTo(self.priceLabel.mas_bottom);
        
    }];
    
    [self.OrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.equalTo(self.oldPriceLabel.mas_bottom);
        make.height.mas_equalTo(35.0);
        
    }];
    
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.oldPriceLabel.mas_bottom).offset(12.5);
        make.height.mas_equalTo(1.0);
        make.right.equalTo(self.contentView.mas_right);
        
    }];
    
    [self.trumpetImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20.0);
        make.top.equalTo(self.lineOne.mas_bottom).offset(5.0);
        
    }];
    
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.left.equalTo(self.trumpetImg.mas_right).offset(5.0);
        
    }];
    
    [self.changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.left.equalTo(self.remarkButton.mas_right).offset(5.0);
        
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.trumpetImg.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.trumpetImg.mas_bottom).offset(5.0);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1.0);
        
    }];
    
    [self.showTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.lineTwo.mas_bottom).offset(5);
        make.width.mas_equalTo(desRect.size.width);
        make.height.mas_equalTo(desRect.size.height);
        
    }];

}

+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    
    //重新计算cell高
    NSString *title = [NSString stringWithFormat:@"【%@】%@", activity.fname, activity.name];
    CGRect titleRect = [title boundStringRect_size:CGSizeMake(kScreenWidth - 20, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.5]}];
    
    CGFloat height = 0.0;
    if (activity.isClicked == NO) {
        
        height = SLDescLabelMagin * 2 + 75.5 + titleRect.size.height;
        return height;

    } else {
    
        NSString *tempString = activity.val_desc;
        CGRect rect = [tempString boundStringRect_size:CGSizeMake(kScreenWidth - 20, 10000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]}];
        
        height = SLDescLabelMagin * 2 + 80.5 + titleRect.size.height + rect.size.height;
        
        return height;
        
    }
    
}

#pragma mark - buttonAction
- (void)handleButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityDetailBaseCell:didSelectedID:)]) {
        [self.delegate activityDetailBaseCell:self didSelectedID:self.activity.dj];
    }
}

- (void)showTip {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRemakeButtonInCell:)]) {
        
        [self.delegate didSelectedRemakeButtonInCell:self];
        
    }
    
}

@end
