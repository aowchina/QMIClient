//
//  DDQResetViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQResetViewController.h"

#import "DDQLoginViewController.h"

#import "ProjectNetWork.h"

@interface DDQResetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ProjectNetWork *netWork;

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
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    
    self.netWork = [ProjectNetWork sharedWork];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (IBAction)sureButtonMethod:(id)sender {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kPassword_csUrl andData:@[self.phoneNum,self.passwordField.text,self.inputPasswordField.text] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 10 || code == 11 || code == 12 || code == 13) {
                
                switch (code) {
                        
                    case 10:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"手机号格式不符" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        break;
                        
                    case 11:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"密码格式不符" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        break;
                        
                    case 12:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"两次密码输入不一致" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        break;
                        
                    case 13:
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"手机号不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        break;
                        
                    default:
                        break;
                        
                }
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
        } else {
        
            [self.hud hide:YES];
            
            //这是为了回上一个页面的做下提示
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(resetVCNotificationMethod)]) {
                
                [self.delegate resetVCNotificationMethod];
                
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
    } andFailure:^(NSError *error) {
    
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];

}


@end
