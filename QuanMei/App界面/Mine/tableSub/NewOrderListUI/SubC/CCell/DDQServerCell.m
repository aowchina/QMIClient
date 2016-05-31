//
//  DDQServerCell.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQServerCell.h"

@interface DDQServerCell ()

@property ( strong, nonatomic) UIView *background_view;
/**
 *  subviews
 */
@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *cancel_button;

/**
 *  这个订单现在的状态
 */
@property ( strong, nonatomic) UIButton *state_button;

@property ( strong, nonatomic) UIView *lineOne;
@property ( strong, nonatomic) UIView *lineTwo;
@property ( strong, nonatomic) UIView *lineThree;

@property ( strong, nonatomic) DDQPayModel *temp_model;
@end

@implementation DDQServerCell

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
        self.description_label.font = [UIFont systemFontOfSize:15.0f weight:1.0f];
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
        self.content_label.textColor = [UIColor meiHongSe];
        self.content_label.font = [UIFont systemFontOfSize:14.0f];
        
        self.cancel_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.cancel_button];
        [self.cancel_button addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.cancel_button setTitle:@" 退 款 " forState:UIControlStateNormal];
        [self.cancel_button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
        [self.cancel_button setHighlighted:YES];
        self.cancel_button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.cancel_button.layer.cornerRadius = 3.0f;
        self.cancel_button.layer.borderWidth = 0.5f;
        self.cancel_button.layer.borderColor = [UIColor meiHongSe].CGColor;
        
        self.state_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.state_button];
//        self.state_label.text = @" 已 支 付 ";
//        self.state_button.font = [UIFont systemFontOfSize:15.0f];
//        self.state_label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0f blue:153.0/255.0 alpha:1.0f];
//        self.state_label.textColor = [UIColor meiHongSe];
//        self.state_label.textAlignment = NSTextAlignmentCenter;
        self.state_button.layer.cornerRadius = 3.0f;
        self.state_button.layer.borderWidth = 0.5f;
//        self.state_label.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0f blue:153.0/255.0 alpha:1.0f].CGColor;
        self.state_button.layer.borderColor = [UIColor meiHongSe].CGColor;
        [self.state_button setTitle:@"  追加尾款  " forState:UIControlStateNormal];
        [self.state_button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
        self.state_button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.state_button addTarget:self action:@selector(addManey) forControlEvents:UIControlEventTouchUpInside];
        
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(serverCell_cancelButtonSelectedMethod:Model:)]) {
        
        [self.delegate serverCell_cancelButtonSelectedMethod:self Model:self.temp_model];
        
    }
    
}

- (void)addManey {

    if (self.delegate && [self.delegate respondsToSelector:@selector(serverCell_addManeyButtonSelectedMethod:Model:)]) {
        
        [self.delegate serverCell_addManeyButtonSelectedMethod:self Model:self.temp_model];
        
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

- (CGFloat)heightForCellWithModel:(DDQPayModel *)pay_model {
    
    CGFloat height = 0.0;
    
    self.temp_model = pay_model;
    
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
        make.width.offset(name_rect.size.width);
        make.height.offset(name_rect.size.height);
        
    }];
    self.description_label.text = name_str;
    
    CGRect hospital_rect = [pay_model.hname boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 + 30), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5f]}];
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
    self.total_label.text = [NSString stringWithFormat:@"￥:%.2f元",[pay_model.newval floatValue]];
    
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

    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.top.equalTo(self.lineTwo.mas_bottom).offset(5);
        
    }];
    
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
        make.height.offset(30);
        
    }];
    
    [self.state_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.cancel_button.mas_left).offset(-10);
        make.height.equalTo(self.cancel_button.mas_height);
        make.width.equalTo(self.cancel_button.mas_width);
        make.centerY.equalTo(self.cancel_button.mas_centerY);
        
    }];
    if ([pay_model.status intValue] == 2) {
        
        self.content_label.text = @"定金支付";
        [self.state_button setHidden:NO];
        
    } else {
    
        self.content_label.text = @"全款支付";
        [self.state_button setHidden:YES];
        
    }
    
    if (temp_h > kScreenWidth * 0.25) {
        
        height = 10 + 20 + 10 + 10 + temp_h + 15 + 20 + 5 + 45;
        
    } else {
        
        height = 10 + 20 + 10 + 10 + kScreenWidth * 0.25 + 15 + 20 + 5 + 45;
        
    }
    return height;
    
}

@end
