//
//  DDQSetViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/2.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSetViewController.h"
#import "DDQMainViewController.h"
#import "DDQUserProtocolViewController.h"
#import "DDQLoginViewController.h"
#import "DDQSetControlHeader.h"
#import "DDQUserInfoModel.h"


@interface DDQSetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UITableView *mainTableView;
@property (strong,nonatomic) NSArray *falseDataArray;

@end

@implementation DDQSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}


-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.2)];
    
    UIButton *button = [[UIButton alloc] init];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
//        if (kScreenWidth < 414) {
//            make.width.equalTo(view.mas_width).with.multipliedBy(0.4);
//            make.height.equalTo(view.mas_height).with.multipliedBy(0.5);
//        } else {
//            make.width.equalTo(view.mas_width).with.multipliedBy(0.3);
//            make.height.equalTo(view.mas_height).with.multipliedBy(0.4);
//        }
    }];
    [button setBackgroundColor:[UIColor meiHongSe]];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(popMainViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.mainTableView setTableFooterView:view];
}

-(void)popMainViewController {
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self requestData];
            
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

- (void)requestData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kGetOut_Url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                
                //首先移除掉保存的userid
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                
                //然后改变model类的登陆属性
                DDQUserInfoModel *userInfo = [DDQUserInfoModel singleModelByValue];
                userInfo.isLogin = NO;
                
                //最后退回到首页
                DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                
            } else if (num == 13) {
                
                [self alertController:@"用户未登录"];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });
}


#pragma mark - delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return 2;
    }else {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
        static NSString *identifierDetail = @"cellDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierDetail];
            
        }else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    //设置cell文字
    if (indexPath.section == 0) {
        cell.textLabel.text = self.falseDataArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = self.falseDataArray[2];
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *currentVersion = [NSString stringWithFormat:@"当前版本%@",version];
        cell.detailTextLabel.text = currentVersion;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        cell.textLabel.text = self.falseDataArray[3];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        DDQMessageSetViewController *setVC = [[DDQMessageSetViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        DDQFeedbackController *feedVC = [[DDQFeedbackController alloc] init];
        [self.navigationController pushViewController:feedVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
       //判断是否提示用户更新应用
        if ([self compareVersion]) {
            MBProgressHUD *hud = [[MBProgressHUD alloc] init];
            hud.labelText = @"已经是最新版本";
            [hud show:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已有新版本，请去App Store更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往App Store", nil];
            alertView.delegate = self;
            [alertView show];
        }
    }else {
        DDQUserProtocolViewController *protocolVC = [[DDQUserProtocolViewController alloc] init];
        [self.navigationController pushViewController:protocolVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.height*0.1;
}
#pragma mark - lazy load
-(NSArray *)falseDataArray{
    if (!_falseDataArray) {
        _falseDataArray = [NSArray arrayWithObjects:@"消息设置",@"联系我们",@"应用版本",@"用户协议", nil];
    }
    return _falseDataArray;
}
/**
 * @ author SuperLian
 *
 * @ date   15/12/4
 *
 * @ func   比较版本号
 */

- (BOOL)compareVersion {
    //    最新版本号从服务器获得（目前取的是当前的）
    NSString *key = @"CFBundleVersion";
    //上一次的使用版本(存储在沙盒中的版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    //当前软件的版本号(从Info.plist中获得)
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {

    }else {
//        NSString *str = [NSString stringWithFormat:
//                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=%d",
//                         myAppID ];
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
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
