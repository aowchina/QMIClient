//
//  DDQQiandaoView.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/2/20.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQQiandaoView.h"
@implementation DDQQiandaoView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor backgroundColor] colorWithAlphaComponent:0.5f];
        
        UIImageView *box_img = [UIImageView new];
        [self addSubview:box_img];
        [box_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.offset(200);
            make.height.equalTo(box_img.mas_width);
        }];
        box_img.image = [UIImage imageNamed:@"框框"];
        box_img.userInteractionEnabled = YES;
        
        /**
         *  显示关闭按钮
         */
        UIButton *closeView = [UIButton new];
        [box_img addSubview:closeView];
        [closeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(box_img.mas_right);
            make.centerY.equalTo(box_img.mas_top);
            make.width.offset(25);
            make.height.offset(25);
        }];
        [closeView setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [closeView addTarget:self action:@selector(removeMethod) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMethod)];
        [self addGestureRecognizer:tap];
        
        /**
         *  签到成功
         */
        UILabel *qiandaochenggong = [UILabel new];
        [box_img addSubview:qiandaochenggong];
        [qiandaochenggong mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(box_img.mas_centerX);
            make.bottom.equalTo(box_img.mas_centerY);
            make.width.equalTo(box_img.mas_width);
            make.height.offset(30);
        }];
        qiandaochenggong.text = @"签到成功";
        qiandaochenggong.textColor = [UIColor whiteColor];
        qiandaochenggong.textAlignment = NSTextAlignmentCenter;
        
        /**
         *  获得积分
         */
        self.huodefenshu = [UILabel new];
        [box_img addSubview:self.huodefenshu];
        [self.huodefenshu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(box_img.mas_centerX);
            make.top.equalTo(box_img.mas_centerY);
            make.width.equalTo(box_img.mas_width);
            make.height.offset(30);
        }];
        self.huodefenshu.textColor = [UIColor whiteColor];
        self.huodefenshu.textAlignment = NSTextAlignmentCenter;
        
        /**
         *  查看button
         */
        UIButton *chakan = [UIButton new];
        [box_img addSubview:chakan];
        [chakan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(box_img.mas_centerX);
            make.top.equalTo(self.huodefenshu.mas_bottom).offset(5);
            make.width.equalTo(box_img.mas_width).multipliedBy(0.5);
            make.height.offset(30);
        }];
        [chakan setBackgroundColor:[UIColor meiHongSe]];
        [chakan setTitle:@"点击查看" forState:UIControlStateNormal];
        chakan.layer.cornerRadius = 5.0f;
        [chakan addTarget:self action:@selector(checkMethod) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  小钱袋
         */
        CGFloat imgW = 60;
        CGFloat imgH = 80;
        UIImageView *qiandai = [UIImageView new];
        [box_img addSubview:qiandai];
        [qiandai mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(qiandaochenggong.mas_top).offset(-5);
            make.centerX.equalTo(box_img.mas_centerX);
            make.height.offset(imgW);
            make.width.offset(imgH);
        }];
        qiandai.image = [UIImage imageNamed:@"钱袋"];
    }
    return self;
}

- (void)removeMethod {

    if (self.delegate && [self.delegate respondsToSelector:@selector(qiandao_view:)]) {
        [self.delegate qiandao_view:self];
    }
}

- (void)checkMethod {

    if (self.delegate && [self.delegate respondsToSelector:@selector(qiandao_viewSelected:)]) {
        [self.delegate qiandao_viewSelected:self];
    }
}



@end
