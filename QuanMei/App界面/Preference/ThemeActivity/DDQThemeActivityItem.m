//
//  DDQThemeActivityItem.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQThemeActivityItem.h"

@implementation DDQThemeActivityItem
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //产品图片
        self.beautyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.beautyImageView];
        [self.beautyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.equalTo(self.beautyImageView.mas_width);
        }];
        
        
        self.priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.beautyImageView.mas_bottom);
        }];
        
        self.oldPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.oldPriceLabel];
        [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
            make.bottom.equalTo(self.priceLabel.mas_bottom);
            
        }];

        self.descrptionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.descrptionLabel];
        [self.descrptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
            
        }];
        
        self.hospitalLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.hospitalLabel];
        [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.descrptionLabel.mas_bottom);

        }];
       
    }
    return self;
}
-(void)setModel:(zhutiModel *)model
{
    [self.beautyImageView sd_setImageWithURL:[NSURL URLWithString:model.simg]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.newval];
    
    self.priceLabel.font = [UIFont systemFontOfSize:15.0f weight:0.0f];
    self.priceLabel.textColor = [UIColor orangeColor];
    
    NSString *str = [NSString stringWithFormat:@"￥%@",model.oldval];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:str attributes:@{ NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0]}];
    self.oldPriceLabel.attributedText = string;
   
    NSString *descrption = [NSString stringWithFormat:@"【%@】%@",model.fname,model.name];
//    CGRect rect = [descrption boundingRectWithSize:CGSizeMake(kScreenWidth * 0.45, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:1.5f]} context:nil];
    [self.descrptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(30);
        
    }];
    self.descrptionLabel.text = descrption;
    self.descrptionLabel.font = [UIFont systemFontOfSize:15.0f weight:1.0f];
    self.descrptionLabel.numberOfLines = 0;
    
//    NSString *hospital = model.hname;
//    CGRect hospital_rect = [hospital boundingRectWithSize:CGSizeMake(kScreenWidth * 0.45-5, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f weight:1.5f]} context:nil];
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(30);
        
    }];
    self.hospitalLabel.text = model.hname;
    self.hospitalLabel.font = [UIFont systemFontOfSize:13.0f];
    self.hospitalLabel.numberOfLines = 0;
    
    self.item_height = (kScreenWidth*0.45 - 10) + 5 + 20 + 5 + 35 + 5 + 35 + 10;

}
@end
