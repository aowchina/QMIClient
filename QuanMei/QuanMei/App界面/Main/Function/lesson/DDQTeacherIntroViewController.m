//
//  DDQTeacherIntroViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQTeacherIntroViewController.h"
#import "DDQTeacherIntroView.h"
#import "DDQTeacherIntroModel.h"
#import "Order.h"
#import "DataSigner.h"

#import "DDQRowTwoTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "DDQBoundTelViewController.h"
#import "ProjectNetWork.h"
#import "MJExtension.h"
#import "DDQAlipay.h"
#import "DDQWXPay.h"

@interface DDQTeacherIntroViewController ()<IntroViewDelegate>
{
    NSString *orderString;
}
@property (strong,nonatomic) DDQTeacherIntroView *intro_view;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) DDQTeacherIntroModel *intro_model;
@property (strong,nonatomic) NSString *order_id;
@property (assign,nonatomic) NSInteger type;
@property ( strong, nonatomic) DDQRowTwoTableViewCell * two_cell;
@property ( strong, nonatomic) UILabel *label;
@property (nonatomic, strong) ProjectNetWork *netWork;
@end

@implementation DDQTeacherIntroViewController

-(void)loadView {

    [super loadView];
    self.intro_view = [[DDQTeacherIntroView alloc] initWithFrame:self.view.frame];
    self.intro_view.delegate = self;
    [self.view addSubview:self.intro_view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.label.text = self.lesson_name;
    self.label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = self.label;
    //小菊花
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.detailsLabelText = @"加载中...";
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self teacher_netWork];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    self.two_cell = (DDQRowTwoTableViewCell *)[self.intro_view.intro_tableview cellForRowAtIndexPath:indexPath];
    
    [self.two_cell.rt_showLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    
    self.type = 1;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    int num = [change[@"new"] intValue];
    self.type = num;

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.two_cell.rt_showLabel removeObserver:self forKeyPath:@"text"];
    
}

-(void)intro_selectedType {

    UIAlertController *alert_vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付方式:" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.hud show:YES];
        
        [self.netWork asyPOSTWithAFN_url:kteacher_orderUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.intro_model.course_id,@(self.type).stringValue,self.intro_model.course_price] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                NSInteger code = code_error.code;
                
                if (code == 18) {
                    
                    DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
                    boundTelVC.type = 2;
                    self.navigationController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:boundTelVC animated:YES];
                    
                } else {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                }
                
            } else {
                
                 [self alipaySignWith:responseObjc[@"orderid"] name:self.intro_model.course_name price:self.intro_model.course_price count:self.type];
                
            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];

    }];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.hud show:YES];
        
        [self.netWork asyPOSTWithAFN_url:kWX_payUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.intro_model.course_id,@(self.type).stringValue,self.intro_model.course_price] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                NSInteger code = code_error.code;
                
                if (code == 18) {
                    
                    DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
                    boundTelVC.type = 2;
                    self.navigationController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:boundTelVC animated:YES];

                } else {
                
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

                }
                
            } else {
                
                NSDictionary *dic = responseObjc[@"wxinfo"];
                
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
                
                [WXApi sendReq:pay_req];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLesson) name:@"lesson" object:nil];

            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];
        
    }];
    
    UIAlertAction *action_3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert_vc addAction:action_1];
    [alert_vc addAction:action_2];
    [alert_vc addAction:action_3];
    [self presentViewController:alert_vc animated:YES completion:nil];
    
}

-(void)userLesson {

    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kWX_payNotifyUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.order_id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 15|| code==16 || code==17) {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"获取微信订单信息异常" andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"支付成功" andShowDim:NO andSetDelay:YES andCustomView:nil];

        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];

}

-(void)alipaySignWith:(NSString *)order_id name:(NSString *)name price:(NSString *)price count:(NSInteger)count {
    
    NSString *partner = kAlipayPartner;
    NSString *seller = kAlipaySeller;
    NSString *privateKey = kAlipayPrivateKey;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = order_id; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription = @"无"; //商品描述
    NSInteger total = [price intValue] * count;
    order.amount = [NSString stringWithFormat:@"%ld",total]; //商品价格
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


-(void)teacher_netWork {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kteacher_introUrl andData:@[self.teacher_id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 11 || code == 12) {
                
                switch (code) {
                        
                    case 11:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"教师不存在或已被删除" andShowDim:YES andSetDelay:YES andCustomView:nil];
                        break;
                       
                    case 12:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"课程不存在或已被删除" andShowDim:YES andSetDelay:YES andCustomView:nil];
                        break;
                        
                    default:
                        break;
                }
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }
        
        } else {
        
            self.intro_model = [DDQTeacherIntroModel mj_objectWithKeyValues:responseObjc];
            
            [self.hud hide:YES];
            
            self.intro_view.intro_model = self.intro_model;
            [self.intro_view.intro_tableview reloadData];
            
            self.label.text = self.intro_model.course_name;
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}
@end
