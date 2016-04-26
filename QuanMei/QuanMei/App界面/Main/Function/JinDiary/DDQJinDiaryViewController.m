//
//  DDQJinDiaryViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/27.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQJinDiaryViewController.h"
#import "DDQGroupArticleModel.h"
#import "DDQHeaderSingleModel.h"
#import "DDQDiaryViewCell.h"
#import "DDQUserCommentViewController.h"
@interface DDQJinDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *articleModelArray;
/**
 *  主要的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (nonatomic ,strong)MBProgressHUD *hud;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) NSDictionary *temp_dic;

@end

@implementation DDQJinDiaryViewController
static int page = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self layoutNavigationBar];
    [self initTableView];
    _articleModelArray = [NSMutableArray array];

    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
            
            [self asyWenzhangNetWork:1 type:2 class:nil];
            
        } else {
            
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
//                [self.articleModelArray removeAllObjects];
                page = 2;
                [self asyWenzhangNetWork:1 type:2 class:[MJRefreshNormalHeader class]];
                [self.mainTableView.header endRefreshing];
                
            } else {
                [self.hud hide:YES];
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.mainTableView.header endRefreshing];
            }
        }];
        
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                
                int num = page++;
                [self asyWenzhangNetWork:num type:2 class:[MJRefreshAutoNormalFooter class]];
                [self.mainTableView.footer endRefreshing];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.mainTableView.footer endRefreshing];
            }
        }];
    }];

}

-(void)initTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
}

-(void)asyWenzhangNetWork:(int)page type:(int)type class:(Class)class {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        NSString *page_string = [NSString stringWithFormat:@"%d",page];
        
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",spellString,[NSString stringWithFormat:@"%d",type],@"0",@"0",page_string];
        //加密这个段数
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_string = [postEncryption stringWithPost:post_baseString];
        //post
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:kWenzhangUrl];
        
        //11-06
        NSString *errorcode_string = [post_dic valueForKey:@"errorcode"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([errorcode_string intValue] == 0) {
                
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                self.temp_dic = get_jsonDic;
                
                if (class == [MJRefreshNormalHeader class]) {
                    if (self.temp_dic != nil && self.temp_dic.count > 0) {
                        [self.articleModelArray removeAllObjects];
                    }
                }
                if (get_jsonDic!=nil && get_jsonDic.count != 0) {
                    
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
                    
                    [self alertController:@"暂无数据"];
                    [self.hud hide:YES];
                    
                }
                
            } else {
                [self.hud hide:YES];
                [self alertController:@"服务器繁忙,请稍后重试"];
            }
            
        });
    });
}

-(void)layoutNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    label.text = @"精品日记";
    label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = label;
}

-(void)popVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate and tableView
//tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.articleModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier1 = @"diary";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DDQGroupArticleModel *articleModel;
    if (self.articleModelArray.count != 0) {
        articleModel = [self.articleModelArray objectAtIndex:indexPath.row];
    }
    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
    diaryCell.articleModel      = articleModel;
    self.rowHeight              = diaryCell.newRect.size.height;
    diaryCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
    diaryCell.backgroundColor   = [UIColor myGrayColor];
    return diaryCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.articleModelArray.count) {
            
            return 44;
            
        } else if (self.rowHeight != 0) {
            
            return  self.rowHeight + kScreenHeight*0.25;
            
        } else {
            
            return kScreenHeight * 0.5;
        }
        
    } else {
        return kScreenHeight*0.2;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //取出model类
    DDQGroupArticleModel *articleModel;
    if (indexPath.row < self.articleModelArray.count) {
        articleModel = [self.articleModelArray objectAtIndex:indexPath.row];
    }
    
    //创建单例用来传值
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];
    
    if (indexPath.section == 0) {
        
        DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
        //赋值
        headerSingle.ctime                      = articleModel.ctime;
        headerSingle.articleId                  = articleModel.articleId;
        headerSingle.userId                     = articleModel.userid;
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
        
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
