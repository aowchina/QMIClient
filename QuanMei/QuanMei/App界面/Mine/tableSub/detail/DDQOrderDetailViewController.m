//
//  DDQOrderDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQOrderDetailViewController.h"

#import "DDQOrderDetailTableViewCell.h"

#import "Order.h"

#import "DataSigner.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"
@interface DDQOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *orderString;
}
@property (nonatomic ,strong)UITableView *orderDetailTableView;

@property (nonatomic ,strong)NSMutableArray *orderDetailArray;

@property (nonatomic ,strong)NSMutableArray * detailArray;

@property (strong,nonatomic) UIImageView *alipay_type;
@property (strong,nonatomic) UIImageView *alipay_img;
@property (strong,nonatomic) UIImageView *wx_type;
@property (strong,nonatomic) UIImageView *wx_img;

@property (assign,nonatomic) NSInteger pay_way;
@property (strong,nonatomic) NSString *order_id;

@end

@implementation DDQOrderDetailViewController

#pragma  lazy
- (NSMutableArray *)orderDetailArray
{
    if (!_orderDetailArray) {
        _orderDetailArray = [[NSMutableArray alloc]init];
    }
    return _orderDetailArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"完成预约";
    
    //12-08
    _orderDetailArray = [NSMutableArray arrayWithObjects:@"产品名称:",@"预约特惠价:",@"预约电话:",@"有效期:",@"定金:", nil];
   
    //12-16
    NSString *name  = [NSString stringWithFormat:@"%@", _name];
    NSString *price = [NSString stringWithFormat:@"%@",_price];
    NSString *tel   = [NSString stringWithFormat:@"%@", _tel];
    NSString *dj    = [NSString stringWithFormat:@"%@", _dj];
    
    _detailArray = [NSMutableArray arrayWithObjects: name,price,tel,@"一年",dj,nil];
    
    [self creatView];
    [self footViewforOrderDetail];
    self.pay_way = 0;
}

//table
- (void)creatView
{
    _orderDetailTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    
    _orderDetailTableView.delegate  = self;
    _orderDetailTableView.dataSource = self;
    
    _orderDetailTableView.scrollEnabled = NO;
    
    _orderDetailTableView.tableFooterView = [[UIView alloc]init];
    _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.view addSubview:_orderDetailTableView];
}

//type
- (void)footViewforOrderDetail
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0   , _orderDetailTableView.frame.origin.y +_orderDetailTableView.frame.size.height, kScreenWidth, self.view.frame.size.height -  _orderDetailTableView.frame.origin.y -_orderDetailTableView.frame.size.height)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    UIView *typeView = [[ UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    //    typeView.backgroundColor = [UIColor orangeColor];
    
    [view addSubview:typeView];
    
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth/3, typeView.frame.size.height)];
    
    typeLabel.text = @"定金支付方式:";
    
    typeLabel.font = [UIFont systemFontOfSize:15];
    
    [typeView addSubview:typeLabel];
    
    //圆点
    self.alipay_type = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                   typeLabel.frame.origin.x +typeLabel.frame.size.width,
                                                                                   typeView.frame.size.height/3,
                                                                                   typeView.frame.size.height/3,
                                                                                   typeView.frame.size.height/3)];
    //12-08
    //    xuanzhongImageView.backgroundColor = [UIColor blueColor];
    
    self.alipay_type.image = [UIImage imageNamed:@"选中"];
    
    self.alipay_type.layer.masksToBounds = YES;
    self.alipay_type.layer.cornerRadius =typeView.frame.size.height/3/2;
    
    [typeView addSubview:self.alipay_type];
    
    //支付宝图标
    self.alipay_img = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          self.alipay_type.frame.origin.x +self.alipay_type.frame.size.width,
                                                                          typeView.frame.size.height/3,
                                                                          50,
                                                                          typeView.frame.size.height/3)];
    //12-08
    //    typeImage.backgroundColor = [UIColor cyanColor];
    
    self.alipay_img.image = [UIImage imageNamed:@"支付宝"];
    [typeView addSubview:self.alipay_img];
    
    

    _wx_type = [UIImageView new];
    [self.view addSubview:_wx_type];
    [_wx_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipay_img.mas_right).offset(10);
        make.top.equalTo(self.alipay_type.mas_top);
        make.width.equalTo(self.alipay_type.mas_width);
        make.height.equalTo(self.alipay_type.mas_height);
    }];
    _wx_type.image = [UIImage imageNamed:@"未选中"];
    
    _wx_img = [UIImageView new];
    [self.view addSubview:_wx_img];
    [_wx_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wx_type.mas_right).offset(5);
        make.top.equalTo(self.alipay_img.mas_top);
        make.width.equalTo(self.alipay_img.mas_width);
        make.height.equalTo(self.alipay_img.mas_height);
    }];
    _wx_img.image = [UIImage imageNamed:@"微信"];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectedStatue:)];
     UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectedStatue:)];
     UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectedStatue:)];
     UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectedStatue:)];
    [self.alipay_type addGestureRecognizer:tap1];
    [self.alipay_img addGestureRecognizer:tap2];
    [self.wx_img addGestureRecognizer:tap3];
    [self.wx_type addGestureRecognizer:tap4];
    self.wx_type.userInteractionEnabled = YES;
    self.wx_img.userInteractionEnabled = YES;
    self.alipay_type.userInteractionEnabled = YES;
    self.alipay_img.userInteractionEnabled = YES;
    
    self.alipay_type.tag = 1;
    self.alipay_img.tag = 1;
    self.wx_type.tag = 2;
    self.wx_img.tag = 2;

    
    UIButton *enableButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    enableButton.frame = CGRectMake(10,
                                    typeView.frame.origin.y +typeView.frame.size.height+40,
                                    kScreenWidth-20,
                                    40);
    
    [enableButton setBackgroundImage:[UIImage imageNamed:@"确认支付"] forState:(UIControlStateNormal)];
    
    enableButton.layer.cornerRadius = 5;
    
    [enableButton addTarget:self action:@selector(enableButtonClickForOrderDetail) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:enableButton];
}

-(void)showSelectedStatue:(UITapGestureRecognizer *)tap {

    UIView *view = [tap view];
    if (view.tag == 1) {
        if (view == self.alipay_type || view == self.alipay_img) {
            self.wx_type.image = [UIImage imageNamed:@"未选中"];
            self.alipay_type.image = [UIImage imageNamed:@"选中"];
        }
        self.pay_way = 1;
    } else {
    
        if (view == self.wx_type || view == self.wx_img) {
            self.alipay_type.image = [UIImage imageNamed:@"未选中"];
            self.wx_type.image = [UIImage imageNamed:@"选中"];
        }
        self.pay_way = 2;
    }
}

- (void)enableButtonClickForOrderDetail
{
    if (self.pay_way == 0) {
        self.pay_way = 1;
    }
    
    if (self.pay_way == 1) {
        [self alipaySign];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"请稍等...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //八段
            NSString *spellString = [SpellParameters getBasePostString];
            
            //拼参数
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.orderid];
            
            //加密
            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
            NSString *post_encryption = [post stringWithPost:post_baseString];
            
            //传
            
            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kWX_payReqUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //判断errorcode
                NSString *errorcode = post_dic[@"errorcode"];
                int num = [errorcode intValue];
                if (num == 0) {
                    
                    NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                    NSDictionary *dic = get_jsonDic[@"wxinfo"];
                    
                    PayReq *pay_req = [[PayReq alloc] init];
                    pay_req.openID = kWeChatKey;
                    //微信支付分配的商户号
                    pay_req.partnerId = kWeChatPartner;
                    //微信返回的支付交易回话id
                    
                    pay_req.prepayId= dic[@"pid"];
                    
                    self.order_id = dic[@"orderid"];
                    //填写固定值sign = WXPay
                    pay_req.package = @"Sign=WXPay";
                    //
                    pay_req.nonceStr= dic[@"nonce_str"];
                    //时间戳
                    pay_req.timeStamp = [dic[@"timestamp"] floatValue];
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:kWeChatKey forKey:@"appid"];
                    [params setObject:pay_req.partnerId forKey:@"partnerid"];
                    [params setObject:pay_req.prepayId forKey:@"prepayid"];
                    [params setObject:[NSString stringWithFormat:@"%.0u",(unsigned int)pay_req.timeStamp] forKey:@"timestamp"];
                    
                    [params setObject:pay_req.nonceStr forKey:@"noncestr"];
                    [params setObject:pay_req.package forKey:@"package"];
                    //签名
                    payRequsestHandler *pay = [[payRequsestHandler alloc]init];
                    
                    NSString *sign  = [pay createMd5Sign:params];
                    
                    pay_req.sign= sign;

                    [hud hide:YES];
                    [hud removeFromSuperViewOnHide];
                    
                    [WXApi sendReq:pay_req];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notififyUser) name:@"notifify" object:nil];
                } else if (num == 15||num==16||num==17) {
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"获取微信订单信息异常" andShowDim:NO andSetDelay:YES andCustomView:nil];
                } else {
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
                
            });
        });
    }
}

-(void)notififyUser {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.order_id];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kWX_payNotifyUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"支付成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
            } else if (num == 15||num==16||num==17) {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"获取微信订单信息异常" andShowDim:NO andSetDelay:YES andCustomView:nil];
            } else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];

            }
        });
    });
}

-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifify" object:nil];
}

#pragma  mark - delegate for tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQOrderDetailTableViewCell * orderDetailCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!orderDetailCell) {
        orderDetailCell = [[DDQOrderDetailTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    //12-08
    orderDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    orderDetailCell.titleLabel.text = _orderDetailArray[indexPath.row];
    
    orderDetailCell.contentLabel.text = _detailArray[indexPath.row];
    
    return orderDetailCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _orderDetailTableView.frame = CGRectMake(0, 0, kScreenWidth, _orderDetailArray.count *44);
    
    return _orderDetailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

-(void)alipaySign {
    
    NSString *partner = @"2088121000537625";
    NSString *seller = @"846846@qq.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWuQ1WaXHjQcp3EOEfWhIezMJ0006VIsYNaaEyle4MoooWhk00vctcBYTdd6VQjIIeQdk2u5oDJCPAG a0fL0mesdF31dlw4l6zUoDS5eSA5wVYtNkFeYcKt972XClaeBivjdZA6ZghfstKEYz+d4WTn2gOvChB5Zm6iWlfVUqQTAgMBAAECgYB75sbTf8XX/6bnVdaEyGMW/uxI jJTfcxm4H9FhwRMSWUTMh0JhTY0oT/gUEOuvTbkU3yoXdLmLHPZaI1vYi1sbfcXb F/FotGmkfSKoQSk/lokQxfcW8i4LOJLOfyKoEQhqhAedG5Q96TMiaHAbOPdwq6oC 7tuN4sw1zqnRTmxoUQJBAP95kdPuq0TDt3egirBaUUf7UenCwySPtifKJduMlcDg S2dIIkss3Sm1D5++dzOrAtFb2lYC1zteP5+2AK7ocakCQQDGFkg/F6tujNy1yBuj I8bpl8DMvB+oJJeF8oRrTosQL8hdGlh4NgmEUs7uIDnj6rn+C79CBBJbgOD75qt+wHVbAkBN2LuI+tcRcxn6x9668iqGZpyFQKW6BFibM0vp5KLVTQNtC1v30EnsJZIH OUCVa+zF4tlbEC6JlqSIhCsdIRNRAkBsa7/JgMwda05W1RuDdM6oBp7JsOJm5vhk oXQnQ8tL5ct2YjgwO+uDmMuYfN0SyeRZj9Z0bMQbf3QljIErlG3nAkEAo0bBRYWJ NDT7qYbLI5zaMDthr9E+K9/x8fLBRlTd38ghUxlzfg2i1fwoGUgCLtMBcjG8RuGI Q7/yxavY7RuJMQ==";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = _orderid; //订单ID（由商家自行制定）
    order.productName = _name; //商品标题
    order.productDescription = @"无"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[_dj floatValue]]; //商品价格
//    order.amount = @"0.01"; //商品价格

    order.notifyURL =  kOrder_zfbUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"QuanMei";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {
                
                [self.navigationController popViewControllerAnimated:YES];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self
                                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败" delegate:self
                                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];

            }
            
        }];
    }
}
@end
