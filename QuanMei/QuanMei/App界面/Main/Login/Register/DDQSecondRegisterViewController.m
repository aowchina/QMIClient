//
//  DDQSecondRegisterViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSecondRegisterViewController.h"
#import "DDQFirstRegisterViewController.h"
#import "DDQThirdRegisterViewController.h"

#import "DDQLoginSingleModel.h"

@interface DDQSecondRegisterViewController ()<UITextFieldDelegate>

/**
 *  我要作为载体View
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  显示两个小的图片
 */
@property (strong,nonatomic) UIImageView *phoneImageView;
@property (strong,nonatomic) UIImageView *lockImageView;
/**
 *  输入电话号码，密码的field
 */
@property (strong,nonatomic) UITextField *inputPhoneNumField;
@property (strong,nonatomic) UITextField *inputPasswordField;
/**
 *  我要做一条华丽丽的分割线
 */
@property (strong,nonatomic) UIView *cuttingLineView;

@property (copy,nonatomic) NSString *spellString;

@end

@implementation DDQSecondRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor myGrayColor]];
    [self layoutNavigationBar];
    [self layoutControllerView];
    self.spellString = [SpellParameters getBasePostString];
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
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];

}


#pragma mark - layout navigationBar controls
-(void)layoutNavigationBar {
    self.navigationItem.title = @"登录信息";
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(pushToThirdViewController)];
    self.navigationItem.rightBarButtonItem = rigthItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackSecondViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)layoutControllerView {
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.8);
        make.height.equalTo(@10);
        if (kScreenHeight == 480) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else if (kScreenHeight == 568) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else if (kScreenHeight == 667) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.15);//y
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.15);//y
        }

    }];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setText:@"请保证手机处于正常接收短信状态"];
    
    //布局载体view
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight >= 667) {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
        } else {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
        }
        make.left.equalTo(self.view.mas_left);//x
        make.right.equalTo(self.view.mas_right);//w
        if (kScreenHeight == 480) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.25);//y
        } else if (kScreenHeight == 568) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.25);//y
        } else if (kScreenHeight == 667) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        }
    }];
    
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    
    //华丽丽的分割线
    self.cuttingLineView = [[UIView alloc] init];
    [self.backgroundView addSubview:self.cuttingLineView];
    
    [self.cuttingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);//h
        make.centerX.equalTo(self.backgroundView.mas_centerX);//x
        make.centerY.equalTo(self.backgroundView.mas_centerY);//y
        make.width.equalTo(self.backgroundView.mas_width);//w
    }];
    
    [self.cuttingLineView setBackgroundColor:[UIColor myGrayColor]];
    
    //小手机
    self.phoneImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.phoneImageView];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.cuttingLineView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.backgroundView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.phoneImageView setImage:[UIImage imageNamed:@"phone"]];
    self.phoneImageView.contentMode   = UIImageResizingModeStretch;
    
    //小锁
    self.lockImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.lockImageView];
    
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.backgroundView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.lockImageView setImage:[UIImage imageNamed:@"password"]];
    self.lockImageView.contentMode   = UIImageResizingModeStretch;
    
    //输入手机号
    self.inputPhoneNumField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputPhoneNumField];
    
    [self.inputPhoneNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top);//y
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.height.equalTo(self.backgroundView.mas_height).with.multipliedBy(0.5);//h
        make.right.equalTo(self.backgroundView.mas_right);//w
    }];
    [self.inputPhoneNumField setPlaceholder:@"请输入手机号"];
    self.inputPhoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputPhoneNumField.delegate = self;
    self.inputPhoneNumField.keyboardType = UIKeyboardTypePhonePad;

    //输入密码
    self.inputPasswordField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputPasswordField];
    
    [self.inputPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_bottom);//y
        make.right.equalTo(self.backgroundView.mas_right);//w
        make.height.equalTo(self.inputPhoneNumField.mas_height);//h
    }];
    [self.inputPasswordField setPlaceholder:@"请设置登录密码"];
    self.inputPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputPasswordField.secureTextEntry = YES;
}

#pragma mark - 正则表达式
+ (BOOL)validatePhoneNum:(NSString *)phoneNum {
    NSString *passWordRegex = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:phoneNum];
}

#pragma mark - 本地验证 返回BOOL值
-(BOOL)LocalValidation {
    if (_inputPhoneNumField.text == nil || _inputPasswordField.text == nil) {
        if (_inputPhoneNumField.text == nil) {
            [self alertController:@"请输入手机号"];
        } else {
            [self alertController:@"请输入登录密码"];
        }
        return NO;
        
    }else if (![DDQSecondRegisterViewController  validatePhoneNum:_inputPhoneNumField.text]){
        [self alertController:@"手机号不符合要求"];
        return NO;
    }
    return YES;
}

#pragma mark - navigationBar item target action
-(void)pushToThirdViewController {
    DDQThirdRegisterViewController *thirdRVC = [[DDQThirdRegisterViewController alloc] init];
    BOOL yesOrNo = [self LocalValidation];
    if (yesOrNo == YES) {
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            //网络连接无错误
            if (errorDic == nil) {
                
                DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];
                model.userPhone = _inputPhoneNumField.text;
                model.userPassword = _inputPasswordField.text;
                NSString *basePostString = [SpellParameters getBasePostString];
                
                NSString *poststing = [NSString stringWithFormat:@"%@*%@",basePostString,_inputPhoneNumField.text];
                
                DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
                NSString *postString = [post stringWithPost:poststing];
                
                NSDictionary *dic = [[PostData alloc] postData:postString AndUrl:kCheckPhone];
                
                int num = [[dic valueForKey:@"errorcode"] intValue];
                if (num == 0) {
                    
                    [self.navigationController pushViewController:thirdRVC animated:NO];
                } else if (num == 12) {
                    
                    [self alertController:@"手机号已存在"];
                } else {
                    [self alertController:@"服务器繁忙"];
                }
                
            } else {
                //第一个参数:添加到谁上
                //第二个参数:显示什么提示内容
                //第三个参数:背景阴影
                //第四个参数:设置是否消失
                //第五个参数:设置自定义的view
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
        }];

    }
    
}

-(void)goBackSecondViewController {
    self.inputPhoneNumField.text = nil;
    self.inputPasswordField.text = nil;
    [self.navigationController popViewControllerAnimated:NO];
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
