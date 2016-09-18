//
//  DDQLoginViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQLoginViewController.h"
#import "DDQFirstRegisterViewController.h"
#import "AppDelegate.h"
#import "DDQBackPasswordViewController.h"
#import "DDQUserPolicyController.h"
#import "DDQResetViewController.h"
#import "DDQBaseTabBarController.h"

#import "DDQLoginSingleModel.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "DDQMyWalletViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"

#import "DDQUserInfoModel.h"

#import "DDQPOSTEncryption.h"
#import "ProjectNetWork.h"

typedef void(^popToMainViewController)();

@interface DDQLoginViewController ()<TencentSessionDelegate,TencentLoginDelegate,ResetVCDelegate>
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
/**
 *  找回密码,登录,第三方登陆按钮
 */
@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) UIButton *findPasswordButton;
@property (strong,nonatomic) UIButton *sinaLoginButton;
@property (strong,nonatomic) UIButton *wechatLoginButton;
@property (strong,nonatomic) UIButton *QQLoginButton;
/**
 *  中间提示的label
 */
@property (strong,nonatomic) UILabel *tipLabel;
/**
 *  请求的八段字符串
 */
@property (copy,nonatomic) NSString *spellString;

@property (strong,nonatomic) TencentOAuth *tencentOAuth;

@property (copy,nonatomic) NSString *nickname;
@property (copy,nonatomic) NSString *headimg;

@property (copy,nonatomic) NSString *openId;

@property (copy,nonatomic) NSString *weiboToken;
@property (copy,nonatomic) NSString *weiboUserId;
@property (copy,nonatomic) NSString *weiboRefreshToken;

@property (strong,nonatomic) NSMutableData *my_data;

@property (strong,nonatomic) popToMainViewController pop;

@property (strong,nonatomic) NSDictionary *error_dic;
@property (strong,nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) DDQBaseTabBarController *baseTabBarC;
@property (nonatomic, strong) ProjectNetWork *netWork;
@end

@implementation DDQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self layoutNavigationItem];
    [self layoutControllerView];
    
    self.spellString = [SpellParameters getBasePostString];//八段字符串
    DDQResetViewController *resetVC = [DDQResetViewController new];
    resetVC.delegate = self;
    self.baseTabBarC = [[DDQBaseTabBarController alloc] init];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
	
	//设置左按钮
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_return"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackMethod)];
	
	self.navigationItem.leftBarButtonItem = leftItem;
	
}

-(void)resetVCNotificationMethod {

    [self alertController:@"密码重置成功"];
}

//取消响应事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - layout navigationBar
-(void)layoutNavigationItem{
    
    [self.navigationItem setTitle:@"登录"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setTintColor:[UIColor meiHongSe]];
    
    UIBarButtonItem *barRightItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(pushToRegisterViewController)];
    self.navigationItem.rightBarButtonItem = barRightItem;
}

#pragma mark - navigationBar item target aciton
-(void)pushToRegisterViewController {
    DDQFirstRegisterViewController *firstRVC = [[DDQFirstRegisterViewController alloc] init];
    [self.navigationController pushViewController:firstRVC animated:YES];
}

-(void)goBackMethod {
		
    [self.navigationController popViewControllerAnimated:NO];
	
	
}

#pragma mark - layout Controller View
-(void)layoutControllerView {
        
    //布局载体view
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight >= 667) {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
        } else {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.2);//h
        }
        make.left.equalTo(self.view.mas_left);//x
        make.right.equalTo(self.view.mas_right);//w
        make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.1);//y
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
    
    //输入密码
    self.inputPasswordField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputPasswordField];
    
    [self.inputPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_bottom);//y
        make.right.equalTo(self.backgroundView.mas_right);//w
        make.height.equalTo(self.inputPhoneNumField.mas_height);//h
    }];
    
    [self.inputPasswordField setPlaceholder:@"密码"];
    self.inputPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputPasswordField.secureTextEntry = YES;
    
    //小标题
   
    
    //登录按钮
    self.loginButton = [[UIButton alloc] init];
    [self.view addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);//h
        make.left.equalTo(self.view.mas_left).with.offset(10);//x
        make.right.equalTo(self.view.mas_right).with.offset(-10);//w
        make.top.equalTo(self.backgroundView.mas_bottom).with.offset(50);//y
    }];
    
    [self.loginButton setBackgroundColor:[UIColor meiHongSe]];
    [self.loginButton.layer setCornerRadius:5.0f];
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginToApp) forControlEvents:UIControlEventTouchUpInside];
    
    //找回密码
    self.findPasswordButton = [[UIButton alloc] init];
    [self.view addSubview:self.findPasswordButton];
    
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginButton.mas_right);//w
        make.width.equalTo(self.loginButton.mas_width).with.multipliedBy(0.2);//x
        make.bottom.equalTo(self.loginButton.mas_top).with.offset(-self.view.bounds.size.height*0.05);//h
        make.top.equalTo(self.backgroundView.mas_bottom).with.offset(5);//y
    }];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"忘记密码?" attributes:@{NSUnderlineStyleAttributeName:@1,NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    [self.findPasswordButton setAttributedTitle:string forState:UIControlStateNormal];
    [self.findPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.findPasswordButton addTarget:self action:@selector(findPasswordMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //根据屏幕的宽高决定button宽高
    CGFloat kButtonW;
    CGFloat kSplite;
    if (self.view.frame.size.width > 375) {
        kButtonW = self.view.frame.size.width*0.10;
        kSplite = 20;
    } else {
        kButtonW = self.view.frame.size.width*0.15;
        kSplite = 15;

    }
    //第三方登陆
    
     if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
         
         self.wechatLoginButton = [[UIButton alloc] init];
         [self.view addSubview:self.wechatLoginButton];
         [self.wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
             
             make.left.equalTo(self.view.mas_centerX);
             make.width.offset(kButtonW);
             make.height.equalTo(self.wechatLoginButton.mas_width);
             make.bottom.equalTo(self.view.mas_bottom).offset(-30);
             
         }];
         [self.wechatLoginButton setImage:[UIImage imageNamed:@"login_wechat_bg"] forState:UIControlStateNormal];
         [self.wechatLoginButton addTarget:self action:@selector(goWeChatLogin) forControlEvents:UIControlEventTouchUpInside];
         
         self.QQLoginButton = [[UIButton alloc] init];
         [self.view addSubview:self.QQLoginButton];
         [self.QQLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(self.wechatLoginButton.mas_left).offset(-kSplite);
             make.width.offset(kButtonW);
             make.height.equalTo(self.wechatLoginButton.mas_width);
             make.top.equalTo(self.wechatLoginButton.mas_top);
         }];
         [self.QQLoginButton setImage:[UIImage imageNamed:@"login_qq_bg"] forState:UIControlStateNormal];
         [self.QQLoginButton addTarget:self action:@selector(goQQSDKLogin) forControlEvents:UIControlEventTouchUpInside];
         
     } else {
         
         self.QQLoginButton = [[UIButton alloc] init];
         [self.view addSubview:self.QQLoginButton];
         [self.QQLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(self.view.mas_centerX);
             make.width.offset(kButtonW);
             make.height.equalTo(self.QQLoginButton.mas_width);
             make.bottom.equalTo(self.view.mas_bottom).offset(-30);
         }];
         [self.QQLoginButton setImage:[UIImage imageNamed:@"login_qq_bg"] forState:UIControlStateNormal];
         [self.QQLoginButton addTarget:self action:@selector(goQQSDKLogin) forControlEvents:UIControlEventTouchUpInside];

     }
    
    self.tipLabel = [[UILabel alloc] init];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@150);
        make.height.equalTo(@50);//h
        make.centerX.equalTo(self.view.mas_centerX);//x
        make.bottom.equalTo(self.QQLoginButton.mas_top).offset(-10);//h
        
    }];
    
    [self.tipLabel setText:@"其他登录方式"];
    [self.tipLabel setTextColor:[UIColor meiHongSe]];
    [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
	
	UILabel *tipLable = [[UILabel alloc] init];
	[self.view addSubview:tipLable];
	[tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.centerX.equalTo(self.view.mas_centerX);
		make.top.equalTo(self.QQLoginButton.mas_bottom).offset(6);
		
	}];
	
	tipLable.userInteractionEnabled = YES;
	NSString *tipStr = @"“登录/注册” 表示您同意全美用户许可协议 & 隐私条款";
	UIFont *strFont = [UIFont systemFontOfSize:9.0];
	
	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr attributes:@{NSFontAttributeName:strFont}];
	
	[attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:strFont} range:NSMakeRange(0, 13)];
	
	[attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe], NSFontAttributeName:strFont, NSUnderlineStyleAttributeName:@(1)} range:NSMakeRange(13, 8)];
	
	[attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:strFont} range:NSMakeRange(21, 3)];
	
	[attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe], NSFontAttributeName:strFont, NSUnderlineStyleAttributeName:@(1)} range:NSMakeRange(24, 4)];
	
	tipLable.attributedText = attrStr;
	
	CGSize sizeOne = [[tipStr substringWithRange:NSMakeRange(0, 13)] sizeWithAttributes:@{NSFontAttributeName:strFont}];
	
	CGSize sizeTwo = [[tipStr substringWithRange:NSMakeRange(13, 8)] sizeWithAttributes:@{NSFontAttributeName:strFont}];
	
	CGSize sizeThree = [[tipStr substringWithRange:NSMakeRange(24, 4)] sizeWithAttributes:@{NSFontAttributeName:strFont}];
	
	UIView *viewOne = [[UIView alloc] init];
	[tipLable addSubview:viewOne];
	[viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.left.equalTo(tipLable.mas_left).offset(sizeOne.width);
		make.height.equalTo(tipLable.mas_height).offset(sizeOne.height);
		make.width.mas_equalTo(sizeTwo.width);
		make.top.equalTo(tipLable.mas_top);
		
	}];
	
	UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPolicyMethod)];
	[viewOne addGestureRecognizer:tapOne];
	
	UIView *viewTwo = [[UIView alloc] init];
	[tipLable addSubview:viewTwo];
	[viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.right.equalTo(tipLable.mas_right);
		make.height.equalTo(tipLable.mas_height).offset(sizeThree.height);
		make.width.mas_equalTo(sizeThree.width);
		make.top.equalTo(tipLable.mas_top);
		
	}];
	
	UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecurityMethod)];
	[viewTwo addGestureRecognizer:tapTwo];
	
}
/** 点击事件 */
- (void)tapPolicyMethod {
	
	DDQUserPolicyController *userPolicy = [[DDQUserPolicyController alloc] init];
	userPolicy.category_tag = 0;
	userPolicy.category_url = KUser_policy;
	[self.navigationController pushViewController:userPolicy animated:YES];
	
}

- (void)tapSecurityMethod {
	
	DDQUserPolicyController *userPolicy = [[DDQUserPolicyController alloc] init];
	userPolicy.category_tag = 1;
	userPolicy.category_url = KUser_security;
	[self.navigationController pushViewController:userPolicy animated:YES];
	
}
#pragma mark - button target action

-(void)findPasswordMethod {

    DDQBackPasswordViewController *backPassword = [[DDQBackPasswordViewController alloc] initWithNibName:@"DDQBackPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:backPassword animated:YES];
    
}

-(void)loginToApp {
    
    if ([self.inputPhoneNumField.text length] == 0 ||[self.inputPasswordField.text length] == 0) {
        
        if ([self.inputPhoneNumField.text length] == 0) {
            
            [self alertController:@"手机号不能为空"];
            
        }else {
            
            [self alertController:@"密码不能为空"];
            
        }
        
    } else {
        
        [self.hud show:YES];

        [self.netWork asyPOSTWithAFN_url:kLoginUrl andData:@[_inputPhoneNumField.text, _inputPasswordField.text] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                NSInteger code = code_error.code;
                
                if (code == 10 || code == 11 || code == 13 || code == 14) {
                    
                    switch (code) {
                            
                        case 10:
                            
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"手机号不符合要求" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        case 11:
                            
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"密码不符合要求" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        case 13:
                            
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"手机号不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        case 14:
                            
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"密码错误" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        default:
                            break;
                    }
                    
                } else {
                
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

                }
                
            } else {
                
                NSDictionary *dic = [DDQPublic nullDic:responseObjc];//判断是否为空
                //单例传值即可
                DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
                infoModel.userimg         = [dic valueForKey:@"userimg"];
                [[NSUserDefaults standardUserDefaults] setValue:[dic valueForKey:@"userid"] forKey:@"userId"];
                infoModel.isLogin           = YES;
//                self.baseTabBarC.selectedIndex = 0;
//                [UIApplication sharedApplication].keyWindow.rootViewController = self.baseTabBarC;
				[self.navigationController popViewControllerAnimated:YES];
				DDQBaseTabBarController *tabBar = (DDQBaseTabBarController *)self.tabBarController;
				[tabBar.mineView removeFromSuperview];
				
            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];

        }];
    
    }
    
}


-(void)goQQSDKLogin {
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];

    [_tencentOAuth authorize:permissions inSafari:NO];
}

-(void)goWeChatLogin {

    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

#pragma mark - tencent delegate
- (void)tencentDidLogin {
    
    [_tencentOAuth getUserInfo];
    self.openId = _tencentOAuth.openId;

}

-(void)getUserInfoResponse:(APIResponse *)response {

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic) {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *dic = response.jsonResponse;
                NSString *nickName = [dic valueForKey:@"nickname"];
                
                NSString *userImage = [dic valueForKey:@"figureurl_qq_1"];
                DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
                infoModel.userimg = userImage;
                infoModel.isLogin = YES;
                
                NSString *string = [SpellParameters getBasePostString];//八段字符串
                //转换过后的昵称
                NSData *data = [nickName dataUsingEncoding:NSUTF8StringEncoding];
                Byte *byteArray = (Byte *)[data bytes];
                NSMutableString *str = [[NSMutableString alloc] init];
                for(int i=0;i<[data length];i++) {
                    [str appendFormat:@"%d#",byteArray[i]];
                }
                
                NSString *dsfType = @"3";
                NSString *baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",string,dsfType,_openId,str,userImage];
                NSString *changeStr = [NSString stringWithString:[baseString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                const char * a_basePostString = [changeStr UTF8String];
                long int str_counter;
                if((strlen(a_basePostString) % 60) != 0){
                    str_counter = (long int)(strlen(a_basePostString) / 60) +1;
                } else {
                    str_counter = (long int)(strlen(a_basePostString) / 60);
                }
                long int total_counter = str_counter + 3;
                NSString *t_counter = [NSString stringWithFormat:@"%ld",total_counter];
                
                NSString *postString = @"p0=";
                postString = [postString stringByAppendingString:t_counter];
                postString = [postString stringByAppendingString:@"&p1=7000000004&p2=2"];
                for (int i = 0; i < str_counter; i++) {
                    postString = [postString stringByAppendingString:@"&p"];
                    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"%d",(i + 3)]];
                    postString = [postString stringByAppendingString:@"="];
                    
                    char sub_text[100];
                    memset(sub_text, 0, sizeof(sub_text));
                    //strncpy(sub_text,a_basePostString+(i * 60), 60);
                    
                    if (i == (str_counter - 1)) {
                        
                        strncpy(sub_text,a_basePostString+(i * 60), (strlen(a_basePostString) - (i * 60)));
                    }
                    else{
                        strncpy(sub_text,a_basePostString+(i * 60), 60);
                    }
                    
                    char ret[512];
                    memset(ret,0,sizeof(ret));
                    encryptedString(sub_text,ret);
                    
                    NSString *en_postString = [[NSString alloc] initWithCString:(const char*)ret encoding:NSUTF8StringEncoding];
                    en_postString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)en_postString, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                    
                    postString = [postString stringByAppendingString:en_postString];
                }
                
                //传给服务器
                NSMutableDictionary *postDic = [[PostData alloc] postData:postString AndUrl:kDSFRegisterUrl];
                //将这个字典解密
                NSString *getString = @"";
                for (int i=0; i<[[[postDic objectForKey:@"data"]objectForKey:@"cnt"] intValue]; i++) {
                    NSString *data_item = [[postDic objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%d",i]];
                    char ret_out[512];
                    memset(ret_out,0,sizeof(ret_out));
                    decryptedString([data_item cStringUsingEncoding:NSUTF8StringEncoding], ret_out);
                    
                    getString = [getString stringByAppendingString:[[NSString alloc] initWithCString:(const char*)ret_out encoding:NSUTF8StringEncoding]];
                }
                //将字符串装化为字典
                NSMutableDictionary *jsonDic = [[[SBJsonParser alloc] init] objectWithString:getString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    [self.hud removeFromSuperViewOnHide];
                    [[NSUserDefaults standardUserDefaults] setValue:[jsonDic valueForKey:@"userid"] forKey:@"userId"];
                    self.baseTabBarC.selectedIndex = 0;
                    [UIApplication sharedApplication].keyWindow.rootViewController = self.baseTabBarC;
                });
                
            });

        }
        
    }];
    
}


-(void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled){
        [self alertController: @"取消登录"];
    }else{
        [self alertController:@"登录失败"];
    }
}

-(void)tencentDidNotNetWork {
    
    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
    
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
