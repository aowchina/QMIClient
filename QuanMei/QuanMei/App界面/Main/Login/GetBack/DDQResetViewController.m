//
//  DDQResetViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQResetViewController.h"

#import "DDQLoginViewController.h"

@interface DDQResetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation DDQResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.sureButton.backgroundColor = [UIColor meiHongSe];
    self.lineView.backgroundColor = [UIColor backgroundColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
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

- (IBAction)sureButtonMethod:(id)sender {
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        //网络连接无错误
        if (errorDic == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *basePostString = [SpellParameters getBasePostString];
                
                NSString *poststing = [NSString stringWithFormat:@"%@*%@*%@*%@",basePostString,self.phoneNum,self.passwordField.text,self.inputPasswordField.text];
                
                DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                NSString *postString = [postEncryption stringWithPost:poststing];
                
                NSMutableDictionary *dic = [[PostData alloc] postData:postString AndUrl:kPassword_csUrl];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    int num = [[dic valueForKey:@"errorcode"] intValue];
                    
                    if (num == 0) {
                        
                        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(resetVCNotificationMethod)]) {
                            [self.delegate resetVCNotificationMethod];
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    } else if (num == 10) {
                        
                        [self alertController:@"手机号格式不符"];
                    } else if (num == 11) {
                        
                        [self alertController:@"密码格式不符"];
                    } else if (num == 12) {
                        
                        [self alertController:@"两次密码输入不一致"];
                    } else if (num == 13) {
                        
                        [self alertController:@"手机号不存在"];
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
    }

#pragma mark - other methods
-(void)alertController:(NSString *)message {
    
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}

@end
