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
@interface AppDelegate ()<WXApiDelegate>

@property (strong,nonatomic) UITabBarController *tabBarController;
@property (strong,nonatomic) UINavigationController *mainNavigation;
@property (strong,nonatomic) UINavigationController *groupNavigation;
@property (strong,nonatomic) UINavigationController *preferenceNavigation;
@property (strong,nonatomic) UINavigationController *mineNavigation;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    item0.selectedImage = [[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [[UIImage imageNamed:@"全美_首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.title = @"首页";
    
    item1.selectedImage = [[UIImage imageNamed:@"美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"首页－美人圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = @"美人圈";
    
    item2.selectedImage = [[UIImage imageNamed:@"特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"首页_特惠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"特惠";
    
    item3.selectedImage = [[UIImage imageNamed:@"6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"wode-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title = @"我的";
    
    [self.window setRootViewController:_tabBarController];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];

    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(changeTabBarSelectedController:) name:@"change" object:nil];
    [defaultCenter addObserver:self selector:@selector(gestureChangeTabBarSelectedController:) name:@"change1" object:nil];
    [defaultCenter addObserver:self selector:@selector(groupChangSelectController:) name:@"changeGroup" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

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

    NSLog(@"-----%@",[APService registrationID]);
    
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
            self.window.rootViewController = self.tabBarController;
            //                    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
            
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
        _tabBarController.selectedViewController = _preferenceNavigation;
        [_tabBarController setSelectedIndex:2];
    }
}
- (void)groupChangSelectController:(NSNotification *)info {
    if ([[info.userInfo valueForKey:@"beautiful"]isEqualToString:@"morebeautiful"]) {
        _tabBarController.selectedViewController = _groupNavigation;
        [_tabBarController setSelectedIndex:1];

    }
    
}
-(void)gestureChangeTabBarSelectedController:(NSNotification *)info {
    if ([[info.userInfo valueForKey:@"secondname"] isEqualToString:@"more2"]) {
        _tabBarController.selectedViewController = _preferenceNavigation;
        [_tabBarController setSelectedIndex:2];
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
                    
                } else if([errorcodeString intValue] == 12) { //请求失败
                
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
                    
                } 
            //});
            
       // });
       
    } else {
    
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDQLoginViewController new]];
    }
}
#pragma mark - 检测网络连接状态
- (void) reachabilityChanged: (NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability *) curReach {
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {  //没有连接到网络就通知所有控制器
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStates" object:nil userInfo:@{@"states":[NSNumber numberWithBool:NO]}];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
