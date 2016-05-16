//
//  DDQBackPasswordViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQBackPasswordViewController.h"
#import "DDQResetViewController.h"
@interface DDQBackPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *messageCodeField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@end

@implementation DDQBackPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.phoneView.layer.cornerRadius = 5.0f;
    self.phoneImage.contentMode = UIImageResizingModeStretch;
    self.pushButton.backgroundColor = [UIColor meiHongSe];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (IBAction)sendMessButtonMethod:(id)sender {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
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
                        _sendCodeButton.titleLabel.text = @"重新获取";
                        _sendCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                        _sendCodeButton.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [_sendCodeButton setTitle:[NSString stringWithFormat:@"(%@秒)后获取",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        [_sendCodeButton setBackgroundColor:[UIColor grayColor]];
                        _sendCodeButton.userInteractionEnabled = NO;
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:[NSString stringWithFormat:@"错误描述：%@",error.userInfo[@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

    


}

- (IBAction)pushNextVButtonMethod:(id)sender {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    hud.detailsLabelText = @"请稍候...";

    [SMSSDK commitVerificationCode:self.messageCodeField.text phoneNumber:self.phoneField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            [hud hide:YES];
            DDQResetViewController *resSetVC = [[DDQResetViewController alloc] initWithNibName:@"DDQResetViewController" bundle:nil];
            resSetVC.phoneNum = self.phoneField.text;
            [self.navigationController pushViewController:resSetVC animated:YES];

        } else {
            [hud hide:YES];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"错误描述：%@",error.userInfo[@"getVerificationCode"]]
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
