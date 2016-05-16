//
//  DDQPayView.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/9.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQPayView.h"

@interface DDQPayView ()<UITextFieldDelegate>
//上部的scrollview
@property ( strong, nonatomic) UIScrollView *scrollView;
/**
 *  接下来是scroll上的subview
 */
@property ( strong, nonatomic) UILabel *ID;
@property ( strong, nonatomic) UILabel *id_text;
@property ( strong, nonatomic) UILabel *phone;
@property ( strong, nonatomic) UILabel *phone_text;
@property ( strong, nonatomic) UILabel *goods;
@property ( strong, nonatomic) UILabel *goods_text;
@property ( strong, nonatomic) UILabel *time;
@property ( strong, nonatomic) UILabel *time_text;
@property ( strong, nonatomic) UILabel *bespeak;
@property ( strong, nonatomic) UILabel *bespeak_text;
@property ( strong, nonatomic) UILabel *type;
@property ( strong, nonatomic) UIButton *type_text_button;
@property ( strong, nonatomic) UILabel *way;
@property ( strong, nonatomic) UIButton *way_text_btn;

@property ( strong, nonatomic) UIView *line_one;
@property ( strong, nonatomic) UIView *line_two;
@property ( strong, nonatomic) UIView *line_three;
@property ( strong, nonatomic) UIView *line_four;
@property ( strong, nonatomic) UIView *line_five;
@property ( strong, nonatomic) UIView *line_six;
@property ( strong, nonatomic) UIView *line_seven;

@property ( strong, nonatomic) UILabel *tip_label_one;
@property ( strong, nonatomic) UILabel *tip_label_two;
@property ( strong, nonatomic) UITextField *input_field;
@property ( strong, nonatomic) UILabel *tip_label_three;

//下部的显示金额
@property ( strong, nonatomic) UIView *money_view;
/**
 *  moneyview上的subview
 */
@property ( strong, nonatomic) UILabel *total_label;

//下部的确认按钮
@property ( strong, nonatomic) UIButton *surePay_btn;

@property ( strong, nonatomic) NSDictionary *temp_dic;

@property ( assign, nonatomic) float total_price;

@property ( assign, nonatomic) PayType temp_type;
@property ( assign, nonatomic) PayWay temp_way;

@end

@implementation DDQPayView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        
        //scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, kScreenWidth, kScreenHeight - 75)];
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        /**
         scrollview上的subview
         */
        [self addSubviewToScrollView];
        
        //载体view
        self.money_view = [[UIView alloc] init];
        [self addSubview:self.money_view];
        self.money_view.backgroundColor = kRightColor;
        
        /**
          view上的subview
         */
        self.total_label = [[UILabel alloc] init];
        [self.money_view addSubview:self.total_label];
        self.total_label.font = [UIFont systemFontOfSize:15.0f];
        self.total_label.textColor = [UIColor whiteColor];
        
        
        self.surePay_btn = [UIButton buttonWithType:0];
        [self addSubview:self.surePay_btn];
        [self.surePay_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.surePay_btn.backgroundColor = [UIColor meiHongSe];
        [self.surePay_btn setTitle:@"确认支付" forState:UIControlStateNormal];
        [self.surePay_btn addTarget:self action:@selector(surePay:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  我需要观察一切和钱有关的东西，以便算总价
         */
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
            float jifen = [self.input_field.text floatValue];
            float duihuan = jifen / 100.0f;
            self.tip_label_three.text = [NSString stringWithFormat:@"积分，可抵消%.2f元",duihuan];
            
            float price = [self.temp_dic[@"price"] floatValue];
            self.total_price = price - duihuan;
            self.total_label.text = [NSString stringWithFormat:@"总计:￥%.2f元",self.total_price];
            
        }];
        
    }
    
    return self;
    
}

- (void)addSubviewToScrollView {

    //第一行的
    self.ID = [[UILabel alloc] init];
    [self.scrollView addSubview:self.ID];
    self.ID.text = @"订单号";
    self.ID.font = [UIFont systemFontOfSize:12.0f];
    self.ID.textColor = kLeftColor;
    
    self.id_text = [[UILabel alloc] init];
    [self.scrollView addSubview:self.id_text];
    self.id_text.font = [UIFont systemFontOfSize:12.0f];
    self.id_text.textColor = kRightColor;
    
    self.line_one = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_one];
    self.line_one.backgroundColor = kLineColor;
    
    //第二行的
    self.phone = [[UILabel alloc] init];
    [self.scrollView addSubview:self.phone];
    self.phone.text = @"联系电话";
    self.phone.font = [UIFont systemFontOfSize:12.0f];
    self.phone.textColor = kLeftColor;
    
    self.phone_text = [[UILabel alloc] init];
    [self.scrollView addSubview:self.phone_text];
    self.phone_text.font = [UIFont systemFontOfSize:12.0f];
    self.phone_text.textColor = kRightColor;
    
    self.line_two = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_two];
    self.line_two.backgroundColor = kLineColor;
    
    //第三行的
    self.goods = [[UILabel alloc] init];
    [self.scrollView addSubview:self.goods];
    self.goods.text = @"商品名称";
    self.goods.font = [UIFont systemFontOfSize:12.0f];
    self.goods.textColor = kLeftColor;
    
    self.goods_text = [[UILabel alloc] init];
    [self.scrollView addSubview:self.goods_text];
    self.goods_text.font = [UIFont systemFontOfSize:12.0f];
    self.goods_text.textColor = kRightColor;
    self.goods_text.numberOfLines = 0;
    
    self.line_three = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_three];
    self.line_three.backgroundColor = kLineColor;
    
    //第四行的
    self.time = [[UILabel alloc] init];
    [self.scrollView addSubview:self.time];
    self.time.text = @"有效期";
    self.time.font = [UIFont systemFontOfSize:12.0f];
    self.time.textColor = kLeftColor;
    
    self.time_text = [[UILabel alloc] init];
    [self.scrollView addSubview:self.time_text];
    self.time_text.font = [UIFont systemFontOfSize:12.0f];
    self.time_text.textColor = kRightColor;
    
    self.line_four = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_four];
    self.line_four.backgroundColor = kLineColor;
    
    //第五行的
    self.bespeak = [[UILabel alloc] init];
    [self.scrollView addSubview:self.bespeak];
    self.bespeak.text = @"预约特惠价";
    self.bespeak.font = [UIFont systemFontOfSize:12.0f];
    self.bespeak.textColor = kLeftColor;
    
    self.bespeak_text = [[UILabel alloc] init];
    [self.scrollView addSubview:self.bespeak_text];
    self.bespeak_text.font = [UIFont systemFontOfSize:12.0f];
    self.bespeak_text.textColor = kRightColor;
    
    self.line_five = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_five];
    self.line_five.backgroundColor = kLineColor;
    
    //第六行的
    self.type = [[UILabel alloc] init];
    [self.scrollView addSubview:self.type];
    self.type.text = @"支付类型";
    self.type.font = [UIFont systemFontOfSize:12.0f];
    self.type.textColor = kLeftColor;
    
    self.type_text_button = [UIButton buttonWithType:0];
    [self.scrollView addSubview:self.type_text_button];
    self.type_text_button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.type_text_button setTitleColor:kRightColor forState:UIControlStateNormal];
    [self.type_text_button setTitle:@"定金>" forState:UIControlStateNormal];
    [self.type_text_button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.line_six = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_six];
    self.line_six.backgroundColor = kLineColor;
    
    //第七行的
    self.way = [[UILabel alloc] init];
    [self.scrollView addSubview:self.way];
    self.way.text = @"支付方式";
    self.way.font = [UIFont systemFontOfSize:12.0f];
    self.way.textColor = kLeftColor;
    
    self.way_text_btn = [UIButton buttonWithType:0];
    [self.scrollView addSubview:self.way_text_btn];
    self.way_text_btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.way_text_btn setTitleColor:kRightColor forState:UIControlStateNormal];
    [self.way_text_btn setTitle:@"支付宝>" forState:UIControlStateNormal];
    [self.way_text_btn addTarget:self action:@selector(changeWay:) forControlEvents:UIControlEventTouchUpInside];

    self.line_seven = [[UIView alloc] init];
    [self.scrollView addSubview:self.line_seven];
    self.line_seven.backgroundColor = kLineColor;
    
    //第一行小提示
    self.tip_label_one = [[UILabel alloc] init];
    [self.scrollView addSubview:self.tip_label_one];
    self.tip_label_one.font = [UIFont systemFontOfSize:9.0f];
    self.tip_label_one.textColor = kLeftColor;
    
    //第二行小提示
    self.tip_label_two = [[UILabel alloc] init];
    [self.scrollView addSubview:self.tip_label_two];
    self.tip_label_two.text = @"使用";
    self.tip_label_two.font = [UIFont systemFontOfSize:9.0f];
    self.tip_label_two.textColor = kLeftColor;
    
    self.input_field = [[UITextField alloc] init];
    [self.scrollView addSubview:self.input_field];
    self.input_field.font = [UIFont systemFontOfSize:12.0f];
    self.input_field.textColor = kRightColor;
    self.input_field.textAlignment = NSTextAlignmentCenter;
    self.input_field.layer.borderWidth = 1.5f;
    self.input_field.delegate = self;
    self.input_field.keyboardType = UIKeyboardTypeNumberPad;
    self.input_field.layer.borderColor = [UIColor backgroundColor].CGColor;
    
    self.tip_label_three = [[UILabel alloc] init];
    [self.scrollView addSubview:self.tip_label_three];
    self.tip_label_three.font = [UIFont systemFontOfSize:9.0f];
    self.tip_label_three.textColor = kLeftColor;
    self.tip_label_three.text = @"积分，可抵消0元";

}
/**
 *  定金
 *
 */
- (void)changeType:(UIButton *)button {

    if (self.delegate && [self.delegate respondsToSelector:@selector(pay_viewChangeType)]) {
        
        [self.delegate pay_viewChangeType];
        
    }
    
}

- (void)setPay_type:(PayType)pay_type {

    self.temp_type = pay_type;
    if (pay_type == DingJin) {
        
        [self.type_text_button setTitle:@"定金>" forState:UIControlStateNormal];
        self.total_label.text = [NSString stringWithFormat:@"总计:￥%.2f元",[self.temp_dic[@"dj"] floatValue]];
        self.total_price = [self.temp_dic[@"dj"] floatValue];
        
    } else {
    
        [self.type_text_button setTitle:@"全款>" forState:UIControlStateNormal];
        self.total_label.text = [NSString stringWithFormat:@"总计:￥%.2f元",[self.temp_dic[@"price"] floatValue]];
        self.total_price = [self.temp_dic[@"price"] floatValue];

    }
    
}

/**
 *  支付方式
 *
 */
- (void)changeWay:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pay_viewChangeWay)]) {
        
        [self.delegate pay_viewChangeWay];
        
    }
    
}

- (void)setPay_way:(PayWay)pay_way {
    
    self.temp_way = pay_way;
    if (pay_way == ZhifuBao) {
        
        [self.way_text_btn setTitle:@"支付宝>" forState:UIControlStateNormal];
        
    } else {
        
        [self.way_text_btn setTitle:@"微信>" forState:UIControlStateNormal];
        
    }
    
}

/**
 *  确认支付按钮
 *
 */
- (void)surePay:(UIButton *)button {

    if (self.delegate && [self.delegate respondsToSelector:@selector(pay_viewSurePay:Jifen:Type:Way:Error:)]) {
        
        NSError *error = nil;
        if ([self.input_field.text intValue] > [self.temp_dic[@"point"] intValue]) {
            
            error = [NSError errorWithDomain:@"错误处理" code:2 userInfo:@{@"des":@"填入积分大于现有积分"}];
            
        }
        
        if (self.total_price < 0.0f) {
            
            error = [NSError errorWithDomain:@"错误处理" code:2 userInfo:@{@"des":@"折后价格需大于0元"}];
            
        }
        
        [self.delegate pay_viewSurePay:[NSString stringWithFormat:@"%.2f",self.total_price] Jifen:self.input_field.text Type:self.temp_type Way:self.temp_way Error:error];
        
    }
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    /**
     *  先把几个载体布局了
     */
    [self.money_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.mas_width).multipliedBy(0.6);
        make.height.offset(49);
        
    }];
    
    [self.surePay_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.money_view.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.mas_width).multipliedBy(0.4);
        make.height.offset(49);
        
    }];
    
    //第一行
    [self.ID mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.scrollView.mas_top).offset(-34);
        make.left.equalTo(self.scrollView.mas_left).offset(29);
        
    }];
    
    //第二行
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_one.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
   
    //第三行
    [self.goods mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_two.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
    
    //第四行
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_three.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
    
    
    //第五行
    [self.bespeak mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_four.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
    
    //第六行
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_five.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
    
    [self.type_text_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.centerY.equalTo(self.type.mas_centerY);
        
    }];
    
    
    //第七行
    [self.way mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line_six.mas_bottom).offset(17);
        make.left.equalTo(self.ID.mas_left);
        
    }];
    
    [self.way_text_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.centerY.equalTo(self.way.mas_centerY);
        
    }];
    
}

- (void)setParam_dic:(NSDictionary *)param_dic {

    self.temp_dic = param_dic;
    //底部总计
    NSString *total_string = [NSString stringWithFormat:@"总计:￥%@元",param_dic[@"dj"]];

    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.money_view.mas_right).offset(-10);
        make.centerY.equalTo(self.money_view.mas_centerY);
        
        
    }];
    self.total_label.text = total_string;
    
    //第一行
    NSString *id_string = param_dic[@"orderid"];
    CGRect id_rect = [id_string boundStringRect_size:CGSizeMake(kScreenWidth * 0.6, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.id_text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-29);
        make.centerY.equalTo(self.ID.mas_centerY);
        make.width.offset(id_rect.size.width);
        make.height.offset(id_rect.size.height);
        
    }];
    self.id_text.text = id_string;

    //第二行
    [self.phone_text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.centerY.equalTo(self.phone.mas_centerY);
        
    }];
    self.phone_text.text = param_dic[@"tel"];
    
    //第三行
    NSString *goods_string = param_dic[@"name"];
    CGRect goods_rect = [goods_string boundStringRect_size:CGSizeMake(kScreenWidth * 0.6, 1000) Attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5f]}];
    [self.goods_text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.top.equalTo(self.goods.mas_top);
        make.width.offset(goods_rect.size.width);
        make.height.offset(goods_rect.size.height);
        
    }];
    self.goods_text.text = goods_string;
    
    //第四行
    [self.time_text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.centerY.equalTo(self.time.mas_centerY);

        
    }];
    self.time_text.text = @"30分钟内有效";
    
    //第五行
    NSString *bespeak_string = [NSString stringWithFormat:@"%@元",param_dic[@"price"]];
    self.total_price = [param_dic[@"price"] floatValue];
    [self.bespeak_text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.id_text.mas_right);
        make.centerY.equalTo(self.bespeak.mas_centerY);
        
    }];
    self.bespeak_text.text = bespeak_string;
    
    //小提示
    float dihuan = 0.0f;
    if ([param_dic[@"point"] floatValue] > 0.0f) {
        
        dihuan = [param_dic[@"point"] floatValue] / [param_dic[@"point_to_one"] floatValue];

    } else {
        
        dihuan = 0.00f;

    }
    NSString *one_string = [NSString stringWithFormat:@"你当前有%@积分，使用积分可以抵换%.2f元",param_dic[@"point"],dihuan];
    [self.tip_label_one mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.line_seven.mas_bottom).offset(10);
        make.right.equalTo(self.line_seven.mas_right).offset(-3);
        
    }];
    self.tip_label_one.text = one_string;
    
    
    [self.tip_label_three mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.tip_label_one.mas_right);
        make.top.equalTo(self.tip_label_one.mas_bottom).offset(30);
        
    }];
    
    [self.input_field mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.width.offset(70);
        make.height.offset(30);
        make.centerY.equalTo(self.tip_label_three.mas_centerY);
        make.right.equalTo(self.tip_label_three.mas_left).offset(-10);
        
    }];
    
    [self.tip_label_two mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.input_field.mas_left).offset(-10);
        make.centerY.equalTo(self.tip_label_three.mas_centerY);
        
    }];
    
    [self.line_seven mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.way.mas_bottom).offset(17);
        
    }];
    
    [self.line_six mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.type.mas_bottom).offset(17);
        
    }];
    
    [self.line_five mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.bespeak.mas_bottom).offset(17);
        
    }];
    
    [self.line_four mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.time.mas_bottom).offset(17);
        
    }];
    
    [self.line_three mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.goods_text.mas_bottom).offset(17);
        
    }];
    
    [self.line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line_one.mas_left);
        make.right.equalTo(self.line_one.mas_right);
        make.height.offset(1);
        make.top.equalTo(self.phone.mas_bottom).offset(17);
        
    }];
    
    [self.line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.ID.mas_left).offset(-3);
        make.right.equalTo(self.id_text.mas_right).offset(3);
        make.height.offset(1);
        make.top.equalTo(self.id_text.mas_bottom).offset(17);
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 34 + id_rect.size.height + 90 + 30 + goods_rect.size.height + 30 + 90*4 + 8);
    self.scrollView.bounces = NO;
    
}

@end
