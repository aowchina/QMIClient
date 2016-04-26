//
//  DDQLoginViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQLoginViewController.h"
#import "DDQMainViewController.h"
#import "DDQFirstRegisterViewController.h"
#import "AppDelegate.h"
#import "DDQGroupViewController.h"
#import "DDQMineViewController.h"
#import "DDQPreferenceViewController.h"
#import "DDQBackPasswordViewController.h"
#import "DDQResetViewController.h"

#import "DDQLoginSingleModel.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#import "WXApi.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

#import "DDQUserInfoModel.h"

#import "DDQPOSTEncryption.h"

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

@property (strong,nonatomic) UITabBarController *tabBarController;
@property (strong,nonatomic) UINavigationController *mainNavigation;
@property (strong,nonatomic) UINavigationController *groupNavigation;
@property (strong,nonatomic) UINavigationController *preferenceNavigation;
@property (strong,nonatomic) UINavigationController *mineNavigation;

@property (strong,nonatomic) NSDictionary *error_dic;
@property (strong,nonatomic) MBProgressHUD *hud;
@end

@implementation DDQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self layoutNavigationItem];
    [self layoutControllerView];
    
    self.spellString = [SpellParameters getBasePostString];//八段字符串
    DDQMainViewController *mainController = [[DDQMainViewController alloc] init];
    self.mainNavigation = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDQGroupViewController *groupController = [[DDQGroupViewController alloc] init];
    self.groupNavigation = [[UINavigationController alloc] initWithRootViewController:groupController];
    
    DDQPreferenceViewController *preferenceController = [[DDQPreferenceViewController alloc] init];
    self.preferenceNavigation = [[UINavigationController alloc] initWithRootViewController:preferenceController];
    
    DDQMineViewController *mineController = [[DDQMineViewController alloc] init];
    self.mineNavigation = [[UINavigationController alloc] initWithRootViewController:mineController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[_mainNavigation,_groupNavigation,_preferenceNavigation,_mineNavigation];
    
    UITabBar *tabBar = _tabBarController.tabBar;
    [tabBar setTintColor:[UIColor meiHongSe]];
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item0.selectedImage = [[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item0.image = [[UIImage imageNamed:@"全美_首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.title = @"首页";
    
    item1.selectedImage = [[UIImage imageNamed:@"美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"首页－美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = @"美人圈";
    
    item2.selectedImage = [[UIImage imageNamed:@"特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item2.image = [[UIImage imageNamed:@"首页_特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"特惠";
    
    item3.selectedImage = [[UIImage imageNamed:@"6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item3.image = [[UIImage imageNamed:@"wode-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title = @"我的";

    DDQResetViewController *resetVC = [DDQResetViewController new];
    resetVC.delegate = self;
}

-(void)resetVCNotificationMethod {

    [self alertController:@"密码重置成功"];
}

//取消响应事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        //网络连接无错误
        if (errorDic == nil) {
            
            
        } else {
            self.error_dic = errorDic;
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
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

-(void)goBackMianViewController {
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
    
    [self.inputPhoneNumField setPlaceholder:@"请输入登陆手机号"];
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
    
    [self.inputPasswordField setPlaceholder:@"请输入登陆密码"];
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
        kButtonW = self.view.frame.size.width*0.2;
        kSplite = 20;
    } else {
        kButtonW = self.view.frame.size.width*0.25;
        kSplite = 15;

    }
    
    //    self.sinaLoginButton = [[UIButton alloc] init];
    //    [self.view addSubview:self.sinaLoginButton];
    //    [self.sinaLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.wechatLoginButton.mas_right).offset(kSplite);
    //        make.width.offset(kButtonW);
    //        make.height.equalTo(self.wechatLoginButton.mas_width);
    //        make.top.equalTo(self.tipLabel.mas_bottom);
    //    }];
    //    [self.sinaLoginButton setImage:[UIImage imageNamed:@"login_sina_b"] forState:UIControlStateNormal];
    //    [self.sinaLoginButton addTarget:self action:@selector(goWeiBoLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //第三方登陆
    
     if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
         
         self.wechatLoginButton = [[UIButton alloc] init];
         [self.view addSubview:self.wechatLoginButton];
         [self.wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
             
             make.left.equalTo(self.view.mas_centerX);
             make.width.offset(kButtonW);
             make.height.equalTo(self.wechatLoginButton.mas_width);
             make.bottom.equalTo(self.view.mas_bottom).offset(-10);
             
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
             make.bottom.equalTo(self.view.mas_bottom).offset(-10);
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
        make.bottom.equalTo(self.QQLoginButton.mas_top).offset(-15);//h
        
    }];
    
    [self.tipLabel setText:@"其他登录方式"];
    [self.tipLabel setTextColor:[UIColor meiHongSe]];
    [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
   
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

        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.hud];
        [self.hud show:YES];
        self.hud.detailsLabelText = @"请稍等...";
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                   
           //网络连接无错误
           if (errorDic == nil) {
               
               //八段
               NSString *spellString = [SpellParameters getBasePostString];
               
               //参数
               NSString *postString = [NSString stringWithFormat:@"%@*%@*%@",spellString,_inputPhoneNumField.text,_inputPasswordField.text];
               
               //加密解密类
               DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
               
               //加密
               NSString *encryption = [postEncryption stringWithPost:postString];
               //post一小下
               NSMutableDictionary *get_serverDic = [[PostData alloc] postData:encryption AndUrl:kLoginUrl];
             
               if (get_serverDic != nil) {
                   
                   [self.hud hide:YES];
                   NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
                   
                   //11-06
                   //11-30-15
                   int num = [errorcode_string intValue];
                   if (num == 0){
                       //判断是否加密解密
                       NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
                       NSDictionary *dic = [DDQPublic nullDic:get_jsonDic];//判断是否为空
                       //单例传值即可
                       DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
                       infoModel.userimg         = [dic valueForKey:@"userimg"];
                       [[NSUserDefaults standardUserDefaults] setValue:[dic valueForKey:@"userid"] forKey:@"userId"];
                       infoModel.isLogin           = YES;
                       //                   [self.navigationController popViewControllerAnimated:YES];
                       [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
                       
                   } else if (num == 10) {
                       
                       [self alertController:@"手机号不符合要求"];
                   } else if (num == 11) {
                       
                       [self alertController:@"密码不符合要求"];
                   } else if (num == 13) {
                       
                       [self alertController:@"手机号不存在"];
                   } else if (num == 14){
                       
                       [self alertController:@"密码错误"];
                   } else {
                       
                       [self alertController:@"服务器繁忙"];
                   } 

               } else {
                   
                   [self.hud hide:YES];

                   [self alertController:@"服务器繁忙"];

               }
               
           } else {
               
               [self.hud hide:YES];
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
/**
 *  为单例类传值做准备
 *
 *  @param postDic 加密过后的json字典
 */
-(void)getJsonDic:(NSMutableDictionary *)postDic {
    
    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
    NSString *loginString = [postEncryption stringWithDic:postDic];
    
    NSMutableDictionary *loginDic = [[[SBJsonParser alloc] init] objectWithString:loginString];
    
    //单例传值即可
    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
    infoModel.userimg         = [loginDic valueForKey:@"userimg"];
    [[NSUserDefaults standardUserDefaults] setValue:[loginDic valueForKey:@"userid"] forKey:@"userId"];
    infoModel.isLogin           = YES;

}

-(void)goQQSDKLogin {
    //[self alertController:@"权限未到,敬请期待"];
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

-(void)goWeiBoLogin {

    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    [WeiboSDK sendRequest:request];
}

#pragma mark - tencent delegate
- (void)tencentDidLogin {
    [_tencentOAuth getUserInfo];
    self.openId = _tencentOAuth.openId;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.detailsLabelText = @"请稍候...";
}


-(void)getUserInfoResponse:(APIResponse *)response {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = response.jsonResponse;
        NSString *nickName = [dic valueForKey:@"nickname"];
        
        NSString *userImage = [dic valueForKey:@"figureurl_qq_1"];
    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
    infoModel.userimg = userImage;
    infoModel.isLogin = 1;

    
//
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
            
            [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
            
//            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}


-(void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled){
        [self alertController: @"取消登录"];
    }else{
        [self alertController:@"登录失败"];
    }
}

-(void)tencentDidNotNetWork {
    [self alertController:@"当前无网络连接"];
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
