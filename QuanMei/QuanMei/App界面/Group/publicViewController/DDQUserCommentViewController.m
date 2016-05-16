
//
//  DDQUserCommentViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/16.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserCommentViewController.h"
#import "DDQReplayViewController.h"
#import "DDQMoreCommentViewController.h"
#import "DDQOthersViewController.h"
#import "DDQHeaderSingleModel.h"
#import "DDQCommentModel.h"
#import "DDQReplyModel.h"
#import "DDQCommentFirstCell.h"
#import "DDQCommentSecondCell.h"

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

@interface DDQUserCommentViewController ()<UITableViewDelegate,UITableViewDataSource,SecondCommentCellDelegate,TencentSessionDelegate,TCAPIRequestDelegate>

/**
 *  主表示图
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (strong,nonatomic) DDQHeaderSingleModel *singleModel;

@property (strong,nonatomic) DDQCommentModel *header_model;

@property (assign,nonatomic) CGFloat newRowHeight;

@property (assign,nonatomic) CGFloat floor_height;

@property (assign,nonatomic) CGFloat celltop_H;
@property (assign,nonatomic) CGFloat cellbottom_H;


@property (strong,nonatomic) NSMutableArray *cell_sourceArray;


@property (assign,nonatomic) shared type;

@end

@implementation DDQUserCommentViewController

static int num = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.singleModel       = [DDQHeaderSingleModel singleModelByValue];
    self.cell_sourceArray  = [NSMutableArray array];

    /**
     发个小通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePicSize:) name:@"changeSize" object:nil];
    
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem  alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(showMoreFunction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)showMoreFunction {
    
    UIAlertController *more_alert = [UIAlertController alertControllerWithTitle:@"更多" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self layoutSharedView];
    }];
    
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //调用点赞接口
            //八段
            NSString *spellString = [SpellParameters getBasePostString];
            
            //拼参数
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"1",self.header_model.iD];
            
            //加密
            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
            NSString *post_encryption = [post stringWithPost:post_baseString];
            
            //传
            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kSc_addUrl];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //判断errorcode
                NSString *errorcode = post_dic[@"errorcode"];
                int num = [errorcode intValue];
                if (num == 0) {
                    
                    [self alertController:@"收藏成功"];
                    
                } else if (num == 14) {
                    
                    [self alertController:@"您还未登录，无法评价"];

                } else if (num == 16) {
                
                    [self alertController:@"您收藏的信息不存在"];
                } else if (num == 17) {
                
                    [self alertController:@"请勿重复操作"];
                } else {
                
                    [self alertController:@"系统繁忙"];
                }
            });
        });

    }];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [more_alert addAction:first_action];
    [more_alert addAction:second_action];
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
        [button setBackgroundColor:kRightColor];
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


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    num = 2;
    if (self.cell_sourceArray.count > 0) {
        [self asyWenZhangDetailNetWork];
        return;
    }
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyWenZhangDetailNetWork];
            [self asyPLListNetWorkAndPage:1];
            //表述图
            [self initTableView];
            [self replyButton];

            //下拉刷新
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        [self.cell_sourceArray removeAllObjects];
                        [self asyWenZhangDetailNetWork];
                        [self asyPLListNetWorkAndPage:1];
                        [self.mainTableView.header endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.mainTableView.header endRefreshing];
                    }
                }];
            }];
            
            self.mainTableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        int page = num ++;
                        [self asyPLListNetWorkAndPage:page];
                        [self.mainTableView.footer endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.mainTableView.footer endRefreshing];
                    }
                }];
                
            }];

        } else {
            //表述图
            [self initTableView];
            [self replyButton];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.footer endRefreshing];
        }
    }];

}


-(void)changePicSize:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    if ([[dic valueForKey:@"size"] isEqualToString:@"YES"]) {
        UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor backgroundColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
            make.width.offset(self.view.frame.size.width);
            make.height.offset(self.view.frame.size.height*0.5);
        }];
        if (self.header_model.imgs.count != 0) {
        
            int tag                = [[dic valueForKey:@"tag"] intValue];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.header_model.imgs[tag]]];
            imageView.userInteractionEnabled = YES;
            
        } else {
            [imageView setImage:[UIImage imageNamed:@"default_pic"]];
            imageView.userInteractionEnabled = YES;

        }
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picChangeSmall:)];
        [imageView addGestureRecognizer:imageTap];
        [view addGestureRecognizer:imageTap];
    }
}

-(void)picChangeSmall:(UITapGestureRecognizer *)tap {
    if ([[tap view] isKindOfClass:[UIView class]]) {
        [[tap view] removeFromSuperview];
    } else {
        [[[tap view] superview] removeFromSuperview];
    }
}


-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.tableHeaderView = [self setTableViewHeaderView];
}

#pragma mark - 回复按钮
- (void)replyButton {

    UIView *bottomview_one = [[UIView alloc] init];
    [self.view addSubview:bottomview_one];
    [bottomview_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    bottomview_one.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    
    UIImageView *thumb_image = [[UIImageView alloc] init];
    [bottomview_one addSubview:thumb_image];
    [thumb_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomview_one.mas_centerY);
        make.right.equalTo(bottomview_one.mas_centerX);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    if ([_header_model.iszan intValue] == 1) {
        [thumb_image setImage:[UIImage imageNamed:@"is_praised_item"]];
    } else {
        [thumb_image setImage:[UIImage imageNamed:@"like"]];
    }
    
    
    UILabel *label_one = [[UILabel alloc] init];
    [bottomview_one addSubview:label_one];
    [label_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomview_one.mas_centerY);
        make.left.equalTo(bottomview_one.mas_centerX);
        make.height.offset(20);
    }];
    
    label_one.text = @"有用";
    label_one.textColor = [UIColor whiteColor];
    label_one.font = [UIFont systemFontOfSize:12.0f weight:2.0f];
    
    UIView *line_view = [UIView new];
    [bottomview_one addSubview:line_view];
    [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(bottomview_one.mas_right);
        make.width.mas_equalTo(2);
        make.top.equalTo(bottomview_one.mas_top).offset(3);
        make.bottom.equalTo(bottomview_one.mas_bottom).offset(-3);
        
    }];
    line_view.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomview_two = [[UIView alloc] init];
    [self.view addSubview:bottomview_two];
    [bottomview_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomview_one.mas_centerY);
        make.height.equalTo(bottomview_one.mas_height);
        make.left.equalTo(bottomview_one.mas_right);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    bottomview_two.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    UIImageView *reply_image = [[UIImageView alloc] init];
    [bottomview_two addSubview:reply_image];
    [reply_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomview_two.mas_centerY);
        make.right.equalTo(bottomview_two.mas_centerX);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    [reply_image setImage:[UIImage imageNamed:@"reply"]];
    
    
    UILabel *label_two = [[UILabel alloc] init];
    [bottomview_two addSubview:label_two];
    [label_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomview_two.mas_centerY);
        make.left.equalTo(bottomview_two.mas_centerX);
        make.height.offset(20);
    }];
    
    label_two.text = @"评论";
    label_two.textColor = [UIColor whiteColor];
    label_two.font = [UIFont systemFontOfSize:12.0f weight:2.0f];
    
    
    //加手势
    
    UITapGestureRecognizer *thumb_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedZan:)];
    [bottomview_one addGestureRecognizer:thumb_tap];
    
    UITapGestureRecognizer *reply_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayButtonClicked)];
    [bottomview_two addGestureRecognizer:reply_tap];
}

- (void)replayButtonClicked {
    
    DDQReplayViewController * replayVC = [DDQReplayViewController new];
    replayVC.wenzhangId = self.singleModel.articleId;
    replayVC.beiPLUserId = @"0";
    replayVC.fathPLId = @"0";
    replayVC.hidesBottomBarWhenPushed  = YES;
    
    [self.navigationController pushViewController:replayVC animated:YES];
}


-(void)clickedZan:(UITapGestureRecognizer *)tap {

    if ([_header_model.iszan intValue] == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //调用点赞接口
            //八段
            NSString *spellString = [SpellParameters getBasePostString];
            
            //拼参数
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"1",self.header_model.iD];
            
            //加密
            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
            NSString *post_encryption = [post stringWithPost:post_baseString];
            
            //传
            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kAddZan];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                                
                //判断errorcode
                NSString *errorcode = post_dic[@"errorcode"];
                int num = [errorcode intValue];
                if (num == 0) {
                    
                    UIView *tap_view = [tap view];
                    for (UIView *view in tap_view.subviews) {
                        
                        if ([view isKindOfClass:[UIImageView class]]) {
                            
                            [(UIImageView *)view setImage:[UIImage imageNamed:@"is_praised_item"]];
                        }
                    }
                    [self alertController:@"点赞成功"];
                    [self asyWenZhangDetailNetWork];
                    
                } else if (num == 14) {
                    
                    [self alertController:@"您还未登录，无法评价"];
                    
                } else if (num == 16) {
                    
                    [self alertController:@"您已经赞过了！"];
                    
                } else {
                    
                    [self alertController:@"系统繁忙"];
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //调用点赞接口
            //八段
            NSString *spellString = [SpellParameters getBasePostString];
            
            //拼参数
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"1",self.header_model.iD];
            
            //加密
            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
            NSString *post_encryption = [post stringWithPost:post_baseString];
            
            //传
            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kDelZan];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //判断errorcode
                NSString *errorcode = post_dic[@"errorcode"];
                int num = [errorcode intValue];
                if (num == 0) {
                    
                    UIView *tap_view = [tap view];
                    for (UIView *view in tap_view.subviews) {
                        
                        if ([view isKindOfClass:[UIImageView class]]) {
                            
                            [(UIImageView *)view setImage:[UIImage imageNamed:@"like"]];
                        }
                    }
                    [self alertController:@"取消点赞"];
                    [self asyWenZhangDetailNetWork];

                    
                } else if (num == 14) {
                    
                    [self alertController:@"您还未登录，无法评价"];
                    
                } else if (num == 16) {
                    
                    [self alertController:@"文章/评论不存在或已被删除"];
                    
                } else {
                    
                    [self alertController:@"系统繁忙"];
                }
            });
        });

        
    }
}
                                     

-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:YES];
    self.header_model = nil;
}

#pragma mark - network
-(void)asyWenZhangDetailNetWork {
    //拼8段
    NSString *spellString = [SpellParameters getBasePostString];
    NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,self.singleModel.ctime,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
    //加密这个段数
    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
    NSString *post_string = [postEncryption stringWithPost:post_baseString];
    //post
    NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:kWenzhangDetailUrl];
    
    NSString *errorcode = [post_dic valueForKey:@"errorcode"];
    if ([errorcode intValue] == 0) {
        //12-21
        //解密
        NSDictionary *dic1 = [DDQPOSTEncryption judgePOSTDic:post_dic];
        
        NSDictionary *get_jsonDic = [DDQPublic nullDic:dic1];
        
        self.header_model = [[DDQCommentModel alloc] init];
        _header_model.imgs             = [get_jsonDic valueForKey:@"imgs"];
        _header_model.text             = [get_jsonDic valueForKey:@"text"];
        _header_model.title            = [get_jsonDic valueForKey:@"title"];
        _header_model.userid           = [get_jsonDic valueForKey:@"userid"];
        _header_model.username         = [get_jsonDic valueForKey:@"username"];
        _header_model.userimg          = [get_jsonDic valueForKey:@"userimg"];
        _header_model.pubtime          = [get_jsonDic valueForKey:@"pubtime"];
        _header_model.iszan            = get_jsonDic[@"iszan"];
        _header_model.type             = get_jsonDic[@"type"];
        _header_model.iD               = get_jsonDic[@"id"];
        _header_model.pluser           = get_jsonDic[@"pluser"];
        _header_model.zan              = get_jsonDic[@"zan"];

        [self.mainTableView reloadData];
    
    } else {
        [self alertController:@"服务器繁忙"];
    }

}

static BOOL showFoot = NO;
-(void)asyPLListNetWorkAndPage:(int)page {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%d",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.singleModel.articleId,page];
        //加密这个段数
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_string = [postEncryption stringWithPost:post_baseString];
        //post
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:KPLListUrl];
        
        NSString *errorcode = [post_dic valueForKey:@"errorcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([errorcode intValue] == 0) {
                //解密
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                if (get_jsonDic.count != 0) {
                    for (NSDictionary *dataDic in get_jsonDic) {
                        DDQReplyModel *replyModel = [[DDQReplyModel alloc] init];
                        replyModel.iD             = [dataDic valueForKey:@"id"];
                        replyModel.pubtime        = [dataDic valueForKey:@"pubtime"];
                        replyModel.son            = [dataDic valueForKey:@"son"];
                        replyModel.status         = [dataDic valueForKey:@"status"];
                        replyModel.text           = [dataDic valueForKey:@"text"];
                        replyModel.userid         = [dataDic valueForKey:@"userid"];
                        replyModel.userid2        = [dataDic valueForKey:@"userid2"];
                        replyModel.userimg        = [dataDic valueForKey:@"userimg"];
                        replyModel.username       = [dataDic valueForKey:@"username"];
                        replyModel.wid            = [dataDic valueForKey:@"wid"];
                        replyModel.more_hf        = dataDic[@"more_hf"];
                        replyModel.isReuse        = NO;
                        [self.cell_sourceArray addObject:replyModel];
                    }
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                    [self.mainTableView.footer endRefreshing];
                    
                } else {
                    
                    [self.mainTableView.header endRefreshing];
                    [self.mainTableView.footer endRefreshing];
                    self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                    /**
                     *  这里是为了区分我第一次请求为空，以及上拉请求后数据为空的差别
                     */
                    if (showFoot == NO) {
                        
                        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                        self.mainTableView.tableFooterView = footView;
                        
                        UILabel *tip_label = [[UILabel alloc] init];
                        [footView addSubview:tip_label];
                        [tip_label mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.centerX.equalTo(footView.mas_centerX);
                            make.centerY.equalTo(footView.mas_centerY);
                            
                        }];
                        tip_label.font = [UIFont systemFontOfSize:13.0f];
                        tip_label.text = @"还没有人回帖哦，快点给楼主点鼓励吧!";
                        tip_label.textColor = [UIColor lightGrayColor];
                        
                        showFoot = YES;

                    }
                }
                
            } else {
                [self alertController:@"系统繁忙"];
            }
        });
    });
}


#pragma mark - headerView
-(UIView *)setTableViewHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.1)];
    [headerView setBackgroundColor:[UIColor myGrayColor]];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.1)];
    [headerView addSubview:userView];
    [userView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *userImage = [[UIImageView alloc] init];
    [userView addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView.mas_centerY);
        make.left.equalTo(userView.mas_left).with.offset(self.view.bounds.size.width*0.01);
        if (kScreenHeight == 480) {
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        } else if (kScreenHeight == 568) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        } else if (kScreenHeight == 667) {
            make.width.equalTo(@45);
            make.height.equalTo(@45);
        } else {
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }
    }];
    if (kScreenHeight == 480) {
        [userImage.layer setCornerRadius:15.0f];
        userImage.layer.masksToBounds = YES;
        
    } else if (kScreenHeight == 568) {
        [userImage.layer setCornerRadius:20.0f];
        userImage.layer.masksToBounds = YES;
        
    } else if (kScreenHeight == 667) {
        [userImage.layer setCornerRadius:22.5f];
        userImage.layer.masksToBounds = YES;
        
    } else {
        [userImage.layer setCornerRadius:25.0f];
        userImage.layer.masksToBounds = YES;
    }
    [userImage sd_setImageWithURL:[NSURL URLWithString:self.header_model.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushOthersVCMethod:)];
    [userImage addGestureRecognizer:tap];
    [userImage setUserInteractionEnabled:YES];
    
    //重新计算名字的长度
    CGRect nicknameSize = [self.header_model.username boundingRectWithSize:CGSizeMake(kScreenWidth, userImage.frame.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
    
    UILabel *userLabel = [[UILabel alloc] init];
    [userView addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImage.mas_right).with.offset(10);
        make.bottom.equalTo(userImage.mas_centerY);
        make.height.offset(nicknameSize.size.height);
        make.width.offset(nicknameSize.size.width);
    }];
    userLabel.text = self.header_model.username;
    [userLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    //重新计算发布时间
    CGRect releasetimeSize = [self.header_model.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, userImage.frame.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
    
    UILabel *releaseTime = [[UILabel alloc] init];
    [userView addSubview:releaseTime];
    [releaseTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userLabel.mas_left);
        make.top.equalTo(userView.mas_centerY);
        make.width.offset(releasetimeSize.size.width);
        make.height.offset(releasetimeSize.size.height);
    }];
    releaseTime.text = self.header_model.pubtime;
    [releaseTime setFont:[UIFont systemFontOfSize:12.0f]];
    
    UIImageView *userType = [[UIImageView alloc] init];
    [userView addSubview:userType];
    [userType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView.mas_centerY);
        make.right.equalTo(userView.mas_right);
        make.width.offset(30);
        make.height.equalTo(releaseTime.mas_height);
    }];
    userType.image = [UIImage imageNamed:@"lz"];
    
    return headerView;
}

-(void)pushOthersVCMethod:(UITapGestureRecognizer *)tap {
    
    DDQOthersViewController *othersVC = [DDQOthersViewController new];
    othersVC.hidesBottomBarWhenPushed = YES;
    othersVC.others_userid = self.header_model.userid;
    [self.navigationController pushViewController:othersVC animated:YES];
}


#pragma mark - delegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 30;
    }
}

/**
 *  去掉脚的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1+1;
    } else {
        
        return self.cell_sourceArray.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return  self.newRowHeight+50;
        } else {
            if (kScreenHeight == 480) {
                return 70;
            } else if (kScreenHeight == 568) {
                return 80;
            } else {
                return 90;
            }
        }
        
    } else {
        
        return self.celltop_H + self.cellbottom_H + 10;
        
    }
}

static NSString *identifier = @"first";
static NSString *identifierSecond = @"second";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            DDQCommentFirstCell *firstCell = [[DDQCommentFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [firstCell cellWithCommentModel:self.header_model];
            self.newRowHeight              = firstCell.newHeight;
            firstCell.selectionStyle       = UITableViewCellSelectionStyleNone;
            return firstCell;
            
        } else {
           
            UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor   = [UIColor backgroundColor];
            cell.selectionStyle    = UITableViewCellSelectionStyleNone;
            CGFloat viewH;
            if (kScreenHeight == 480) {
                viewH = 60;
                
            } else if (kScreenHeight == 568) {
                viewH = 70;

            } else {
                viewH = 80;
            }
            
            UIView *tempView         = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, viewH)];
            tempView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:tempView];

            CGFloat split_left = 5;
            CGFloat imgW;
            CGFloat imgH;
            if (kScreenHeight == 480) {
                imgW = 30;
                imgH = 30;
            } else if (kScreenHeight == 568) {
                imgW = 40;
                imgH = 40;
            } else {
                imgW = 50;
                imgH = 50;
            }
            
            NSMutableArray *temp_array = [NSMutableArray array];
            
            for (NSDictionary *dic in self.header_model.pluser) {
                [temp_array addObject:dic[@"userimg"]];
            }
            
            int num ;
            if (temp_array.count > 7) {
                num = 7;
            } else {
            
                num = (int)temp_array.count;
            }
            for (int i = 0 ; i < num; i++) {
                UIImageView *imageView        = [[UIImageView alloc] initWithFrame:CGRectMake(imgW*i + split_left*i + 5, 5, imgW, imgH)];
                imageView.layer.cornerRadius  = imgW/2;
                imageView.layer.masksToBounds = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:temp_array[i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                [tempView addSubview:imageView];
            }
            
            NSString *temp_str = [NSString stringWithFormat:@"%@人觉得有用",self.header_model.zan];
            CGRect thumbSize   = [temp_str boundingRectWithSize:CGSizeMake(kScreenWidth, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            
            UILabel *thumbLabel = [[UILabel alloc] init];
            [cell.contentView addSubview:thumbLabel];
            [thumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(tempView.mas_right).offset(-5);
                make.width.offset(thumbSize.size.width);
                make.height.offset(thumbSize.size.height);
                make.bottom.equalTo(tempView.mas_bottom).offset(-5);
            }];
            thumbLabel.text     = temp_str;
            thumbLabel.font     = [UIFont systemFontOfSize:12.0f];
            
            UIImageView *thumbImage = [[UIImageView alloc] init];
            [cell.contentView addSubview:thumbImage];
            [thumbImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(thumbLabel.mas_left).offset(-3);
                make.centerY.equalTo(thumbLabel.mas_centerY);
                make.height.offset(15);
                make.width.offset(15);
            }];
            thumbImage.image        = [UIImage imageNamed:@"like"];
            return cell;
        }
        
    } else {
#warning 这里的重用啊，报警了
        DDQCommentSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:identifierSecond];


        DDQReplyModel *replyModel = [self.cell_sourceArray objectAtIndex:indexPath.row];
        secondCell = [[DDQCommentSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSecond];
        [secondCell cellWithReplyModel:replyModel];
    
        secondCell.delegate = self;
        
        self.celltop_H                   = secondCell.viewtop_H;
        self.cellbottom_H                = secondCell.viewBottom_H;
        secondCell.backgroundColor       = [UIColor whiteColor];
        secondCell.selectionStyle        = UITableViewCellSelectionStyleNone;
        return secondCell;
    }
}


-(void)secondCommentCellPushToReplyVCWithSonModel:(DDQSonModel *)sonModel {

    DDQReplayViewController * replayVC = [DDQReplayViewController new];
    replayVC.wenzhangId  = sonModel.wid;
    replayVC.beiPLUserId = sonModel.userid;
    replayVC.fathPLId    = sonModel.iD;
    [self.navigationController pushViewController:replayVC animated:YES];
}

-(void)secondCommentReplyViewPushToReplyVCWithSonModel:(DDQReplyModel *)replyModel {

    DDQReplayViewController * replayVC = [DDQReplayViewController new];
    replayVC.wenzhangId  = replyModel.wid;
    replayVC.beiPLUserId = replyModel.userid;
    replayVC.fathPLId    = replyModel.iD;
    [self.navigationController pushViewController:replayVC animated:YES];

}

-(void)secondCommentShowMoreLabelWithReplyModel:(DDQReplyModel *)replyModel {

    DDQMoreCommentViewController *moreCommentVC = [DDQMoreCommentViewController new];
    moreCommentVC.parentid = replyModel.iD;
    moreCommentVC.wid      = replyModel.wid;
    [self.navigationController pushViewController:moreCommentVC animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return @"全部评论";
    } else {
    
        return @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        
        DDQReplyModel *replyModel = self.cell_sourceArray[indexPath.row];
        
        DDQOthersViewController *othersVC = [DDQOthersViewController new];
        othersVC.hidesBottomBarWhenPushed = YES;

        othersVC.others_userid = replyModel.userid;
        [self.navigationController pushViewController:othersVC animated:YES];
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
