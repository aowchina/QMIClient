//
//  DDQFirstSectionViewItem.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQFirstSectionViewItem.h"

@implementation DDQFirstSectionViewItem
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@70);
        }];
        [view.layer setCornerRadius:35.0f];
        [view.layer setBorderWidth:1.0f];
        [view.layer setBorderColor:[UIColor colorWithRed:229/255.0 green:136/255.0 blue:160/255.0 alpha:1].CGColor];
        
        self.positionLabel = [[UILabel alloc] init];
        self.positionLabel.font = [UIFont boldSystemFontOfSize:12];
        self.positionLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.positionLabel];
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
            make.width.equalTo(view.mas_width).with.multipliedBy(0.8);
            make.height.equalTo(view.mas_height).with.multipliedBy(0.5);
        }];
        [self.positionLabel setTextColor:[UIColor colorWithRed:233/255.0 green:72/255.0 blue:117/255.0 alpha:1]];
    } 
    return self;
}
-(void)setModel:(TypesModel *)model
{
//    self.positionLabel.text = [NSString stringWithFormat:@"%@",model.name];

}

//-(void)setModel:(TypesModel *)model
//{
//    self.positionLabel.text = [NSString stringWithFormat:@"%@",model.name];
//}

@end
