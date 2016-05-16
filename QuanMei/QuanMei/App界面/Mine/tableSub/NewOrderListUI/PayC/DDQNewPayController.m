//
//  DDQNewPayController.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/9.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQNewPayController.h"

#import "DDQPayView.h"
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
            self.param_dic = @{@"orderid":source[@"orderid"],
                               @"tel":source[@"tel"],
                               @"name":source[@"name"],
                               @"price":source[@"newval"],
                               @"dj":source[@"dj"],
                               @"point":source[@"point"],
                               @"point_to_one":source[@"point_to_one"]};
            self.temp_dic = source;
            self.pay_view.param_dic = self.param_dic;

        }
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

- (void)pay_viewChangeType {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"支付类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action_one = [UIAlertAction actionWithTitle:@"订金" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
                    
                } else {
                
                    [self.wait_hud hide:YES];
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
                
            } else {
                
                [self.wait_hud hide:YES];
                
                float money = [source[@"money"] floatValue];
                if (money > 0.0f) {
                    
                    if (way == ZhifuBao) {
                        
                        NSString *price = @"";
                        if (type == DingJin) {
                            
                            price = self.param_dic[@"dj"];
                            
                        } else {
                        
                            price = self.param_dic[@"price"];
                            
                        }
                        
                        [DDQAlipay alipay_creatSignWithParam:@{@"orderid":self.param_dic[@"orderid"],@"name":self.param_dic[@"name"],@"price":price} PaySuccess:^{
                            
                            temp_hud.detailsLabelText = @"支付成功";
                            temp_hud.delegate = self;
                            [temp_hud show:YES];
                            [temp_hud hide:YES afterDelay:1.0f];
                            
                        } PayFailure:^(NSDictionary *reslut_dic) {
                            
                            //                    NSLog(@"%@",reslut_dic);
                            
                        }];
                        
                    } else {
                        
                       [DDQWXPay weixinPay_param:@{@"timestamp":source[@"timestamp"],@"pid":source[@"pid"],@"nonce_str":source[@"nonce_str"]}];
                  
                        
                    }
                    
                } else {
                
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"积分支付成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fresh" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fresh" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
