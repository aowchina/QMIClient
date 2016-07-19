//
//  DDQNewPayController.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/9.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQNewPayController.h"

#import "DDQAlipay.h"
#import "DDQWXPay.h"

@interface DDQNewPayController ()<PayViewDelegate,MBProgressHUDDelegate>

@property ( strong, nonatomic) DDQPayView *pay_view;
@property ( strong, nonatomic) NSDictionary *param_dic;
@property ( strong, nonatomic) NSDictionary *temp_dic;

@end

@implementation DDQNewPayController

- (void)loadView {
    
    [super loadView];
    
    self.pay_view = [[DDQPayView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.pay_view];
    self.pay_view.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    self.title_label.text = @"订单支付";
    self.pay_view.pay_type = DingJin;
    self.pay_view.pay_way = ZhifuBao;
    [self newPayC_netWork];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"order_invalid" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}
/**
 *  网络请求
 */
- (void)newPayC_netWork {

    [self.wait_hud show:YES];
    
    [self.net_work asy_netWithUrlString:kWaiDetailUrl ParamArray:@[self.userid,self.orderid] Success:^(id source, NSError *analysis_error) {
    
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {

            [self.wait_hud hide:YES];
            NSDictionary *dic = [DDQPublic nullDic:source];
            self.param_dic = @{@"orderid":dic[@"orderid"],
                               @"tel":dic[@"tel"],
                               @"name":dic[@"name"],
                               @"newval":dic[@"newval"],
                               @"dj":dic[@"dj"],
                               @"point":dic[@"point"],
                               @"point_to_one":dic[@"point_to_one"],
                               @"wk_money":dic[@"wk_money"],
                               @"chatime":dic[@"chatime"]};
            
            self.temp_dic = source;
            
            self.pay_view.param_dic = self.param_dic;
            
            if (self.pay_type) {
                
                self.pay_view.pay_type = self.pay_type;

            }
            
            self.pay_view.what_pay = self.what_pay;
            
        }
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

- (void)pay_viewChangeType {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"支付类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action_one = [UIAlertAction actionWithTitle:@"定金" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.pay_view.pay_type = DingJin;
        
    }];
    
    UIAlertAction *action_two = [UIAlertAction actionWithTitle:@"全款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.pay_view.pay_type = QuanKuan;
        
    }];
    
    UIAlertAction *action_three = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:action_one];
    [alertC addAction:action_two];
    [alertC addAction:action_three];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}

- (void)pay_viewChangeWay {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action_one = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.pay_view.pay_way = ZhifuBao;
        
    }];
    
    UIAlertAction *action_two = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.pay_view.pay_way = Weixin;
        
    }];
    
    UIAlertAction *action_three = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:action_one];
    [alertC addAction:action_two];
    [alertC addAction:action_three];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
/**
 *  确认支付按钮
 *
 *  @param total 总价
 *  @param jifen 使用积分
 *  @param type  支付类型
 *  @param way   支付方式
 *  @param error 错误描述
 */
- (void)pay_viewSurePay:(NSString *)total Jifen:(NSString *)jifen Type:(PayType)type Way:(PayWay)way Error:(NSError *)error {

    MBProgressHUD *temp_hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:temp_hud];
    temp_hud.mode = MBProgressHUDModeText;
   
    if (error) {
        
        temp_hud.detailsLabelText = error.userInfo[@"des"];
        [temp_hud show:YES];
        [temp_hud hide:YES afterDelay:1.0f];
        
    } else {
    
        [self.wait_hud show:YES];
        if ([jifen isEqualToString:@""]) {
            
            jifen = @"0";
            
        }
        [self.net_work asy_netWithUrlString:kBeforePayUrl ParamArray:@[self.userid,self.orderid,[NSString stringWithFormat:@"%ld",(unsigned long)type],[NSString stringWithFormat:@"%ld",(unsigned long)way],jifen] Success:^(id source, NSError *analysis_error) {
            
            if (analysis_error) {
                
                if (analysis_error.code == 22) {
                    
                    [self.wait_hud hide:YES];
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"积分填写有误" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                } else if (analysis_error.code == 21){
                
                    [self.wait_hud hide:YES];
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"积分不足" andShowDim:NO andSetDelay:YES andCustomView:nil];
                  
                } else {
                
                    [self.wait_hud hide:YES];
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                }
                
            } else {
                
                [self.wait_hud hide:YES];
                
                float money = [source[@"money"] floatValue];
                /**
                 *  交钱
                 */
                if (money > 0.0f) {
                    
                    if (way == ZhifuBao) {
                        
                        NSString *price = [NSString stringWithFormat:@"%.2f",[source[@"money"] floatValue]];
                        
                        [DDQAlipay alipay_creatSignWithParam:@{@"orderid":source[@"orderid"],@"name":self.param_dic[@"name"],@"price":price} PaySuccess:^{
                            
                            temp_hud.detailsLabelText = @"支付成功";
                            temp_hud.delegate = self;
                            [temp_hud show:YES];
                            [temp_hud hide:YES afterDelay:1.0f];
                            
                        } PayFailure:^(NSDictionary *reslut_dic) {
                            
                            
                        }];
                        
                    } else {
                        
                       [DDQWXPay weixinPay_param:@{@"timestamp":source[@"timestamp"],@"pid":source[@"pid"],@"nonce_str":source[@"nonce_str"]}];
                  
                        /**
                         *  微信回调一定走onReq,在哪里发个通知
                         *
                         *  @param note 回调的微信的参数
                         *
                         */
                        [[NSNotificationCenter defaultCenter] addObserverForName:@"notifify" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                            
                            NSDictionary *dic = note.userInfo;
                            if ([[dic valueForKey:@"errorcode"] intValue] == 0) {
                                
                                temp_hud.detailsLabelText = @"支付成功";
                                temp_hud.delegate = self;
                                [temp_hud show:YES];
                                [temp_hud hide:YES afterDelay:1.0f];
                                
                            }
                            
                        }];

                    }
                    
                } else {
                
                    temp_hud.detailsLabelText = @"积分支付成功";
                    temp_hud.delegate = self;
                    [temp_hud show:YES];
                    [temp_hud hide:YES afterDelay:1.0f];
                    
                }
                
            }
            
        } Failure:^(NSError *net_error) {
            
            [self.wait_hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }] ;

    }
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {

    [hud removeFromSuperViewOnHide];
    
    /**
     *  这是为了刷新我的订单下的订单列表
     */
//    if (self.c_type == kServerController) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshServer" object:nil];
//
//    } else {
//    
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"fresh" object:nil];
//
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFreshControllerNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
