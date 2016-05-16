//
//  DDQOrderCell.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQOrderCell.h"

@interface DDQOrderCell ()

@property ( strong, nonatomic) UIView *background_view;

@property ( strong, nonatomic) UIView *lineOne;
@property ( strong, nonatomic) UIView *lineTwo;
@property ( strong, nonatomic) UIView *lineThree;
@property ( strong, nonatomic) OrderModel *tempModel;
@end


@implementation DDQOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.background_view = [[UIView alloc] init];
        [self.contentView addSubview:self.background_view];
        self.background_view.backgroundColor = [UIColor whiteColor];
        
        self.circle_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.circle_button];
//        [self.circle_button setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected"] forState:UIControlStateNormal];
        [self.circle_button addTarget:self action:@selector(changeCircle:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        self.evaluate_button = [UIButton buttonWithType:0];
        [self.background_view addSubview:self.evaluate_button];
        [self.evaluate_button addTarget:self action:@selector(evaluateMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.evaluate_button setTitle:@" 追加评价 " forState:UIControlStateNormal];
        [self.evaluate_button setTitleColor:[UIColor payColor] forState:UIControlStateNormal];
        [self.evaluate_button setHighlighted:YES];
        self.evaluate_button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.evaluate_button.layer.cornerRadius = 3.0f;
        self.evaluate_button.layer.borderWidth = 0.5f;
        self.evaluate_button.layer.borderColor = [UIColor payColor].CGColor;
        
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

- (void)changeCircle:(UIButton *)button {

    if ([button isSelected] == NO) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected_"] forState:UIControlStateNormal];
        [button setSelected:YES];
        self.tempModel.showSelected = YES;
        
    } else {
    
        [button setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected"] forState:UIControlStateNormal];
        [button setSelected:NO];
        self.tempModel.showSelected = NO;

    }
    
    
}

- (void)evaluateMethod {

    
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

- (void)setModel:(OrderModel *)model {

    self.tempModel = model;
//    [self.circle_button mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.background_view.mas_top).offset(10);
//        make.left.equalTo(self.background_view.mas_left).offset(5);
//        
//    }];
//
//    if (model.showSelected == YES) {
//        
//        [self.circle_button setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected_"] forState:UIControlStateNormal];
//        
//    } else {
//    
//        [self.circle_button setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected"] forState:UIControlStateNormal];
//
//    }
    
    CGRect time_rect = [model.create_time boundStringRect_size:CGSizeMake(kScreenWidth * 0.5, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
//    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.background_view.mas_left).offset(10);
//        make.top.equalTo(self.background_view.mas_top).offset(10);
//        make.width.offset(time_rect.size.width);
//        make.height.offset(time_rect.size.height);
//        
//    }];
//    self.time_label.text = model.create_time;
//    
//    NSString *order = [NSString stringWithFormat:@"订单号:%@",model.orderid];
//    CGRect order_rect = [order boundStringRect_size:CGSizeMake(kScreenWidth - time_rect.size.width - 30, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
//    [self.orderid_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.time_label.mas_right).offset(10);
//        make.centerY.equalTo(self.time_label.mas_centerY);
//        make.width.offset(order_rect.size.width);
//        make.height.offset(order_rect.size.height);
//        
//    }];
//    self.orderid_label.text = order;
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.background_view.mas_left).offset(10);
        make.top.equalTo(self.background_view.mas_top).offset(10);
        make.width.offset(time_rect.size.width);
        make.height.offset(time_rect.size.height);
        
    }];
    self.time_label.text = model.create_time;
    
    NSString *order_str = [NSString stringWithFormat:@"订单号:%@",model.orderid];
    //    CGRect order_rect = [order_str boundStringRect_size:CGSizeMake(kScreenWidth * 0.5 - 30, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.orderid_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    [self.goods_img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineOne.mas_bottom).offset(10);
        make.height.equalTo(self.goods_img.mas_width);
        make.left.equalTo(self.background_view.mas_left).offset(25);
        make.width.offset(kScreenWidth * 0.25);
        
    }];
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:model.simg]];
    
    NSString *title = [NSString stringWithFormat:@"【%@】%@",model.name,model.fname];
    CGRect title_rect = [title boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 - 30 - 10), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.5]}];
    [self.description_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.goods_img.mas_top).offset(3);
        make.left.equalTo(self.goods_img.mas_right).offset(10);
        make.width.offset(title_rect.size.width);
        make.height.offset(title_rect.size.height);

    }];
    self.description_label.text = title;
    
    NSString *hosital = [NSString stringWithFormat:@"%@",model.hname];
    CGRect hospital_rect = [hosital boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 - 30 - 10), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]}];
    [self.hospital_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.description_label.mas_bottom).offset(15);
        make.left.equalTo(self.description_label.mas_left);
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        
    }];
    self.hospital_label.text = hosital;
    
    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-15);
        make.top.equalTo(self.hospital_label.mas_bottom).offset(10);
        
    }];
    self.total_label.text = [NSString stringWithFormat:@"￥:%@元",model.newval];
    
    CGFloat temp_h = title_rect.size.height + hospital_rect.size.height + 25;

    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (temp_h > kScreenWidth * 0.25 + 20) {
            
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
    self.content_label.text = [NSString stringWithFormat:@"总计￥:%@元",model.newval];
    
    [self.lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.content_label.mas_bottom).offset(5);
        make.height.offset(1);
        make.left.equalTo(self.background_view.mas_left);
        make.right.equalTo(self.background_view.mas_right);
        
    }];
    
    [self.evaluate_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.background_view.mas_right).offset(-10);
        make.top.equalTo(self.lineThree.mas_bottom).offset(7);
        make.width.offset(80);
        make.height.offset(25);
        
    }];
    
    if (temp_h > kScreenWidth * 0.25) {
        
        self.cell_h = 10 + 20 + 10 + 10 + temp_h + 15 + 20 + 5 + 45;
        
    } else {
        
        self.cell_h = 10 + 20 + 10 + 10 + kScreenWidth * 0.25 + 15 + 20 + 5 + 45;
        
    }

}
@end

@implementation OrderModel


@end