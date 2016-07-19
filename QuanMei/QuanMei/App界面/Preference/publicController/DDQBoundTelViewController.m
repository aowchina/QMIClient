//
//  DDQBoundTelViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/12.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQBoundTelViewController.h"

#import "ProjectNetWork.h"

@interface DDQBoundTelViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bt_phoneField;
@property (weak, nonatomic) IBOutlet UIView *bt_phoneview;
@property (weak, nonatomic) IBOutlet UITextField *bt_messageCodeField;
@property (weak, nonatomic) IBOutlet UIButton *bt_sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *bt_OkButton;

@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQBoundTelViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bt_sendMessageButton.backgroundColor = [UIColor orangeColor];
    
    self.bt_OkButton.backgroundColor = [UIColor redColor];
    
    self.bt_OkButton.layer.cornerRadius = 5.0f;
    
    self.netWork = [ProjectNetWork sharedWork];
    
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
            
                        [self.bt_sendMessageButton setTitle:@"重新获取" forState:UIControlStateNormal];
                        self.bt_sendMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                        self.bt_sendMessageButton.userInteractionEnabled = YES;
                        self.bt_sendMessageButton.backgroundColor = [UIColor orangeColor];
                        
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
                                                            message:[NSString stringWithFormat:@"%@",error.userInfo[@"commitVerificationCode"]]
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
            
            [self.netWork asyPOSTWithAFN_url:kBand_telUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.bt_phoneField.text] andSuccess:^(id responseObjc, NSError *code_error) {
                
                if (code_error) {
                    
                    [hud hide:YES];
                    
                    NSInteger code = code_error.code;
                    
                    if (code == 14) {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"手机号已被注册" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        
                    } else {
                    
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

                    }
                    
                } else {
                
                    hud.detailsLabelText = @"绑定手机号成功";
                    [hud hide:YES afterDelay:1.5];
                    hud.delegate = self;
                    
                }
                
            } andFailure:^(NSError *error) {
                
                [hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }];
        
        } else {
        
            [hud hide:YES];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"%@",error.userInfo[@"commitVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
}
/** hud的代理 */
- (void)hudWasHidden:(MBProgressHUD *)hud {

    [hud hide:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
