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
    self.hud.labelText = @"加载中...";
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self teacher_netWork];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            self.two_cell = (DDQRowTwoTableViewCell *)[self.intro_view.intro_tableview cellForRowAtIndexPath:indexPath];
            [self.two_cell.rt_showLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
            self.type = 1;
            
        } else {
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
            //拼8段
            NSString *spellString = [SpellParameters getBasePostString];
            //拼参数
            NSString *base_str = [NSString stringWithFormat:@"%@*%@*%@*%ld*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.intro_model.course_id,self.type,self.intro_model.course_price];
            //加密这个八段
            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
            NSString *post_baseString = [postEncryption stringWithPost:base_str];
            //post一小下
            NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kteacher_orderUrl];

            NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                //11-30-15
                if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
                    
                    NSDictionary *get_json = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
                    [self alipaySignWith:get_json[@"orderid"] name:self.intro_model.course_name price:self.intro_model.course_price count:self.type];

                    
                } else if ([errorcode_string intValue] == 18){
                    
                    DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
                    boundTelVC.type = 2;
                    self.navigationController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:boundTelVC animated:YES];
                  
                } else {
                
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                }

            });
            //11-06
        });

    }];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
            //拼8段
            NSString *spellString = [SpellParameters getBasePostString];
            //拼参数
            NSString *base_str = [NSString stringWithFormat:@"%@*%@*%@*%ld*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.intro_model.course_id,self.type,self.intro_model.course_price];
            //加密这个八段
            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
            NSString *post_baseString = [postEncryption stringWithPost:base_str];
            //post一小下
            NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kWX_payUrl];
            
            NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                //11-06
                //11-30-15
                if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
                    
                    NSDictionary *get_json = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
                    
                    
                            NSDictionary *dic = get_json[@"wxinfo"];
                            
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
                    
                } else if ([errorcode_string intValue] == 18) {
                    
                    DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
                    boundTelVC.type = 2;
                    self.navigationController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:boundTelVC animated:YES];
                    
                } else {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
            });
            
        });
    }];
    
    UIAlertAction *action_3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert_vc addAction:action_1];
    [alert_vc addAction:action_2];
    [alert_vc addAction:action_3];
    [self presentViewController:alert_vc animated:YES completion:nil];
}

-(void)userLesson {

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
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
        });
    });

}

//-(void)intro_viewWithOrder:(NSInteger)num {
//
//    self.type = num;
//}

-(void)alipaySignWith:(NSString *)order_id name:(NSString *)name price:(NSString *)price count:(NSInteger)count {
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        //拼参数
        NSString *base_str = [NSString stringWithFormat:@"%@*%@",spellString,self.teacher_id];
        //加密这个八段
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_baseString = [postEncryption stringWithPost:base_str];
        //post一小下
        NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kteacher_introUrl];
        
        NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
        
        //11-06
        //11-30-15
        if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
            
            NSDictionary *get_json = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
            
            self.intro_model = [DDQTeacherIntroModel new];
            
            self.intro_model.course_banner = get_json[@"course_banner"];
            self.intro_model.course_id = get_json[@"course_id"];
            self.intro_model.course_intro = get_json[@"course_intro"];
            self.intro_model.course_name = get_json[@"course_name"];
            self.intro_model.course_price = get_json[@"course_price"];
            self.intro_model.teacher_intro = get_json[@"teacher_intro"];
            self.intro_model.teacher_name = get_json[@"teacher_name"];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                [self.hud removeFromSuperViewOnHide];
                
                self.intro_view.intro_model = self.intro_model;
                [self.intro_view.intro_tableview reloadData];
                
                self.label.text = self.intro_model.course_name;
                
            });
        } else if ([errorcode_string intValue] == 11 && get_serverDic !=nil) {
            
            [self.hud hide:YES];
            [self.hud removeFromSuperViewOnHide];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"教师不存在或已被删除" andShowDim:YES andSetDelay:YES andCustomView:nil];
        } else if ([errorcode_string intValue] == 12 && get_serverDic !=nil) {
        
            [self.hud hide:YES];
            [self.hud removeFromSuperViewOnHide];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"课程不存在或已被删除" andShowDim:YES andSetDelay:YES andCustomView:nil];
        } else {
        
            [self.hud hide:YES];
            [self.hud removeFromSuperViewOnHide];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:YES andSetDelay:YES andCustomView:nil];
        }
    });
}
@end
