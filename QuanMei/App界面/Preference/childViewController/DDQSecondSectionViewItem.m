//
//  DDQSecondSectionViewItem.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSecondSectionViewItem.h"

@implementation DDQSecondSectionViewItem

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.picImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.contentView.mas_left).with.offset(5);
            make.width.equalTo(self.contentView.mas_width).with.multipliedBy(0.5);
        }];
        [self.picImageView.layer setCornerRadius:5.0f];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.frame = CGRectMake(kScreenWidth * 0.28, kScreenHeight * 0.04, kScreenWidth * 0.2, kScreenHeight*0.05);
        [self.contentView addSubview:self.titleLabel];
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.picImageView.mas_centerX);
//            make.left.equalTo(self.picImageView.mas_right).with.offset(10);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
//            make.height.equalTo(self.picImageView.mas_height).with.multipliedBy(0.15);
//        }];
        
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.frame = CGRectMake(kScreenWidth * 0.28, kScreenHeight * 0.09, kScreenWidth * 0.2, kScreenHeight*0.05);
        [self.contentView addSubview:self.descriptionLabel];
//        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self.titleLabel.mas_width);
//            make.height.equalTo(self.titleLabel.mas_height);
//            make.top.equalTo(self.picImageView.mas_centerX);
//            make.left.equalTo(self.picImageView.mas_right).with.offset(10);
//        }];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textColor = [UIColor colorWithRed:218/255.0 green:115/255.0 blue:226/255.0 alpha:1];
        self.descriptionLabel.font = [UIFont systemFontOfSize:8];
        self.descriptionLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:149/255.0 alpha:1];
//        [self.picImageView setBackgroundColor:[UIColor redColor]];
//        [self.titleLabel setBackgroundColor:[UIColor greenColor]];
//        [self.descriptionLabel setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}
-(void)setModel:(ListModel *)model
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.act_list_simg]]];
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.act_list_name];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.act_list_ffname];
}

//-(void)setModel:(TypesModel *)model
//{
//    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.act_list_simg]]];
//    
//    
//    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.act_list_name];
//    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.act_list_ffname];
//}

@end
