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
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "DDQUserInfoModel.h"
#import "Reachability.h"
#import "DDQBaseTabBarController.h"
#import "IQKeyboardManager.h"
#import "DDQMyWalletViewController.h"
#import "ProjectNetWork.h"
#import "DDQPreferenceDetailViewController.h"
@interface AppDelegate ()<WXApiDelegate>

/** 单例TabBarController */
@property ( strong, nonatomic) DDQBaseTabBarController *baseTabBarC;
/** 网络请求 */
@property ( strong, nonatomic) AFHTTPSessionManager *session_manager;
/** 提示用的hud */
@property ( strong, nonatomic) MBProgressHUD *alert_hud;

@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	
	
	//注册通知
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(changeTabBarSelectedController:) name:@"change" object:nil];
	[defaultCenter addObserver:self selector:@selector(gestureChangeTabBarSelectedController:) name:@"change1" object:nil];
	[defaultCenter addObserver:self selector:@selector(groupChangSelectController:) name:@"changeGroup" object:nil];
	[defaultCenter addObserver:self selector:@selector(mineChangSelectController:) name:@"minechange" object:nil];
	
	
	//短信注册
	[SMSSDK registerApp:kShardAppKey
			 withSecret:kShardSecret];
	
	//微信注册
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
	
	//init方法
	[self checkUserState];
	
	//设置根控制器
	self.baseTabBarC = [[DDQBaseTabBarController alloc] init];
	[self.window setRootViewController:self.baseTabBarC];
	[self.window makeKeyAndVisible];
	self.window.backgroundColor = [UIColor whiteColor];
	
	//键盘遮挡解决办法
	IQKeyboardManager *keyboard_manager = [IQKeyboardManager sharedManager];
	keyboard_manager.enable = YES;
	keyboard_manager.shouldResignOnTouchOutside = YES;
	keyboard_manager.shouldToolbarUsesTextFieldTintColor = YES;
	keyboard_manager.enableAutoToolbar = NO;
	
	//检测网络变化情况
	[[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"changeNet" object:nil userInfo:note.userInfo];
		
	}];
	
	[[Reachability reachabilityForInternetConnection] startNotifier];
	
	//配置session
	self.session_manager = [AFHTTPSessionManager manager];
	self.session_manager.responseSerializer = [AFJSONResponseSerializer serializer];
	self.session_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
	
	self.netWork = [ProjectNetWork sharedWork];
	return YES;
}

/** 清零badge */
- (void)applicationDidBecomeActive:(UIApplication *)application {
	
	[application setApplicationIconBadgeNumber:0];
	[APService setBadge:0];
	
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

/** 注册apns */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	[APService registerDeviceToken:deviceToken];
	ProjectNetWork *net = [ProjectNetWork sharedWork];
	[net asy_netWithUrlString:kJPush_url ParamArray:@[[APService registrationID]] Success:^(id source, NSError *analysis_error) {
		
		
	} Failure:^(NSError *net_error) {
		
		[MBProgressHUD myCustomHudWithView:self.window andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
		
	}];
	
	
}

/** 接收到apns:注这是7.0后的方法 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	
	[APService handleRemoteNotification:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
	
	NSString *type = userInfo[@"type"];
	NSString *id_str = userInfo[@"id"];
	
	if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
		
		if ([type isEqualToString:@"tehui"]) {
			
			UITabBarController *tabC = (UITabBarController *)self.window.rootViewController;
			UINavigationController *navigation = tabC.selectedViewController;
			DDQPreferenceDetailViewController *preferenceDetailC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:id_str];
			preferenceDetailC.hidesBottomBarWhenPushed = YES;
			[navigation pushViewController:preferenceDetailC animated:YES];
			
		}
		
	}
	
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
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"notifify" object:nil userInfo:@{@"errorcode":[NSNumber numberWithInt:resp.errCode]}];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"lesson" object:nil userInfo:@{@"errorcode":[NSNumber numberWithInt:resp.errCode]}];
		
	} else {
		[self getWeiXinCodeFinishedWithResp:resp];
	}
}


- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp {
	
	if (resp.errCode == 0){
		
		if ([resp isKindOfClass:[SendAuthResp class]]) {
			
			SendAuthResp *aresp = (SendAuthResp *)resp;
			
			[self getAccessTokenWithCode:aresp.code];
			
		}
		
	}
	
}

/** 获取accessToken和openid */
- (void)getAccessTokenWithCode:(NSString *)code {
	
	NSMutableDictionary *param_dic = [NSMutableDictionary dictionary];
	[param_dic setValue:kWeChatKey forKey:@"appid"];
	[param_dic setValue:kWeChatSecret forKey:@"secret"];
	[param_dic setValue:code forKey:@"code"];
	[param_dic setValue:@"authorization_code" forKey:@"grant_type"];
	
	self.alert_hud = [[MBProgressHUD alloc] initWithWindow:self.window];
	[self.window addSubview:self.alert_hud];
	self.alert_hud.detailsLabelText = @"请稍候...";
	[self.alert_hud show:YES];
	
	[self.session_manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token?" parameters:param_dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		
		if (responseObject) {
			
			if ([responseObject objectForKey:@"errcode"]){
				
				[self.alert_hud hide:YES];
				
			} else {
				
				[self getUserInfoWithAccessToken:[responseObject objectForKey:@"access_token"] andOpenId:[responseObject objectForKey:@"openid"]];
			}
			
		} else {
			
			[self.alert_hud hide:YES];
			[MBProgressHUD myCustomHudWithView:self.window andCustomText:@"微信登录失败" andShowDim:NO andSetDelay:YES andCustomView:nil];
			
		}
		
	} failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
		
		[self.alert_hud hide:YES];
		[MBProgressHUD myCustomHudWithView:self.window andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
		
	}];
	
}

/** 获取微信用户信息 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId {
	
	NSMutableDictionary *param_dic = [NSMutableDictionary dictionary];
	[param_dic setValue:accessToken forKey:@"access_token"];
	[param_dic setValue:openId forKey:@"openid"];
	
	[self.session_manager GET:@"https://api.weixin.qq.com/sns/userinfo?" parameters:param_dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		
		if (responseObject) {
			
			//获取需要的数据
			NSString *userImage = [responseObject valueForKey:@"headimgurl"];
			NSString *change_userimage = [userImage substringToIndex:[userImage length]-1];
			NSString *post_userimage = [NSString stringWithFormat:@"%@%d",change_userimage,64];
			NSString *nickName = [responseObject valueForKey:@"nickname"];
			
			//转换过后的昵称
			NSData *data = [nickName dataUsingEncoding:NSUTF8StringEncoding];
			Byte *byteArray = (Byte *)[data bytes];
			NSMutableString *str = [[NSMutableString alloc] init];
			for(int i=0;i<[data length];i++) {
				[str appendFormat:@"%d#",byteArray[i]];
			}
			
			NSString *dsfType = @"1";
			
			[self.netWork asyPOSTWithAFN_url:kDSFRegisterUrl andData:@[dsfType,openId,str,post_userimage] andSuccess:^(id responseObjc, NSError *code_error) {
				
				if (!code_error) {
					
					DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
					infoModel.userimg = [responseObjc valueForKey:@"userimg"];
					infoModel.userName = nickName;
					infoModel.isLogin = YES;
					
					[[NSUserDefaults standardUserDefaults] setValue:[responseObjc valueForKey:@"userid"] forKey:@"userId"];
					self.baseTabBarC.selectedIndex = 0;
					self.window.rootViewController = self.baseTabBarC;
					
				} else {
					
					[MBProgressHUD myCustomHudWithView:self.window andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
					
				}
				
			} andFailure:^(NSError *error) {
				
				[self.alert_hud hide:YES];
				[MBProgressHUD myCustomHudWithView:self.window andCustomText:@"微信登录失败" andShowDim:NO andSetDelay:YES andCustomView:nil];
				
			}];
			
		} else {
			
			[self.alert_hud hide:YES];
			[MBProgressHUD myCustomHudWithView:self.window andCustomText:@"微信登录失败" andShowDim:NO andSetDelay:YES andCustomView:nil];
			
		}
		
	} failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
		
		[self.alert_hud hide:YES];
		[MBProgressHUD myCustomHudWithView:self.window andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
		
	}];
	
	
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
/** 跳转到特惠 */
-(void)changeTabBarSelectedController:(NSNotification *)info {
	
	if ([[info.userInfo valueForKey:@"firstname"] isEqualToString:@"more1"]) {
		
		[self.baseTabBarC setSelectedIndex:2];
		
	}
	
}

/** 跳转到小组 */
- (void)groupChangSelectController:(NSNotification *)info {
	
	if ([[info.userInfo valueForKey:@"beautiful"]isEqualToString:@"morebeautiful"]) {
		
		[self.baseTabBarC setSelectedIndex:1];
		
	}
	
}

/** 跳转到特惠 */
-(void)gestureChangeTabBarSelectedController:(NSNotification *)info {
	
	if ([[info.userInfo valueForKey:@"secondname"] isEqualToString:@"more2"]) {
		
		[self.baseTabBarC setSelectedIndex:2];
		
	}
	
}

/** 跳转到我的 */
- (void)mineChangSelectController:(NSNotification *)info {
	
	if ([[info.userInfo valueForKey:@"mine"] isEqualToString:@"mine"]) {
		
		[self.baseTabBarC setSelectedIndex:3];
		
	}
	
}


#pragma mark - 调init方法
-(void)checkUserState {
	
	DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]) {//当useid不为空的时候调用
		
		//调用init方法
		NSString *spellString = [SpellParameters getBasePostString];
		NSString *baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
		DDQPOSTEncryption *post_encryption = [[DDQPOSTEncryption alloc] init];
		NSString *postString = [post_encryption stringWithPost:baseString];
		NSMutableDictionary *postDic = [[PostData alloc] postData:postString AndUrl:kInitUrl];
		
		if (postDic) {
			
			NSString *errorcodeString = [postDic valueForKey:@"errorcode"];
			
			if ([errorcodeString intValue] == 0) {//请求成功后
				
				NSString *jsonString = [post_encryption stringWithDic:postDic];
				
				NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
				id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
				
				//用单例类记录用户信息
				
				infoModel.isLogin = YES;
				infoModel.userimg = [json valueForKey:@"userimg"];
				infoModel.userid  = [json valueForKey:@"userid"];
				
			} else if([errorcodeString intValue] == 12) {//请求失败
				
				[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userId"];
				infoModel.isLogin = NO;
				
			} else {
				
				[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userId"];
				infoModel.isLogin = NO;
				
			}
			
		} else {
			
			[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userId"];
			infoModel.isLogin = NO;
			
		}
		
	} else {
		
		[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"userId"];
		
		infoModel.isLogin = NO;
		
	}
	
}


@end
