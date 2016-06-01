 //
//  DDQDiaryViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDiaryViewController.h"
#import "DDQUserCommentViewController.h"
#import "DDQHeaderSingleModel.h"
#import "DDQDiaryViewCell.h"

@interface DDQDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (strong,nonatomic) NSMutableArray *articleModelArray;

@property (assign,nonatomic) CGFloat rowHeight;

@property ( strong, nonatomic) MBProgressHUD *hud;
@end

@implementation DDQDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTableView];
//    self.view.backgroundColor = [UIColor redColor];
    self.articleModelArray = [NSMutableArray array];
//    [self analysisProjectDiary];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.detailsLabelText = @"加载中...";

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        [self analysisProjectDiaryWithPage:1];

        //网络连接无错误
        if (errorDic == nil) {
            
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                //确保网络连接无错误,防止别人手贱
                if (errorDic == nil) {
                    [self.articleModelArray removeAllObjects];
                    [self analysisProjectDiaryWithPage:1];
                    page = 2;
                    [self.mainTableView.header endRefreshing];
                } else {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                    [self.mainTableView.header endRefreshing];
 
                }
                
            }];
            
            self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                //确保网络连接无错误,防止别人手贱
                if (errorDic == nil) {
                    int num = page ++;
                    [self analysisProjectDiaryWithPage:num];
                    [self.mainTableView.footer endRefreshing];
                } else {
                    [self.mainTableView.footer endRefreshing];

                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
                
            }];
            
        } else {
            [self.hud hide:YES];
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];

}

static int page = 2;
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
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:YES];
    //控制器退出，重置页数
    page = 2;
}


-(void)analysisProjectDiaryWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DDQSingleModel *model = [DDQSingleModel singleModelByValue];
        //postString
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%d",[SpellParameters getBasePostString],model.projectId,page];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        //加密字典
        NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kProjectRijiUrl];

        dispatch_async(dispatch_get_main_queue(), ^{
    
            if ([post_Dic[@"errorcode"] intValue] == 0) {
                
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
                
                
                //请求回来有东西
                if (get_jsonDic.count != 0) {
                
                    //12-21
                    for (NSDictionary *dic1 in get_jsonDic) {
                        
                        NSDictionary *dic = [DDQPublic nullDic:dic1];
                        DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                        //精或热
                        articleModel.articleType   = [NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
                        articleModel.isJing        = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isjing"]];
                        articleModel.articleTitle  = [dic valueForKey:@"title"];
                        articleModel.groupName     = [dic valueForKey:@"groupname"];
                        articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                        articleModel.userName      = [dic valueForKey:@"username"];
                        articleModel.userid        = [NSString stringWithFormat:@"%@",[dic valueForKey:@"userid"]];
                        articleModel.plTime        = [dic valueForKey:@"pubtime"];
                        articleModel.thumbNum      = [NSString stringWithFormat:@"%@",[dic valueForKey:@"zan"]];
                        articleModel.replyNum      = [NSString stringWithFormat:@"%@",[dic valueForKey:@"pl"]];
                        articleModel.articleId     = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                        articleModel.introString   = [dic valueForKey:@"text"];
                        articleModel.imgArray      = [dic valueForKey:@"imgs"];
                        articleModel.ctime         = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ctime"]];
                        [_articleModelArray addObject:articleModel];
                    }
                     [_mainTableView reloadData];
                    [self.hud hide:YES];
                } else {
                    [self.hud hide:YES];

                    [self alertController:@"暂无更多数据"];
                }
                //停止刷新
                [self.mainTableView.header endRefreshing];
                [self.mainTableView.footer endRefreshing];

            } else {
                [self.hud hide:YES];
                [self.mainTableView.header endRefreshing];
                [self.mainTableView.footer endRefreshing];
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                [self alertController:@"服务器繁忙,请稍后重试"];
            }
            

        });
    });
}

#pragma mark - tableView
-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - delegate And dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    DDQDiaryViewCell *diaryCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (diaryCell == nil) {
        
        diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    DDQGroupArticleModel *model = self.articleModelArray[indexPath.row];
    
    diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    diaryCell.articleModel   = model;
    self.rowHeight           = diaryCell.newRect.size.height;
    diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
    
    return diaryCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h;
    if (kScreenHeight <= 568) {
        
        h = 20;
        
    } else if (kScreenHeight == 667) {
        
        h = 30;
        
    } else {
        
        h = 40;
        
    }

    if (indexPath.row == _articleModelArray.count) {
        
        return 44;
        
    } else if (self.rowHeight != 0) {
        
        return  self.rowHeight + kScreenHeight*0.25-h;
        
    } else {
        
        return kScreenHeight * 0.5-h;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
    
    //取出model类
    DDQGroupArticleModel *model = self.articleModelArray[indexPath.row];
    
    //赋值
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];

    headerSingle.ctime                      = model.ctime;
    headerSingle.articleId                  = model.articleId;
    headerSingle.userId                     = model.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}
@end
