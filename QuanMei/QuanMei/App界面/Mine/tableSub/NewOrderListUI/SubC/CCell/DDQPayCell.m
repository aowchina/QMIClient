//
//  DDQPayCell.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQPayCell.h"

@interface DDQPayCell ()

@property ( strong, nonatomic) UIView *background_view;

@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
//@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *pay_button;
@property ( strong, nonatomic) UIButton *cancel_button;

@property ( strong, nonatomic) UIView *lineOne;
@property ( strong, nonatomic) UIView *lineTwo;
//@property ( strong, nonatomic) UIView *lineThree;

@end

@implementation DDQPayCell

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
        self.orderid_label.textAlignment = NSTextAlignmentLeft;

        self.goods_img = [UIImageView new];
        [self.background_view addSubview:self.goods_img];
        
        self.description_label = [UILabel new];
        [self.background_view addSubview:self.description_label];
        self.description_label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0f alpha:1.0];
        self.description_label.font = [UIFont systemFontOfSize:15.0f weight:1.0];
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
        
//        self.content_label = [UILabel new];
//        [self.background_view addSubview:self.content_label];
//        self.content_label.textColor = kTextColor;
//        self.content_label.font = [UIFont systemFontOfSize:14.0f];
        
        self.pay_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.pay_button];
        [self.pay_button addTarget:self action:@selector(payMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.pay_button setTitle:@"  去 支 付  " forState:UIControlStateNormal];
        [self.pay_button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
        [self.pay_button setHighlighted:YES];
        self.pay_button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.pay_button.layer.cornerRadius = 3.0f;
        self.pay_button.layer.borderWidth = 0.5f;
        self.pay_button.layer.borderColor = [UIColor meiHongSe].CGColor;
        
        self.cancel_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.cancel_button];
        [self.cancel_button addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.cancel_button setTitle:@"  删 除  " forState:UIControlStateNormal];
        [self.cancel_button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
        [self.cancel_button setHighlighted:YES];
        self.cancel_button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.cancel_button.layer.cornerRadius = 3.0f;
        self.cancel_button.layer.borderWidth = 0.5f;
        self.cancel_button.layer.borderColor = [UIColor meiHongSe].CGColor;
        
//        self.lineThree = [[UIView alloc] init];
//        [self.background_view addSubview:self.lineThree];
//        self.lineThree.backgroundColor = [UIColor backgroundColor];

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

- (void)payMethod {

    if (self.delegate && [self.delegate respondsToSelector:@selector(paybutton_selectedMethod:Model:)]) {
        
        [self.delegate paybutton_selectedMethod:self Model:self.pay_model];
        
    }
    
}

- (void)cancelMethod {

    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelbutton_selectedMethod:Model:)]) {
        
        [self.delegate cancelbutton_selectedMethod:self Model:self.pay_model];
        
    }
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self.background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        
    }];
    
}

- (void)setPay_model:(DDQPayModel *)pay_model {

    _pay_model = pay_model;
    //第一行
    CGRect time_rect = [pay_model.create_time boundStringRect_size:CGSizeMake(kScreenWidth * 0.5, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.time_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.background_view.mas_left).offset(10);
        make.top.equalTo(self.background_view.mas_top).offset(10);
        make.width.offset(time_rect.size.width);
        make.height.offset(time_rect.size.height);
        
    }];
    self.time_label.text = pay_model.create_time;
    
    NSString *order_str = [NSString stringWithFormat:@"订单号:%@",pay_model.orderid];
    [self.orderid_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.time_label.mas_right).offset(10);
        make.centerY.equalTo(self.time_label.mas_centerY);
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.height.equalTo(self.time_label.mas_height);
        
    }];
    self.orderid_label.text = order_str;

    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderid_label.mas_bottom).offset(10);
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    //第二行
    [self.goods_img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineOne.mas_bottom).offset(10);
        make.height.equalTo(self.goods_img.mas_width);
        make.left.equalTo(self.background_view.mas_left).offset(25);
        make.width.offset(kScreenWidth * 0.25);
        
    }];
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:pay_model.simg]];
    
    NSString *name_str = [NSString stringWithFormat:@"【%@】%@",pay_model.name,pay_model.fname];
    CGRect name_rect = [name_str boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 + 30), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.5f weight:1.5f]}];
    [self.description_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.goods_img.mas_top).offset(3);
        make.left.equalTo(self.goods_img.mas_right).offset(10);
        make.width.mas_equalTo(name_rect.size.width);
        make.height.mas_equalTo(name_rect.size.height);
        
    }];
    self.description_label.text = name_str;

    CGRect hospital_rect = [pay_model.hname boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 + 40), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5f]}];
    [self.hospital_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.description_label.mas_bottom).offset(15);
        make.left.equalTo(self.description_label.mas_left);
        make.width.offset(hospital_rect.size.width);
        make.height.offset(hospital_rect.size.height);
        
    }];
    self.hospital_label.text = pay_model.hname;
    
    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.top.equalTo(self.hospital_label.mas_bottom).offset(10);

    }];
    self.total_label.text = [NSString stringWithFormat:@"￥:%@元",pay_model.newval];
    
    CGFloat temp_h = name_rect.size.height + hospital_rect.size.height + 25 + 20;
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (temp_h > kScreenWidth * 0.25) {
            
            make.top.equalTo(self.total_label.mas_bottom).offset(10);

        } else {
        
            make.top.equalTo(self.goods_img.mas_bottom).offset(10);

        }
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    [self.pay_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.top.equalTo(self.lineTwo.mas_bottom).offset(7);
        make.width.offset(80);
        make.height.offset(30);
        
    }];

    [self.cancel_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.pay_button.mas_left).offset(-10);
        make.centerY.equalTo(self.pay_button.mas_centerY);
        make.height.equalTo(self.pay_button.mas_height);
        make.width.equalTo(self.pay_button.mas_width);
        
    }];

    
    if (temp_h > kScreenWidth * 0.25) {

        self.cell_h = 10 + 20 + 10 + 10 + temp_h + 15 + 20 + 5 + 20;

    } else {

        self.cell_h = 10 + 20 + 10 + 10 + kScreenWidth * 0.25 + 15 + 20 + 5 + 20;
        
    }

}

@end
