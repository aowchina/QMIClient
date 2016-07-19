 //12-08
//  DDQPreferenceDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQPreferenceDetailViewController.h"
#import "DDQHospitalHomePageController.h"
#import "DDQBoundTelViewController.h"
#import "SLActivityDetailCellHeader.h"
#import "DDQNewPayController.h"
#import "SLActivityModel.h"

#import "Order.h"

#import "DataSigner.h"

#import <AlipaySDK/AlipaySDK.h>
//绑定手机
#import "DDQBoundTelViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApiObject.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"

typedef enum : NSUInteger {
    kWXFriend = 0,
    kWXCicrle,
    kQQShared,
} shared;

//cell配置信息
//11-06
NS_INLINE NSArray *SLGetCellCongfig() {
    return @[NSStringFromClass([SLActivityDetailHeaderImageCell class]),
             NSStringFromClass([SLActivityDetailPriceCell class]),
             NSStringFromClass([SLActivityDetailIntroduceCell class]),
             NSStringFromClass([SLActivityDetailProcessCell class]),
             NSStringFromClass([SLActivityDetailHospitalCell class]),
             NSStringFromClass([SLActivityDetailWebCell class]),
             
             ];
}
@interface DDQPreferenceDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SLActivityDetailCellDelegate,DataSigner,UIWebViewDelegate>

@property (nonatomic, readwrite, copy) NSString *activityID;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cellCongigAry;
@property (nonatomic, strong) SLActivityModel *dataSource;
@property (nonatomic ,strong) UIButton *yuyueButton;

@property (nonatomic ,strong) UIView *aview;

@property (nonatomic, strong) NSString *dj_string;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) ProjectNetWork *netWork;
@end

@implementation DDQPreferenceDetailViewController

- (instancetype)init {
    //  如果外部使用init方法创建，则进入 initWithActivityID 方法，activityID为空，崩溃（不允许外部使用init方法创建）
    return [self initWithActivityID:nil];
}

- (instancetype)initWithActivityID:(NSString *)activityID {
    
    if (activityID ==nil) {
        activityID =@"45";
    }
    
    //    如果activityID为空，就会崩溃
    NSParameterAssert(activityID);
    if (self = [super init]) {

        self.activityID = activityID;
        self.cellCongigAry = SLGetCellCongfig();
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackMainViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem  alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(showMoreFunction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //10-30
    self.navigationItem.title = @"特惠详情";
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"加载中...";
    
    //网络请求
    self.netWork = [ProjectNetWork sharedWork];
    [self asyPreference];
    
}

/** 点击更多 */
-(void)showMoreFunction {
    
    UIAlertController *more_alert = [UIAlertController alertControllerWithTitle:@"更多" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self layoutSharedView];
        
    }];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [more_alert addAction:first_action];
    [more_alert addAction:third_action];
    
    [self presentViewController:more_alert animated:YES completion:nil];
    
}
/** 布局分享页面 */
-(void)layoutSharedView {
    
    UIView *temp_view = [[UIView alloc] init];
    [self.view addSubview:temp_view];
    [temp_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(190);
        make.right.equalTo(self.view.mas_right);
    }];
    temp_view.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:temp_view atIndex:99];
    
    UILabel *title_label = [[UILabel alloc] init];
    [temp_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_view.mas_centerX);
        make.top.equalTo(temp_view.mas_top).offset(5);
        make.height.offset(30);
    }];
    title_label.text = @"分享";
    title_label.textColor = [UIColor backgroundColor];
    
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        
        //微信
        UIButton *WX_friend = [[UIButton alloc] init];
        [temp_view addSubview:WX_friend];
        [WX_friend mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(temp_view.mas_centerX);
            make.top.equalTo(title_label.mas_bottom).offset(10);
            make.height.offset(70);
            make.width.offset(70);
        }];
        [WX_friend setImage:[UIImage imageNamed:@"wechat_share_icon"] forState:UIControlStateNormal];
        WX_friend.tag = kWXFriend;
        [WX_friend addTarget:self action:@selector(sharedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *wx_friend = [[UILabel alloc] init];
        [temp_view addSubview:wx_friend];
        [wx_friend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(WX_friend.mas_centerX);
            make.top.equalTo(WX_friend.mas_bottom).offset(5);
            make.height.offset(20);
        }];
        wx_friend.text = @"微信";
        wx_friend.font = [UIFont systemFontOfSize:15.0f];
        wx_friend.textColor = [UIColor backgroundColor];
        
        
        //朋友圈
        UIButton *WX_circle = [[UIButton alloc] init];
        [temp_view addSubview:WX_circle];
        [WX_circle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(WX_friend.mas_left).offset(-20);
            make.top.equalTo(WX_friend.mas_top);
            make.height.offset(70);
            make.width.offset(70);
        }];
        [WX_circle setImage:[UIImage imageNamed:@"wechat_circle_share_icon"] forState:UIControlStateNormal];
        WX_circle.tag = kWXCicrle;
        [WX_circle addTarget:self action:@selector(sharedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *wx_circle = [[UILabel alloc] init];
        [temp_view addSubview:wx_circle];
        [wx_circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(WX_circle.mas_centerX);
            make.top.equalTo(WX_circle.mas_bottom).offset(5);
            make.height.offset(20);
        }];
        wx_circle.text = @"朋友圈";
        wx_circle.font = [UIFont systemFontOfSize:15.0f];
        wx_circle.textColor = [UIColor backgroundColor];
        
        //QQ
        UIButton *qq_share = [[UIButton alloc] init];
        [temp_view addSubview:qq_share];
        [qq_share mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(WX_friend.mas_right).offset(20);
            make.top.equalTo(WX_friend.mas_top);
            make.height.offset(70);
            make.width.offset(70);
        }];
        [qq_share setImage:[UIImage imageNamed:@"qq_share_icon"] forState:UIControlStateNormal];
        qq_share.tag = kQQShared;
        [qq_share addTarget:self action:@selector(sharedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *qq_shared = [[UILabel alloc] init];
        [temp_view addSubview:qq_shared];
        [qq_shared mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qq_share.mas_centerX);
            make.top.equalTo(qq_share.mas_bottom).offset(5);
            make.height.offset(20);
        }];
        qq_shared.text = @"QQ";
        qq_shared.font = [UIFont systemFontOfSize:15.0f];
        qq_shared.textColor = [UIColor backgroundColor];
        
        UIButton *button = [[UIButton alloc] init];
        [temp_view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qq_shared.mas_bottom).offset(5);
            make.height.offset(30);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
        }];
        [button addTarget:self action:@selector(hiddenSharedView:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setBackgroundColor:kRightColor];
        button.showsTouchWhenHighlighted = YES;
        button.layer.cornerRadius = 5.0f;

    } else {
        //QQ
        UIButton *qq_share = [[UIButton alloc] init];
        [temp_view addSubview:qq_share];
        [qq_share mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(temp_view.mas_centerX);
            make.top.equalTo(title_label.mas_bottom).offset(10);
            make.height.offset(70);
            make.width.offset(70);
        }];
        [qq_share setImage:[UIImage imageNamed:@"qq_share_icon"] forState:UIControlStateNormal];
        qq_share.tag = kQQShared;
        [qq_share addTarget:self action:@selector(sharedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *qq_shared = [[UILabel alloc] init];
        [temp_view addSubview:qq_shared];
        [qq_shared mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qq_share.mas_centerX);
            make.top.equalTo(qq_share.mas_bottom).offset(5);
            make.height.offset(20);
        }];
        qq_shared.text = @"QQ";
        qq_shared.font = [UIFont systemFontOfSize:15.0f];
        qq_shared.textColor = [UIColor backgroundColor];
        
        UIButton *button = [[UIButton alloc] init];
        [temp_view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qq_shared.mas_bottom).offset(5);
            make.height.offset(30);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
        }];
        [button addTarget:self action:@selector(hiddenSharedView:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor backgroundColor]];
        button.showsTouchWhenHighlighted = YES;
        button.layer.cornerRadius = 5.0f;
    }
}

-(void)hiddenSharedView:(UIButton *)button {
    
    [button.superview removeFromSuperview];
}

-(void)sharedButtonMethod:(UIButton *)button {
    
    if (button.tag == kWXFriend) {
               SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"全美";
        message.description = @"全美朋友圈分享测试";
        [message setThumbImage:[UIImage imageNamed:@"default_pic"]];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.163.com";
        
        message.mediaObject = ext;
        sendReq.message = message;
        [WXApi sendReq:sendReq];
        
        
    } else if (button.tag == kWXCicrle) {
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"全美";
        message.description = @"全美朋友圈分享测试";
        [message setThumbImage:[UIImage imageNamed:@"default_pic"]];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.163.com";
        
        message.mediaObject = ext;
        sendReq.message = message;
        [WXApi sendReq:sendReq];
    } else {
        
        
        TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:nil];
        
        
        NSString *utf8String = @"http://www.163.com";
        NSString *title = @"全美的分享";
        NSString *description = @"全美";
        NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:utf8String]
                                    title:title
                                    description:description
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
        QQApiSendResultCode sent1 = [QQApiInterface SendReqToQZone:req];
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    
}

#pragma mark - Builder
- (void)buildTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //10-30
    self.tableView.bounces = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 35)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    
    _aview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-35, self.view.bounds.size.width, 35)];
    
    _aview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65f];
    
    [self.view addSubview:_aview];
    
    
    UIButton *yuyueButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    yuyueButton.frame = CGRectMake(0, 0, _aview.frame.size.width, _aview.frame.size.height);
    
    [yuyueButton setTintColor:[UIColor whiteColor]];
    _yuyueButton = yuyueButton;
    
    //不要null
    if (self.dj_string == nil) {
        
        self.dj_string = @"";
        
    }
    
    NSString *djString = [NSString stringWithFormat:@"预约(定金%@元)",self.dj_string];
    [yuyueButton setTitle:djString forState:(UIControlStateNormal)];
    
    [_aview addSubview:yuyueButton];
    [yuyueButton addTarget:self action:@selector(addDJ) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellCongigAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellName = self.cellCongigAry[indexPath.row];
    [tableView registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellName];
    SLActivityDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    [cell reloadWithActivityModel:self.dataSource];
    cell.delegate = self;
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellName = self.cellCongigAry[indexPath.row];
    return [NSClassFromString(cellName) heightWithActivityModel:self.dataSource];
    
}

#pragma mark - ActivityDetailCellDelegate
- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedHospitalID:(NSString *)hospitalID HospitalName:(NSString *)name {
 
    DDQHospitalHomePageController *pageController = [[DDQHospitalHomePageController alloc] init];
    pageController.hospital_id = hospitalID;
    pageController.hospital_name = name;
    [self.navigationController pushViewController:pageController animated:YES];
    
}

- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedID:(NSString *)priceID {
    
    [self alipaySignForPre];
    
}

- (void)didSelectedRemakeButtonInCell:(SLActivityDetailBaseCell *)cell {

    if (self.dataSource.isClicked) {
        
        self.dataSource.isClicked = NO;
        [self.tableView reloadData];
        
    } else {
    
        self.dataSource.isClicked = YES;
        [self.tableView reloadData];
        
    }
    
}

#pragma mark - GCD

-(void)asyPreference {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kTehui_detail andData:@[_activityID] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (!code_error) {
            
            NSDictionary * get_jsonDic = [DDQPublic nullDic:responseObjc];
            
            self.dataSource = [SLActivityModel mj_objectWithKeyValues:get_jsonDic];
            
            self.dataSource.isClicked = NO;
            
            self.dj_string = self.dataSource.dj;
            
            [self buildTableView];
            
            [_yuyueButton setTitle:[NSString stringWithFormat:@"预约(定金%@元)",self.dataSource.dj]  forState:(UIControlStateNormal)];
            
            [self.hud hide:YES];

        } else {
        
            [self.hud hide:YES];
            
            NSInteger code = [code_error code];
            if (code == 11) {
                
                [self alertController:@"当前活动已结束"];
                
            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];

    }];
    
}

#pragma mark - item target
-(void)goBackMainViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)addDJ {
    
    [self alipaySignForPre];
    
}

/** 这里是为了判断他有没有绑定手机 */
-(void)alipaySignForPre {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kOrder_addUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], self.dataSource.id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (!code_error) {
            
            [self.hud hide:YES];
            
            DDQNewPayController *new_payC = [[DDQNewPayController alloc]init];
            self.navigationController.hidesBottomBarWhenPushed = YES;
            
            new_payC.orderid = responseObjc[@"orderid"];
            [self.navigationController pushViewController:new_payC animated:YES];
            
        } else {
        
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            if (code == 17) {
                
                DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
                
                boundTelVC.dj = self.dataSource.dj;
                boundTelVC.type = 1;
                boundTelVC.name = self.dataSource.name;
                boundTelVC.tid = self.dataSource.id;
                boundTelVC.price = self.dataSource.newval;
                
                self.navigationController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:boundTelVC animated:YES];

            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
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