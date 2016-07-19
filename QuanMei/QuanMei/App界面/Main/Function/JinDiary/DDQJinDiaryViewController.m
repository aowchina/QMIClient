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
#import "ProjectNetWork.h"

@interface DDQJinDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *articleModelArray;
/**
 *  主要的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (nonatomic ,strong)MBProgressHUD *hud;

@property (assign,nonatomic) CGFloat rowHeight;

@property (nonatomic, strong) ProjectNetWork *netWork;
@property (nonatomic, assign) int page;

@end

@implementation DDQJinDiaryViewController
//static int page = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self layoutNavigationBar];
    [self initTableView];
    
    _articleModelArray = [NSMutableArray array];
    
    self.page = 1;
    
    self.netWork = [ProjectNetWork sharedWork];

    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    //传2，固定精品
    [self asyWenzhangNetWork:self.page type:2];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        self.page = 1;
        [self.articleModelArray removeAllObjects];
        [self asyWenzhangNetWork:self.page type:2];
        [self.mainTableView.header endRefreshing];
        
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
        self.page = self.page + 1;
        [self asyWenzhangNetWork:self.page type:2];
        [self.mainTableView.footer endRefreshing];

    }];

}

-(void)initTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
}

-(void)asyWenzhangNetWork:(int)page type:(int)type {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kWenzhangUrl andData:@[@(type).stringValue,@"0",@"0", @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            for (NSDictionary *dic1 in responseObjc) {
                
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

            [self.hud hide:YES];
            
            [_mainTableView reloadData];
            
            if ([responseObjc count] == 0) {
                
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
            
                self.mainTableView.footer.state = MJRefreshStateIdle;
                
            }

        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
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
    CGFloat h;
    if (kScreenHeight <= 568) {
        
        h = 20;
        
    } else if (kScreenHeight == 667) {
        
        h = 30;
        
    } else {
        
        h = 40;
        
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == _articleModelArray.count) {
            
            return 44;
            
        } else if (self.rowHeight != 0) {
            
            return  self.rowHeight + kScreenHeight*0.25-h;
            
        } else {
            
            DDQGroupArticleModel *model;
            
            if (_articleModelArray.count > 0) {
                
                model = _articleModelArray[indexPath.row];
                
            }
            
            if (model.imgArray.count == 0 ){//不传图的情况
                
                if ([model.introString isEqualToString:@""]) {//不传图还不传字
                    
                    return kScreenHeight *0.25 - h;
                    
                } else {//有字，那就是帖子了
                    
                    return kScreenHeight *0.25 + self.rowHeight - h;
                    
                }
                
            } else {//传了图
                
                return self.rowHeight + kScreenHeight *0.5-h;
                
            }
            
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
    
    if (indexPath.section == 0) {
        
        DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
        //赋值
        commentVC.ctime                      = articleModel.ctime;
        commentVC.articleId                  = articleModel.articleId;
        commentVC.userid                     = articleModel.userid;
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
