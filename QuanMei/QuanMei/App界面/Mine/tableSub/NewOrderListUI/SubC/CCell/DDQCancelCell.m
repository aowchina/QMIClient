//
//  DDQCancelCell.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQCancelCell.h"

@interface DDQCancelCell ()

@property ( strong, nonatomic) UIView *background_view;

@property ( strong, nonatomic) UIView *lineOne;
@property ( strong, nonatomic) UIView *lineTwo;
@property ( strong, nonatomic) UIView *lineThree;

@end


@implementation DDQCancelCell

@synthesize time;
@synthesize order;
@synthesize intro;
@synthesize hosipital;
@synthesize price;
@synthesize content;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.background_view = [[UIView alloc] init];
        [self.contentView addSubview:self.background_view];
        self.background_view.backgroundColor = [UIColor whiteColor];
        
        
        self.time_label = [UILabel new];
        [self.background_view addSubview:self.time_label];
        self.time_label.textColor = kTextColor;
        self.time_label.font = [UIFont systemFontOfSize:12.0f];
        
        
        self.orderid_label = [UILabel new];
        [self.background_view addSubview:self.orderid_label];
        self.orderid_label.textColor = kTextColor;
        self.orderid_label.font = [UIFont systemFontOfSize:12.0f];
        
        self.goods_img = [UIImageView new];
        [self.background_view addSubview:self.goods_img];
        self.goods_img.image = [UIImage imageNamed:@"590764_143539221113_2"];
        
        self.description_label = [UILabel new];
        [self.background_view addSubview:self.description_label];
        self.description_label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0f alpha:1.0];
        self.description_label.font = [UIFont systemFontOfSize:15.0f];
        self.description_label.numberOfLines = 0;
        
        self.hospital_label = [UILabel new];
        [self.background_view addSubview:self.hospital_label];
        self.hospital_label.textColor = kTextColor;
        self.hospital_label.font = [UIFont systemFontOfSize:14.0f];
        self.hospital_label.numberOfLines = 0;
        
        self.total_label = [UILabel new];
        [self.background_view addSubview:self.total_label];
        self.total_label.textColor = kTextColor;
        self.total_label.font = [UIFont systemFontOfSize:12.0f];
        
        self.content_label = [UILabel new];
        [self.background_view addSubview:self.content_label];
        self.content_label.textColor = kTextColor;
        self.content_label.font = [UIFont systemFontOfSize:14.0f];
        self.content_label.numberOfLines = 0;
        
        self.cancel_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.cancel_button];
        [self.cancel_button addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.cancel_button setTitle:@" 取消完成 " forState:UIControlStateNormal];
        [self.cancel_button setTitleColor:[UIColor payColor] forState:UIControlStateNormal];
        [self.cancel_button setHighlighted:YES];
        self.cancel_button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.cancel_button.layer.cornerRadius = 3.0f;
        self.cancel_button.layer.borderWidth = 0.5f;
        self.cancel_button.layer.borderColor = [UIColor payColor].CGColor;
        
        self.lineThree = [[UIView alloc] init];
        [self.background_view addSubview:self.lineThree];
        self.lineThree.backgroundColor = [UIColor backgroundColor];
        
        self.lineOne = [[UIView alloc] init];
        [self.background_view addSubview:self.lineOne];
        self.lineOne.backgroundColor = [UIColor backgroundColor];
        
        self.lineTwo = [[UIView alloc] init];
        [self.background_view addSubview:self.lineTwo];
        self.lineTwo.backgroundColor = [UIColor backgroundColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
    }
    
    return self;

}

- (void)cancelMethod {

    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self.background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        
    }];
    
    CGRect time_rect = [self.time boundStringRect_size:CGSizeMake(kScreenWidth, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.background_view.mas_left).offset(10);
        make.top.equalTo(self.background_view.mas_top).offset(10);
        make.width.offset(time_rect.size.width);
        make.height.offset(time_rect.size.height);
        
    }];
    self.time_label.text = self.time;
    
    CGRect order_rect = [self.order boundStringRect_size:CGSizeMake(kScreenWidth - time_rect.size.width - 30, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.orderid_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.time_label.mas_right).offset(10);
        make.centerY.equalTo(self.time_label.mas_centerY);
        make.width.offset(order_rect.size.width);
        make.height.offset(order_rect.size.height);
        
    }];
    self.orderid_label.text = self.order;
    
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderid_label.mas_bottom).offset(10);
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    [self.goods_img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineOne.mas_bottom).offset(10);
        make.height.equalTo(self.goods_img.mas_width);
        make.left.equalTo(self.background_view.mas_left).offset(25);
        make.width.offset(kScreenWidth * 0.25);
        
    }];
    
    [self.description_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.goods_img.mas_top).offset(3);
        make.left.equalTo(self.goods_img.mas_right).offset(10);
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        
    }];
    self.description_label.text = self.intro;
    
    [self.hospital_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.description_label.mas_bottom).offset(15);
        make.left.equalTo(self.description_label.mas_left);
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        
    }];
    self.hospital_label.text = self.hosipital;
    
    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-15);
        make.top.equalTo(self.hospital_label.mas_bottom).offset(10);
        
    }];
    self.total_label.text = self.price;
    
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.total_label.mas_bottom).offset(10);
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    CGRect rect = [self.content boundStringRect_size:CGSizeMake(kScreenWidth - 50, 10) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineTwo.mas_bottom).offset(5);
        make.centerX.equalTo(self.lineTwo.mas_centerX);
        make.width.offset(rect.size.width);
        make.height.offset(rect.size.height);
        
    }];
    self.content_label.text = self.content;
    
    [self.lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.content_label.mas_bottom).offset(5);
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    [self.cancel_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.top.equalTo(self.lineThree.mas_bottom).offset(7);
        make.width.offset(80);
        make.height.offset(25);
        
    }];
    
    CGRect d_rect = [self.intro boundingRectWithSize:CGSizeMake(kScreenWidth - 25 - kScreenWidth*0.25 - 25, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.5f]} context:nil];
    CGRect h_rect = [self.hosipital boundingRectWithSize:CGSizeMake(kScreenWidth - 25 - kScreenWidth*0.25 - 25, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5f]} context:nil];
    CGFloat temp_h = d_rect.size.height + h_rect.size.height + 25 + rect.size.height;
    if (temp_h > kScreenWidth * 0.25) {
        
        self.cell_h = 10 + 20 + 10 + 10 + temp_h + 15 + 20 + 5 + 65;
        
    } else {
        
        self.cell_h = 10 + 20 + 10 + 10 + kScreenWidth * 0.25 + 15 + rect.size.height + 5 + 65;
        
    }
    
}

@end
