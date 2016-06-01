//
//  DDQThirdRegisterViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQThirdRegisterViewController.h"
#import "DDQMainViewController.h"
#import "DDQGroupViewController.h"
#import "DDQPreferenceViewController.h"
#import "DDQMineViewController.h"

#import "DDQLoginSingleModel.h"
#import "DDQUserInfoModel.h"
#import "DDQBaseTabBarController.h"

@interface DDQThirdRegisterViewController ()

@property (strong,nonatomic) UITextField *messageCodeField;
@property (strong,nonatomic) UIButton *sendMessageButton;
@property (strong,nonatomic) UIButton *sureButton;

@property ( strong, nonatomic) DDQBaseTabBarController *baseTabBarC;

@end

@implementation DDQThirdRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationBar];
    [self layoutControllerView];
    
    self.baseTabBarC = [DDQBaseTabBarController sharedController];
  
    self.view.backgroundColor = [UIColor myGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        //网络连接无错误
        if (errorDic == nil) {
            
            
            
        } else {
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

#pragma mark - layout navigationBar controllerView
-(void)layoutNavigationBar {
    self.navigationItem.title = @"最后验证";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackSecondViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)layoutControllerView {
    self.messageCodeField = [[UITextField alloc] init];
    [self.view addSubview:self.messageCodeField];
    [self.messageCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight == 480) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.25);//y
        } else if (kScreenHeight == 568) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.25);//y
        } else if (kScreenHeight == 667) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        }
        make.left.equalTo(self.view.mas_left).with.offset(self.view.frame.size.width*0.05);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.50);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(0.08);
    }];
    [self.messageCodeField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.messageCodeField setPlaceholder:@"请输入验证码"];
    
    self.sendMessageButton = [[UIButton alloc] init];
    [self.view addSubview:self.sendMessageButton];
    [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageCodeField.mas_right).with.offset(self.view.frame.size.width*0.05);
        make.top.equalTo(self.messageCodeField.mas_top);
        make.height.equalTo(self.messageCodeField.mas_height);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.35);
    }];
    [self.sendMessageButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.sendMessageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendMessageButton setBackgroundColor:[UIColor orangeColor]];
    [self.sendMessageButton.layer setCornerRadius:3.0f];
    [self.sendMessageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    self.sureButton = [[UIButton alloc] init];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageCodeField.mas_left);
        make.right.equalTo(self.sendMessageButton.mas_right);
        make.height.equalTo(self.sendMessageButton.mas_height).with.multipliedBy(0.8);
        make.top.equalTo(self.sendMessageButton.mas_bottom).with.offset(self.view.bounds.size.height*0.05);
    }];
    [self.sureButton setBackgroundColor:[UIColor meiHongSe]];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(pushToMainViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton.layer setCornerRadius:3.0f];
}

#pragma mark - navigationBar item target action
-(void)goBackSecondViewController {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)sendMessage {
    DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:model.userPhone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self alertController:@"短信发送成功"];
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _sendMessageButton.titleLabel.text = @"重新获取";
                        _sendMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                        _sendMessageButton.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [_sendMessageButton setTitle:[NSString stringWithFormat:@"(%@秒)后获取",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        [_sendMessageButton setBackgroundColor:[UIColor lightGrayColor]];
                        _sendMessageButton.userInteractionEnabled = NO;
                        
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

-(void)pushToMainViewController {
    
    DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    hud.detailsLabelText = @"请稍候...";

    [SMSSDK commitVerificationCode:self.messageCodeField.text phoneNumber:model.userPhone zone:@"86" result:^(NSError *error) {
        if (!error) {
            [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                
                //网络连接无错误
                if (errorDic == nil) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];
                        
                        NSString *basePostString = [SpellParameters getBasePostString];
                        
                        NSData *data = [model.nameString dataUsingEncoding:NSUTF8StringEncoding];
                        Byte *byteArray = (Byte *)[data bytes];
                        NSMutableString *str = [[NSMutableString alloc] init];
                        for(int i=0;i<[data length];i++) {
                            [str appendFormat:@"%d#",byteArray[i]];
                        }
                        
                        NSString *poststing = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",basePostString,str,model.userBorn,model.userPhone,model.userPassword];
                        
                        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                        NSString *postString = [postEncryption stringWithPost:poststing];
                        
                        NSMutableDictionary *dic = [[PostData alloc] postData:postString AndUrl:kRegisterUrl];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hide:YES];
                            
                            if (dic != nil) {
                                
                                int num = [[dic valueForKey:@"errorcode"] intValue];
                                if (num == 0) {
                                    NSString *getString = [postEncryption stringWithDic:dic];
                                    
                                    NSData *data = [getString dataUsingEncoding:NSUTF8StringEncoding];
                                    
                                    NSError *error = [[NSError alloc] init];
                                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                    
                                    
                                    DDQUserInfoModel *infoModel  = [DDQUserInfoModel singleModelByValue];
                                    infoModel.userimg          = [dataDic valueForKey:@"img"];
                                    [[NSUserDefaults standardUserDefaults] setValue:[dataDic valueForKey:@"userid"] forKey:@"userId"];
                                    infoModel.isLogin            = YES;
                                    
                                    
                                    [UIApplication sharedApplication].keyWindow.rootViewController = self.baseTabBarC;
                                    
                                } else {
                                    
                                    [hud hide:YES];
                                    [self alertController:@"系统繁忙"];
                                    
                                }

                            } else {
                            
                                [self alertController:@"系统繁忙"];

                            }
                            
                        });
                    });
                    
                } else {
                    //第一个参数:添加到谁上
                    //第二个参数:显示什么提示内容
                    //第三个参数:背景阴影
                    //第四个参数:设置是否消失
                    //第五个参数:设置自定义的view
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
            }];
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
