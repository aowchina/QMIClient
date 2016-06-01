//
//  DDQBoundTelViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/12.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQBoundTelViewController.h"
#import "DDQOrderDetailViewController.h"
@interface DDQBoundTelViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bt_phoneField;
@property (weak, nonatomic) IBOutlet UIView *bt_phoneview;
@property (weak, nonatomic) IBOutlet UITextField *bt_messageCodeField;
@property (weak, nonatomic) IBOutlet UIButton *bt_sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *bt_OkButton;

@end

@implementation DDQBoundTelViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bt_sendMessageButton.backgroundColor = [UIColor orangeColor];
    
    self.bt_OkButton.backgroundColor = [UIColor redColor];
    
    self.bt_OkButton.layer.cornerRadius = 5.0f;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (IBAction)bt_sendMessageButtonMethod:(id)sender {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.bt_phoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error){
            [self alertController:@"短信发送成功"];
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.bt_sendMessageButton.titleLabel.text = @"重新获取";
                        self.bt_sendMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                        self.bt_sendMessageButton.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [self.bt_sendMessageButton setTitle:[NSString stringWithFormat:@"(%@秒)后获取",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        [self.bt_sendMessageButton setBackgroundColor:[UIColor lightGrayColor]];
                        self.bt_sendMessageButton.userInteractionEnabled = NO;
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"%@",error.userInfo[@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }

    }];

}

- (IBAction)bt_OkButtonMethod:(id)sender {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    hud.detailsLabelText = @"请稍候...";
    [SMSSDK commitVerificationCode:self.bt_messageCodeField.text phoneNumber:self.bt_phoneField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                NSString *spellString             = [SpellParameters getBasePostString];//八段

                NSString *post_baseString         = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.bt_phoneField.text];//post字符串

                DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];//加密类

                NSString *post_string             = [postEncryption stringWithPost:post_baseString];//加密下

                NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kBand_telUrl];//发送下

                dispatch_async(dispatch_get_main_queue(), ^{

                    switch ([[post_dic objectForKey:@"errorcode"]intValue]) {
                        case 0:
                        {
                            [hud hide:YES];
                            NSString *spellString             = [SpellParameters getBasePostString];
                            NSString *post_baseString         = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], _tid];
                            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                            NSString *post_string             = [postEncryption stringWithPost:post_baseString];
                            NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kOrder_addUrl];


                            if (self.type == 1) {
                                DDQOrderDetailViewController * detailVC = [[DDQOrderDetailViewController alloc]init];
                                
                                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                                
                                detailVC.dj = _dj;
                                
                                detailVC.name = _name;
                                
                                detailVC.tel = get_jsonDic[@"tel"];
                                
                                detailVC.orderid = get_jsonDic[@"orderid"];
                                
                                self.navigationController.hidesBottomBarWhenPushed = YES;
                                
                                [self.navigationController pushViewController:detailVC animated:YES];
                            } else {
                            
                                [self.navigationController popViewControllerAnimated:YES];
                            }

                            break;
                        }
                        case 14:
                        {
                            [hud hide:YES];

                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已被占用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            break;
                        }
                        default:
                        {
                            [hud hide:YES];

                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器繁忙" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            break;
                        }
                    }

                });
                
            });
        } else {
            
            [hud hide:YES];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"%@",error.userInfo[@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - other method
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}

@end
