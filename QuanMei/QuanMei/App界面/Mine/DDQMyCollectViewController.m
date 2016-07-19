//
//  DDQMyCollectViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyCollectViewController.h"

#import "DDQMyCollectCell.h"

#import "DDQMyCollectModel.h"

#import "DDQGroupArticleModel.h"

#import "DDQDiaryViewCell.h"
#import "ProjectNetWork.h"
#import "DDQLoginViewController.h"
@interface DDQMyCollectViewController () <UITableViewDelegate,UITableViewDataSource>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) DDQMyCollectModel *myCollectModel;

@property (strong,nonatomic) NSMutableArray *collect_sourceArray;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) ProjectNetWork *netWork;
@property (assign, nonatomic) int page;

@end

@implementation DDQMyCollectViewController

- (MBProgressHUD *)hud {
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.detailsLabelText = @"请稍等...";
        
    }
    
    return _hud;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.collect_sourceArray = [NSMutableArray array];
    //2
    [self initMainTabelView];
    
    self.page = 1;
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self collectListNetWorkWithPage:self.page];

    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.collect_sourceArray removeAllObjects];
        [self collectListNetWorkWithPage:self.page];
        [self.mainTableView.header endRefreshing];
        
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self collectListNetWorkWithPage:self.page];
        [self.mainTableView.footer endRefreshing];
        
    }];

}

//static int page = 2;

-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
}

-(void)collectListNetWorkWithPage:(int)page {

    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kSc_listUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 13) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DDQLoginViewController alloc] init]];
                
            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES
                                     andCustomView:nil];

            }
            
        } else {
        
            for (NSDictionary *dic in responseObjc) {
                
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
                [self.collect_sourceArray addObject:articleModel];
                
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
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.collect_sourceArray.count;
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
        
        if (indexPath.row == self.collect_sourceArray.count) {
            
            return 44;
            
        } else if (self.rowHeight != 0) {
            
            return  self.rowHeight + kScreenHeight*0.25-h;
            
        } else {
            
            DDQGroupArticleModel *model;
            
            if (self.collect_sourceArray.count > 0) {
                
                model = self.collect_sourceArray[indexPath.row];
                
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

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQGroupArticleModel *articleModel;
    if (self.collect_sourceArray.count != 0) {
        articleModel = [self.collect_sourceArray objectAtIndex:indexPath.row];
    }
    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    diaryCell.articleModel      = articleModel;
    self.rowHeight              = diaryCell.newRect.size.height;
    diaryCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
    diaryCell.backgroundColor   = [UIColor myGrayColor];

    return diaryCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header_view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    NSString *str = [NSString stringWithFormat:@"共有%ld条收藏",self.collect_sourceArray.count];
    
    CGRect strRect = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, strRect.size.width, 20)];
    [header_view addSubview:title_label];
    title_label.numberOfLines = 0;
    title_label.text          = str;
    title_label.font          = [UIFont systemFontOfSize:13.0f];
    header_view.backgroundColor = [UIColor backgroundColor];
    
    return header_view;
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
