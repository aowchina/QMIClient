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
#import "ProjectNetWork.h"

@interface DDQDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (strong,nonatomic) NSMutableArray *articleModelArray;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTableView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.detailsLabelText = @"加载中...";
    
    self.page = 1;
    
    self.netWork = [ProjectNetWork sharedWork];
    
    self.articleModelArray = [NSMutableArray array];
    
    [self analysisProjectDiaryWithPage:1];

    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 
        self.page = 1;
        [self.articleModelArray removeAllObjects];
        [self analysisProjectDiaryWithPage:1];
        [self.mainTableView.header endRefreshing];
       
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self analysisProjectDiaryWithPage:self.page];
        [self.mainTableView.footer endRefreshing];
        
    }];


}

//static int page = 2;
-(void)analysisProjectDiaryWithPage:(int)page {
    
    [self.hud show:YES];
    
    DDQSingleModel *model = [DDQSingleModel singleModelByValue];

    [self.netWork asyPOSTWithAFN_url:kProjectRijiUrl andData:@[model.projectId, @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
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
            
            [self.mainTableView reloadData];
            
            if ([responseObjc count] == 0) {
                
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
            
                self.mainTableView.footer.state = MJRefreshStateIdle;

            }

        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];

}

#pragma mark - tableView
-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStylePlain];
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
    
    commentVC.ctime                      = model.ctime;
    commentVC.articleId                  = model.articleId;
    commentVC.userid                     = model.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
@end
