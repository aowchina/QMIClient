//
//  AppDelegate.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/8/31.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "AppDelegate.h"
#import "DDQMainViewController.h"
#import "DDQGroupViewController.h"
#import "DDQPreferenceViewController.h"
#import "DDQLoginViewController.h"
#import "DDQMineViewController.h"
#import "DDQOrderDetailViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "DDQUserInfoModel.h"
#import "Reachability.h"
#import "DDQBaseTabBarController.h"
#import "IQKeyboardManager.h"
#import "DDQQiandaoView.h"
#import "DDQMyWalletViewController.h"
@interface AppDelegate ()<WXApiDelegate,QiandaoDelegate>

@property ( strong, nonatomic) DDQBaseTabBarController *baseTabBarC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.baseTabBarC = [DDQBaseTabBarController sharedController];
    [self.window setRootViewController:self.baseTabBarC];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(changeTabBarSelectedController:) name:@"change" object:nil];
    [defaultCenter addObserver:self selector:@selector(gestureChangeTabBarSelectedController:) name:@"change1" object:nil];
    [defaultCenter addObserver:self selector:@selector(groupChangSelectController:) name:@"changeGroup" object:nil];
    [defaultCenter addObserver:self selector:@selector(mineChangSelectController:) name:@"minechange" object:nil];


    [SMSSDK registerApp:kShardAppKey
              withSecret:kShardSecret];
    
    [WXApi registerApp:kWeChatKey];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    //监听非APNs消息
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    
    [self checkUserState];
    
    IQKeyboardManager *keyboard_manager = [IQKeyboardManager sharedManager];
    keyboard_manager.enable = YES;
    keyboard_manager.shouldResignOnTouchOutside = YES;
    keyboard_manager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboard_manager.enableAutoToolbar = NO;
    
    return YES;
}

#pragma mark - 处理推送的Delegate
//记录点赞的人数
- (void)networkDidReceiveMessage:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];

    int zan_count = 1;
    int reply_count = 1;
    
    if ([userInfo[@"content"] isEqualToString:@"您收到一个赞~"]) {
        
        int temp_count = zan_count++;
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd "];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        //把日期存起来
        NSString *temp_string = [[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"];
        
        if (temp_string == nil) {
            
            //记录时间
            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"zanData"];

        } else {
       
            //移除上一次记录的时间，并存储当前时间
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanData"];
            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"zanData"];

        }
        
        //把消息次数存起来
        
        NSString *temp_stringTwo = [[NSUserDefaults standardUserDefaults] valueForKey:@"zanCount"];
        
        if (temp_stringTwo == nil) {
            
            //记录次数
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",temp_count] forKey:@"zanCount"];
            
        } else {
        
            //将上一次记录的次数取出来，再加上这一次的次数。然后再存进去
            NSString *temp_string = [[NSUserDefaults standardUserDefaults] valueForKey:@"zanCount"];
            int lastCount = [temp_string intValue];
            int thisCount = lastCount + temp_count;
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanCount"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",thisCount] forKey:@"zanCount"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:nil userInfo:@{@"zan":[NSNumber numberWithInt:temp_count]}];
        
    } else if ([userInfo[@"content"] isEqualToString:@"您收到一条回复~"]) {
    
        int temp_count = reply_count++;
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd "];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        //把日期存起来
        
        NSString *temp_string = [[NSUserDefaults standardUserDefaults] valueForKey:@"replyData"];
        
        if (temp_string == nil) {
            
            //记录时间
            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"replyData"];
            
        } else {
            
            //移除上一次记录的时间，并存储当前时间
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyData"];
            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"replyData"];
            
        }
        
        //把消息次数存起来
        
        NSString *temp_stringTwo = [[NSUserDefaults standardUserDefaults] valueForKey:@"replyCount"];
        
        if (temp_stringTwo == nil) {
            
            //记录次数
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",temp_count] forKey:@"replyCount"];
            
        } else {
            
            //将上一次记录的次数取出来，再加上这一次的次数。然后再存进去
            NSString *temp_string = [[NSUserDefaults standardUserDefaults] valueForKey:@"replyCount"];
            int lastCount = [temp_string intValue];
            int thisCount = lastCount + temp_count;
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyCount"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",thisCount] forKey:@"replyCount"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:nil userInfo:@{@"reply":[NSNumber numberWithInt:temp_count]}];

    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];

        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:@"账号已在其他设备登录"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //
    NSString *spellString = [SpellParameters getBasePostString];

    NSString *baseString = [NSString stringWithFormat:@"%@*%@",spellString,[APService registrationID]];
    
    DDQPOSTEncryption *post_encryption = [[DDQPOSTEncryption alloc] init];

    NSString *postString = [post_encryption stringWithPost:baseString];

    NSMutableDictionary *postDic = [[PostData alloc] postData:postString AndUrl:kJPush_url];
    
    if ([postDic[@"errorcode"] intValue] == 0) {
        
        [APService registerDeviceToken:deviceToken];
    
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 从客户端回调到APP
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        }];
    }
  
    return   [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self] || (YES) ;
}


#pragma mark - 微信和微博的代理方法
- (void)onResp:(BaseResp*)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifify" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lesson" object:nil];

    } else {
        [self getWeiXinCodeFinishedWithResp:resp];
    }
}


- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp {
    if (resp.errCode == 0)
    {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *aresp = (SendAuthResp *)resp;
            
            [self getAccessTokenWithCode:aresp.code];
        } 
        
    }else if (resp.errCode == -4){
        //statusCodeLabel.text = @"用户拒绝";
    }else if (resp.errCode == -2){
        //statusCodeLabel.text = @"用户取消";
    }
}


- (void)getAccessTokenWithCode:(NSString *)code {
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeChatKey,kWeChatSecret,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"]){
                    
                } else {
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}

- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //        dispatch_async(dispatch_get_main_queue(), ^{
    
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //获取需要的数据
        DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
        NSString *userImage = [dict valueForKey:@"headimgurl"];
        NSString *change_userimage = [userImage substringToIndex:[userImage length]-1];
        NSString *post_userimage = [NSString stringWithFormat:@"%@%d",change_userimage,64];
        NSString *nickName = [dict valueForKey:@"nickname"];
        
        infoModel.userimg = post_userimage;
        infoModel.userName = nickName;
        infoModel.isLogin = 1;
        
        NSString *string = [SpellParameters getBasePostString];//八段字符串
        //转换过后的昵称
        NSData *data = [nickName dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray = (Byte *)[data bytes];
        NSMutableString *str = [[NSMutableString alloc] init];
        for(int i=0;i<[data length];i++) {
            [str appendFormat:@"%d#",byteArray[i]];
        }
        
        NSString *dsfType = @"1";
        NSString *baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",string,dsfType,openId,str,post_userimage];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *postString = [postEncryption stringWithPost:baseString];
        
        //传给服务器
        NSMutableDictionary *postDic = [[PostData alloc] postData:postString AndUrl:kDSFRegisterUrl];
        if ([postDic[@"errorcode"] intValue] == 0) {
            //将这个字典解密
            NSString *getString = [postEncryption stringWithDic:postDic];
            
            //将字符串装化为字典
            NSMutableDictionary *jsonDic = [[[SBJsonParser alloc] init] objectWithString:getString];
            infoModel.userid    = [jsonDic valueForKey:@"userid"];
            infoModel.isLogin   = 1;
            [[NSUserDefaults standardUserDefaults] setValue:[jsonDic valueForKey:@"userid"] forKey:@"userId"];
            self.window.rootViewController = self.baseTabBarC;
            //                    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
            [self outQiandao];

        } else {
            
        }
        
        if ([dict objectForKey:@"errcode"]){
            //AccessToken失效
            [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"WeiXinRefreshToken"]];
        }else{
            
        }
    }
    //        });
    //    });
}

- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeChatKey,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"]){
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
}




#pragma mark - gesture and target seletedItem
-(void)changeTabBarSelectedController:(NSNotification *)info {
    
    if ([[info.userInfo valueForKey:@"firstname"] isEqualToString:@"more1"]) {
        
        [self.baseTabBarC setSelectedIndex:2];
        
    }
    
}
- (void)groupChangSelectController:(NSNotification *)info {
    
    if ([[info.userInfo valueForKey:@"beautiful"]isEqualToString:@"morebeautiful"]) {
        
        [self.baseTabBarC setSelectedIndex:1];

    }
    
}
-(void)gestureChangeTabBarSelectedController:(NSNotification *)info {
    
    if ([[info.userInfo valueForKey:@"secondname"] isEqualToString:@"more2"]) {
        
        [self.baseTabBarC setSelectedIndex:2];
        
    }
    
}
- (void)mineChangSelectController:(NSNotification *)info {
    
    if ([[info.userInfo valueForKey:@"mine"] isEqualToString:@"mine"]) {
        
        [self.baseTabBarC setSelectedIndex:3];
        
    }
}


#pragma mark - 调init方法
-(void)checkUserState {

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]) {//当useid和cuserid不为空的时候调用
        
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //最好别在AppDelegate开子线程
        
            //调用init方法
            NSString *spellString = [SpellParameters getBasePostString];
            NSString *baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
            DDQPOSTEncryption *post_encryption = [[DDQPOSTEncryption alloc] init];
            NSString *postString = [post_encryption stringWithPost:baseString];
            NSMutableDictionary *postDic = [[PostData alloc] postData:postString AndUrl:kInitUrl];
           // dispatch_async(dispatch_get_main_queue(), ^{
        
        if (postDic != nil) {
            
            NSString *errorcodeString = [postDic valueForKey:@"errorcode"];
            
            if ([errorcodeString intValue] == 0) {//请求成功后
                
                NSString *jsonString = [post_encryption stringWithDic:postDic];
                SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
                NSMutableDictionary *jsonDic = [jsonParser objectWithString:jsonString];
                
                //用单例类记录用户信息
                DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
                
                infoModel.isLogin        = YES;
                infoModel.userimg        = [jsonDic valueForKey:@"userimg"];
                infoModel.userid         = [jsonDic valueForKey:@"userid"];
                /**
                 *  自动签到
                 */
                [self outQiandao];

            } else if([errorcodeString intValue] == 12) { //请求失败
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
                
            }

        } else {
        
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
            
        }
        
        //});
        
       // });
       
    } else {
    
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
    }
}

- (void)outQiandao {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *poststr = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:poststr];
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kQD_Url];
        
        NSString *str = get_postDic[@"errorcode"];
        int num = [str intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (num == 0) {
                
                NSString *jifen = [postEncryption stringWithDic:get_postDic];
                
                DDQQiandaoView *qiandao_view = [[DDQQiandaoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                qiandao_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
                qiandao_view.delegate = self;
                qiandao_view.huodefenshu.text = [NSString stringWithFormat:@"恭喜获得积分:+%@",jifen];
                [[UIApplication sharedApplication].keyWindow addSubview:qiandao_view];
                
            } else if (num == 13) {
            } else if (num == 15) {
            } else if (num == 11 || num == 12) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
                
            } else {
            }
        });
        
    });
    
    
}

- (void)qiandao_view:(DDQQiandaoView *)view {
    
    [view removeFromSuperview];
    
}

- (void)qiandao_viewSelected:(DDQQiandaoView *)view {
    
    [view removeFromSuperview];
    DDQMyWalletViewController *myWallet = [[DDQMyWalletViewController alloc] init];
    myWallet.hidesBottomBarWhenPushed = YES;
    if ([self.window.rootViewController isKindOfClass:[DDQBaseTabBarController class]]) {
        
        UIViewController *vc = self.baseTabBarC.selectedViewController;
        [vc.navigationController pushViewController:myWallet animated:YES];
        
    }

}

@end
