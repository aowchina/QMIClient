//
//  DDQNewOrderDetailView.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQNewOrderDetailView.h"

@interface DDQNewOrderDetailView ()

@property ( strong, nonatomic) UIScrollView *top_scroll;
@property ( strong, nonatomic) UIView *bottom_view;

@property ( strong, nonatomic) UIView *white_view_one;
@property ( strong, nonatomic) UIView *white_view_two;
@property ( strong, nonatomic) UIView *white_view_three;
@property ( strong, nonatomic) UIView *white_view_four;
@property ( strong, nonatomic) UIView *white_view_five;

@property ( strong, nonatomic) UIImageView *goods_img;
@property ( strong, nonatomic) UILabel *goods_intro;
@property ( strong, nonatomic) UILabel *hosiptal_name;
@property ( strong, nonatomic) UILabel *total_price;

@property ( strong, nonatomic) UILabel *fuKuan;
@property ( strong, nonatomic) UILabel *fukuanLeiXing;
@property ( strong, nonatomic) UILabel *fuKuanJinE;
@property ( strong, nonatomic) UILabel *yingFuKuanJinE;

@property ( strong, nonatomic) UILabel *jiFen;
@property ( strong, nonatomic) UILabel *jiFenFanDian;

@property ( strong, nonatomic) UILabel *orderid;
@property ( strong, nonatomic) UILabel *id_number;
@property ( strong, nonatomic) UILabel *ordertime;
@property ( strong, nonatomic) UILabel *how_time;
@property ( strong, nonatomic) UILabel *ordercontact;
@property ( strong, nonatomic) UILabel *contactWay;

@property ( strong, nonatomic) UIImageView *small_tel;
@property ( strong, nonatomic) UIButton *call_tel;
@property ( strong, nonatomic) UIView *line_view;
@property ( strong, nonatomic) UIImageView *small_QRcode;
@property ( strong, nonatomic) UIButton *show_QRcode;

@property ( strong, nonatomic) UIButton *pay_button;

@property ( strong, nonatomic) DDQNewOrderDetailModel *detail_model;

@end

@implementation DDQNewOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.top_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.top_scroll];
        self.top_scroll.backgroundColor = [UIColor backgroundColor];
        
        /**
         *  布局白色的载体View
         */
        [self addWhiteContainer];
        
    }
    
    return self;
    
}

- (void)addWhiteContainer {

    self.white_view_one = [[UIView alloc] init];
    [self.top_scroll addSubview:self.white_view_one];
    self.white_view_one.backgroundColor = [UIColor whiteColor];
    [self addSubviewToWhiteViewOne];
    
    self.white_view_two = [[UIView alloc] init];
    [self.top_scroll addSubview:self.white_view_two];
    self.white_view_two.backgroundColor = [UIColor whiteColor];
    [self addSubviewToWhiteViewTwo];
    
    self.white_view_three = [[UIView alloc] init];
    [self.top_scroll addSubview:self.white_view_three];
    self.white_view_three.backgroundColor = [UIColor whiteColor];
    [self addSubviewToWhiteViewThree];
    
    self.white_view_four = [[UIView alloc] init];
    [self.top_scroll addSubview:self.white_view_four];
    self.white_view_four.backgroundColor = [UIColor whiteColor];
    [self addSubviewToWhiteViewFour];
    
    self.white_view_five = [[UIView alloc] init];
    [self.top_scroll addSubview:self.white_view_five];
    self.white_view_five.backgroundColor = [UIColor whiteColor];
    [self addSubviewToWhiteViewFive];
    
}

- (void)addSubviewToWhiteViewOne {

    self.goods_img = [[UIImageView alloc] init];
    [self.white_view_one addSubview:self.goods_img];
    
    self.goods_intro = [[UILabel alloc] init];
    [self.white_view_one addSubview:self.goods_intro];
    self.goods_intro.textColor = [UIColor blackColor];
    self.goods_intro.font = [UIFont systemFontOfSize:18.0f];
    self.goods_intro.numberOfLines = 0;
    
    self.hosiptal_name = [[UILabel alloc] init];
    [self.white_view_one addSubview:self.hosiptal_name];
    self.hosiptal_name.textColor = kTextColor;
    self.hosiptal_name.font = [UIFont systemFontOfSize:16.0f];
    self.hosiptal_name.numberOfLines = 0;
    
    self.total_price = [[UILabel alloc] init];
    [self.white_view_one addSubview:self.total_price];
    self.total_price.textColor = kTextColor;
    self.total_price.font = [UIFont systemFontOfSize:16.0f];
    
}

- (void)addSubviewToWhiteViewTwo {

    self.fuKuan = [[UILabel alloc] init];
    [self.white_view_two addSubview:self.fuKuan];
    self.fuKuan.font = [UIFont systemFontOfSize:18.0f];
    self.fuKuan.textColor = kTextColor;
    self.fuKuan.text = @"定金支付";

    self.fuKuanJinE = [[UILabel alloc] init];
    [self.white_view_two addSubview:self.fuKuanJinE];
    self.fuKuanJinE.font = [UIFont systemFontOfSize:18.0f];
    self.fuKuanJinE.textColor = kTextColor;
    
    self.fukuanLeiXing = [[UILabel alloc] init];
    [self.white_view_two addSubview:self.fukuanLeiXing];
    self.fukuanLeiXing.font = [UIFont systemFontOfSize:18.0f];
    self.fukuanLeiXing.textColor = kTextColor;
    
    self.yingFuKuanJinE = [[UILabel alloc] init];
    [self.white_view_two addSubview:self.yingFuKuanJinE];
    self.yingFuKuanJinE.font = [UIFont systemFontOfSize:18.0f];
    self.yingFuKuanJinE.textColor = [UIColor meiHongSe];
    
}

- (void)addSubviewToWhiteViewThree {

    self.jiFen = [[UILabel alloc] init];
    [self.white_view_three addSubview:self.jiFen];
    self.jiFen.textColor = [UIColor whiteColor];
    self.jiFen.font = [UIFont systemFontOfSize:13.5f];
    self.jiFen.text = @" 积分 ";
    self.jiFen.backgroundColor = [UIColor meiHongSe];
    
    self.jiFenFanDian = [[UILabel alloc] init];
    [self.white_view_three addSubview:self.jiFenFanDian];
    self.jiFenFanDian.textColor = [UIColor blackColor];
    self.jiFenFanDian.font = [UIFont systemFontOfSize:13.5f];
    
}

- (void)addSubviewToWhiteViewFour {

    self.orderid = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.orderid];
    self.orderid.textColor = kTextColor;
    self.orderid.font = [UIFont systemFontOfSize:18.0f];
    self.orderid.text = @"订单号:";

    self.id_number = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.id_number];
    self.id_number.textColor = kTextColor;
    self.id_number.font = [UIFont systemFontOfSize:18.0f];
    
    self.ordertime = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.ordertime];
    self.ordertime.textColor = kTextColor;
    self.ordertime.font = [UIFont systemFontOfSize:18.0f];
    self.ordertime.text = @"下单时间:";
    
    self.how_time = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.how_time];
    self.how_time.textColor = kTextColor;
    self.how_time.font = [UIFont systemFontOfSize:18.0f];
    
    self.ordercontact = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.ordercontact];
    self.ordercontact.textColor = kTextColor;
    self.ordercontact.font = [UIFont systemFontOfSize:18.0f];
    self.ordercontact.text = @"联系方式:";
    
    self.contactWay = [[UILabel alloc] init];
    [self.white_view_four addSubview:self.contactWay];
    self.contactWay.textColor = kTextColor;
    self.contactWay.font = [UIFont systemFontOfSize:18.0f];
    
}

- (void)addSubviewToWhiteViewFive {

    self.small_tel = [[UIImageView alloc] init];
    [self.white_view_five addSubview:self.small_tel];
    self.small_tel.image = [UIImage imageNamed:@"call"];
    
    self.call_tel = [UIButton buttonWithType:0];
    [self.white_view_five addSubview:self.call_tel];
    [self.call_tel setTitle:@"拨打电话" forState:UIControlStateNormal];
    [self.call_tel setTitleColor:kRightColor forState:UIControlStateNormal];
    [self.call_tel addTarget:self action:@selector(callTel) forControlEvents:UIControlEventTouchUpInside];
    
    self.line_view = [[UIView alloc] init];
    [self.white_view_five addSubview:self.line_view];
    self.line_view.backgroundColor = [UIColor backgroundColor];
    
    self.small_QRcode = [[UIImageView alloc] init];
    [self.white_view_five addSubview:self.small_QRcode];
    self.small_QRcode.image = [UIImage imageNamed:@"图层-3"];

    self.show_QRcode = [UIButton buttonWithType:0];
    [self.white_view_five addSubview:self.show_QRcode];
    [self.show_QRcode setTitle:@"二维码" forState:UIControlStateNormal];
    [self.show_QRcode setTitleColor:kRightColor forState:UIControlStateNormal];
    [self.show_QRcode addTarget:self action:@selector(createQRCode) forControlEvents:UIControlEventTouchUpInside];

}
/**
 *  打电话
 */
- (void)callTel {

    if (self.delegate && [self.delegate respondsToSelector:@selector(new_orderDetailView_callTel:)] ) {
        
        [self.delegate new_orderDetailView_callTel:self.detail_model.tel];
        
    }
    
}
/**
 *  生成二维码
 */
- (void)createQRCode {

    if (self.delegate && [self.delegate respondsToSelector:@selector(new_orderDetailView_createQRCode:)] ) {
        
        [self.delegate new_orderDetailView_createQRCode:self.detail_model.orderid];
        
    }
    
}

#pragma mark - 
- (CGFloat)new_orderDetailViewWithModel:(DDQNewOrderDetailModel *)detail_model {

    CGFloat height = 0.0;
    self.detail_model = detail_model;
#pragma mark - 第一行
    NSString *order_title = [NSString stringWithFormat:@"【%@】%@",detail_model.name,detail_model.fname];
    CGRect title_rect = [order_title boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 + 30), 1010) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.5f]}];
    
    CGRect hospital_rect = [detail_model.hname boundStringRect_size:CGSizeMake(kScreenWidth - (kScreenWidth * 0.25 + 30), 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.5f]}];
    
    CGRect total_rect = [detail_model.newval boundStringRect_size:CGSizeMake(kScreenWidth, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.5f]}];
    
    [self.white_view_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.top_scroll.mas_top).offset(5);
        make.left.equalTo(self.top_scroll.mas_left);
        make.width.offset(kScreenWidth);

        if (20 + kScreenWidth * 0.25 > title_rect.size.height + hospital_rect.size.height + total_rect.size.height + 20) {
            
            make.height.offset(10 + kScreenWidth * 0.25 + 10);

        } else {
        
            make.height.offset(title_rect.size.height + hospital_rect.size.height + total_rect.size.height + 30);

        }
        
    }];
    
    [self.goods_img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_one.mas_top).offset(10);
        make.left.equalTo(self.white_view_one.mas_left).offset(15);
        make.width.offset(kScreenWidth * 0.25);
        make.height.offset(kScreenWidth * 0.25);
        
    }];
    [self.goods_img sd_setImageWithURL:[NSURL URLWithString:detail_model.simg]];
    
    [self.goods_intro mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.goods_img.mas_right).offset(5);
        make.top.equalTo(self.goods_img.mas_top).offset(2);
        make.width.offset(title_rect.size.width);
        make.height.offset(title_rect.size.height);
        
    }];
    self.goods_intro.text = order_title;
    
    [self.hosiptal_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.goods_intro.mas_bottom).offset(5);
        make.left.equalTo(self.goods_intro.mas_left);
        make.width.offset(hospital_rect.size.width);
        make.height.offset(hospital_rect.size.height);
        
    }];
    self.hosiptal_name.text = detail_model.hname;
    
    [self.total_price mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.white_view_one.mas_right).offset(-10);
        make.top.equalTo(self.hosiptal_name.mas_bottom).offset(5);
        
    }];
    self.total_price.text = [NSString stringWithFormat:@"￥:%@元",detail_model.newval];
    
#pragma mark - 第二行
    NSString *pay_string = @"";
    if ([detail_model.status intValue] == 2) {
        
        pay_string = @"定金支付";
        
    } else {
    
        pay_string = @"全款支付";
        
    }
    CGRect dingjin_rect = [pay_string boundStringRect_size:CGSizeMake(1000, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.5]}];
    [self.white_view_two mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_one.mas_bottom).offset(5);
        make.left.equalTo(self.top_scroll.mas_left);
        make.width.offset(kScreenWidth);
        make.height.offset(dingjin_rect.size.height*2 + 30);
        
    }];
    
    [self.fuKuan mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_two.mas_top).offset(10);
        make.left.equalTo(self.white_view_two.mas_left).offset(15);

    }];
    self.fuKuan.text = pay_string;
    
    [self.fuKuanJinE mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.fuKuan.mas_centerY);
        make.right.equalTo(self.white_view_two.mas_right).offset(-15);
        
    }];
    if ([detail_model.status intValue] == 2) {

        self.fuKuanJinE.text = [NSString stringWithFormat:@"￥:%@元",detail_model.dj];

    } else {
    
        self.fuKuanJinE.text = [NSString stringWithFormat:@"￥:%@元",detail_model.newval];

    }
    
    [self.fukuanLeiXing mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.fuKuan.mas_bottom).offset(10);
        make.left.equalTo(self.fuKuan.mas_left);
        
    }];
    self.fukuanLeiXing.text = [NSString stringWithFormat:@"实际付款(积分抵换%@元)",detail_model.point_money];
    
    [self.yingFuKuanJinE mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.fuKuanJinE.mas_right);
        make.centerY.equalTo(self.fukuanLeiXing.mas_centerY);
        
    }];
    self.yingFuKuanJinE.text = [NSString stringWithFormat:@"￥:%@元",detail_model.have_pay];
        
#pragma mark - 第三行
    NSString *fanxian_str = [NSString stringWithFormat:@"返积分%@点",detail_model.get_point];
    CGRect str_rect = [fanxian_str boundStringRect_size:CGSizeMake(1000, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.5]}];
    [self.white_view_three mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_two.mas_bottom).offset(5);
        make.left.equalTo(self.top_scroll.mas_left);
        make.width.offset(kScreenWidth);
        make.height.offset(str_rect.size.height + 20);
        
    }];
    
    [self.jiFen mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.white_view_three.mas_centerY);
        make.left.equalTo(self.white_view_three.mas_left).offset(15);
        
    }];
    
    [self.jiFenFanDian mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.white_view_three.mas_centerY);
        make.left.equalTo(self.jiFen.mas_right).offset(5);
        
    }];
    self.jiFenFanDian.text = fanxian_str;
    
#pragma mark - 第四行
    NSString *dingdan_str = @"订单号";
    CGRect dingdan_rect = [dingdan_str boundStringRect_size:CGSizeMake(1000, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.5f]}];
    [self.white_view_four mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_three.mas_bottom).offset(5);
        make.left.equalTo(self.top_scroll.mas_left);
        make.width.offset(kScreenWidth);
        make.height.offset(dingdan_rect.size.height * 3 + 30);
        
    }];
    
    [self.orderid mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.white_view_four.mas_left).offset(15);
        make.top.equalTo(self.white_view_four.mas_top).offset(10);
        
    }];
    
    [self.id_number mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.orderid.mas_right);
        make.centerY.equalTo(self.orderid.mas_centerY);
        
    }];
    self.id_number.text = detail_model.orderid;
    
    [self.ordertime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.orderid.mas_left);
        make.top.equalTo(self.orderid.mas_bottom).offset(5);
        
    }];
    
    [self.how_time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.ordertime.mas_right);
        make.centerY.equalTo(self.ordertime.mas_centerY);
        
    }];
    self.how_time.text = detail_model.ctime;
    
    [self.ordercontact mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.ordertime.mas_left);
        make.top.equalTo(self.ordertime.mas_bottom).offset(5);
        
    }];
    
    [self.contactWay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.ordercontact.mas_right);
        make.centerY.equalTo(self.ordercontact.mas_centerY);
        
    }];
    self.contactWay.text = detail_model.tel;
    
#pragma mark - 第五行
    NSString *boda_str = @"拨打电话";
    CGRect boda_rect = [boda_str boundStringRect_size:CGSizeMake(1000, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.5f]}];
    [self.white_view_five mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.white_view_four.mas_bottom).offset(5);
        make.left.equalTo(self.top_scroll.mas_left);
        make.width.offset(kScreenWidth);
        make.height.offset(boda_rect.size.height + 20);
        
    }];
    
    [self.small_QRcode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.white_view_five.mas_centerY);
        make.left.equalTo(self.white_view_five.mas_left).offset(24);
        
    }];
    
    [self.show_QRcode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.small_QRcode.mas_right);
        make.centerY.equalTo(self.small_QRcode.mas_centerY);
        
    }];
    return height;
    
}

@end
