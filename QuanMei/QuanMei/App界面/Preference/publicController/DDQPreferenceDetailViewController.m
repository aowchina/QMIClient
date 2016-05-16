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
@property (nonatomic ,strong)UIButton *yuyueButton;

@property (nonatomic ,strong)NSMutableArray * preferenceDataArray;

@property (nonatomic ,strong)UIView *aview;

@property (strong,nonatomic) NSString *dj_string;

@property (strong,nonatomic) MBProgressHUD *hud;
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

- (void)loadView {
    [super loadView];
    
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
    //11-06
    _preferenceDataArray = [[NSMutableArray alloc]init];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    [self asyPreference];

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                
                [self asyPreference];
                [self.tableView.header endRefreshing];
                
            } else {
                
                [self.hud hide:YES];
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.tableView.header endRefreshing];
            }
        }];
        
    }];
    

    
}
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50);
//    _aview.frame =CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//11-06
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
    //    view.alpha = 0.5;
    
    [self.view addSubview:_aview];
    
    //12-22
    
    UIButton *yuyueButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    yuyueButton.frame = CGRectMake(0, 0, _aview.frame.size.width, _aview.frame.size.height);
    
    [yuyueButton setTintColor:[UIColor whiteColor]];
    _yuyueButton = yuyueButton;
    //11-06
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
    SLActivityModel *model = [[SLActivityModel alloc] init];
    model = self.preferenceDataArray.lastObject;
    [cell reloadWithActivityModel:model];
    cell.delegate = self;
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellName = self.cellCongigAry[indexPath.row];
    SLActivityModel *model = [[SLActivityModel alloc] init];
    model = self.preferenceDataArray.lastObject;
    return [NSClassFromString(cellName) heightWithActivityModel:model];
    
}

#pragma mark - ActivityDetailCellDelegate

- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedFriendID:(NSString *)friendID {
    //   进入猫友页面--- %@ ---",friendID);
}

- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedHospitalID:(NSString *)hospitalID HospitalName:(NSString *)name {
    
    SLActivityModel *model = [[SLActivityModel alloc] init];
    model = self.preferenceDataArray.lastObject;

    DDQHospitalHomePageController *pageController = [[DDQHospitalHomePageController alloc] init];
    pageController.hospital_id = hospitalID;
    pageController.hospital_name = name;
    [self.navigationController pushViewController:pageController animated:YES];
}

- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedID:(NSString *)priceID {
    [self alipaySignForPre];
}
-(void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell webDidFinshWithError:(NSError *)error {
    //   webView加载完毕");
}
#pragma mark - GCD
//10-28
//12-17
-(void)asyPreference {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        
        //加密
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:[NSString stringWithFormat:@"%@*%@",spellString,_activityID]];
        
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kTehui_detail];
        
        if ([[get_postDic objectForKey:@"errorcode"]intValue] == 11)
        {
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 30)];
            
            label.text = @"暂无活动.....";
            
            label.textAlignment = 1 ;
            
            label.textColor = [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1];
            
            [self.view addSubview:label];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"活动已结束" preferredStyle:0];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alertController addAction: action];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
            if([[get_postDic objectForKey:@"errorcode"]intValue] == 0)
            {
                //解密
                NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:get_postDic];
                
                //12-21
                NSDictionary * get_jsonDic = [DDQPublic nullDic:get_Dic];
                
                _preferenceDataArray = [[NSMutableArray alloc]init];
                SLActivityModel *model = [[SLActivityModel alloc]init];
                
                model.bimg   = [get_jsonDic objectForKey:@"bimg"];
                model.newval = [get_jsonDic objectForKey:@"newval"];
                model.oldval = [get_jsonDic objectForKey:@"oldval"];
                model.IdString = [get_jsonDic objectForKey:@"id"];
                model.hid    = [get_jsonDic objectForKey:@"hid"];
                model.hname  = [get_jsonDic objectForKey:@"hname"];
                model.himg   = [get_jsonDic objectForKey:@"himg"];
                model.dj     = [get_jsonDic objectForKey:@"dj"];
                self.dj_string = model.dj;
                model.intro  = [get_jsonDic objectForKey:@"intro"];
                
                //11-06
                //项目介绍html
                model.detail = [get_jsonDic objectForKey:@"detail"];
                model.width = get_jsonDic[@"img_width"];

                model.height = get_jsonDic[@"img_height"];
                //流程
                model.lc     = [get_jsonDic objectForKey:@"lc"];
                model.lcnote = [get_jsonDic objectForKey:@"lcnote"];
                model.users  = [get_jsonDic objectForKey:@"users"];
                //12-13
                model.name  = [get_jsonDic objectForKey:@"name"];
                
                [_preferenceDataArray addObject:model];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataSource = [_preferenceDataArray lastObject];
                    [self buildTableView];
                    [self.tableView.header endRefreshing];
                    [_yuyueButton setTitle:[NSString stringWithFormat:@"预约(定金%@元)",self.dataSource.dj]  forState:(UIControlStateNormal)];
                    [self.hud hide:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
    });
}
//10-28
#pragma mark - item target
-(void)goBackMainViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addDJ {
    [self alipaySignForPre];
}
-(void)alipaySignForPre {
    
    SLActivityModel *activityModel = [_preferenceDataArray firstObject];
    NSString *spellString             = [SpellParameters getBasePostString];
    NSString *post_baseString         = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], activityModel.IdString];
    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
    NSString *post_string             = [postEncryption stringWithPost:post_baseString];
    NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kOrder_addUrl];
    
    int errorcode = [post_dic[@"errorcode"] intValue];
    
    if (errorcode == 0) {
        
        DDQNewPayController *new_payC = [[DDQNewPayController alloc]init];
        
        NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
        new_payC.orderid = get_jsonDic[@"orderid"];
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:new_payC animated:YES];
        
    } else if(errorcode == 17) {
        
        DDQBoundTelViewController * boundTelVC = [[DDQBoundTelViewController alloc]init];
        
        boundTelVC.dj = activityModel.dj;
        boundTelVC.type = 1;
        boundTelVC.name = activityModel.name;
        boundTelVC.tid = activityModel.IdString;
        boundTelVC.price = activityModel.newval;
        
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:boundTelVC animated:YES];
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