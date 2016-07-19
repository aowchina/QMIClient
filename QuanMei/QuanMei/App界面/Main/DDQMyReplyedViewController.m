//
//  DDQMyReplyedViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMyReplyedViewController.h"

#import "DDQMyCommentChildCell.h"
#import "DDQUserCommentViewController.h"
#import "DDQMyReplyedModel.h"

@interface DDQMyReplyedViewController ()<UITableViewDataSource,UITableViewDelegate,MyReplyedDelegate>


@property (weak, nonatomic) IBOutlet UITableView *mr_mainTableView;

@property (strong,nonatomic) DDQMyReplyedModel *myReplyedModel;
@property (strong,nonatomic) NSMutableArray *mr_modelArray;

@property (assign,nonatomic) CGFloat mr_cellHeight;

@property (nonatomic, assign) int page;

@end

@implementation DDQMyReplyedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.myReplyedModel = [DDQMyReplyedModel instanceManager];
    _myReplyedModel.delegate = self;
    
    self.mr_modelArray = [NSMutableArray array];
    
    [self.mr_mainTableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.mr_mainTableView.tableFooterView = [[UIView alloc] init];
    self.mr_mainTableView.backgroundColor = [UIColor backgroundColor];
    
    self.page = 1;
    
    [self mr_netWorkWithPage:self.page];
    
    self.mr_mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshData)];
    
    self.mr_mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footFreshData)];
    
}

-(void)headerFreshData {
        
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {//加载的时候查看网络
        
        if (errorDic == nil) {
            
            self.page = 1;
            [self.mr_modelArray removeAllObjects];
            [self mr_netWorkWithPage:self.page];
            [self.mr_mainTableView.header endRefreshing];
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];

}

-(void)footFreshData {
  
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {//加载的时候查看网络
        
        if (errorDic == nil) {
            
            self.page = self.page + 1;
            [self mr_netWorkWithPage:self.page];
            [self.mr_mainTableView.footer endRefreshing];
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];

}


static int mr_page = 2;
-(void)mr_netWorkWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%d",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kUser_bhfUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
        
            for (NSDictionary *dic in get_jsonDic) {
                
                DDQMyCommentChildModel *comment_childModel = [[DDQMyCommentChildModel alloc] init];
                comment_childModel.id        = dic[@"id"];
                comment_childModel.pubtime   = dic[@"pubtime"];
                comment_childModel.text     = dic[@"text"];
                comment_childModel.text2     = dic[@"text2"];
                comment_childModel.userid    = dic[@"userid"];
                comment_childModel.userid2   = dic[@"userid2"];
                comment_childModel.userimg   = dic[@"userimg"];
                comment_childModel.username  = dic[@"username"];
                comment_childModel.username2 = dic[@"username2"];
                comment_childModel.userimg   = dic[@"userimg"];
                comment_childModel.ctime     = dic[@"ctime"];

                [self.mr_modelArray addObject:comment_childModel];
            }
            
            
            if (self.mr_modelArray.count == 0 && [get_jsonDic count] == 0) {
                UIImageView *temp_img = [[UIImageView alloc] init];
                [self.view addSubview:temp_img];
                [temp_img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.centerY.equalTo(self.view.mas_centerY);
                    make.width.offset(70);
                    make.height.offset(70);
                }];
                temp_img.image = [UIImage imageNamed:@"default_pic"];
                
                UILabel *tip_onelabel = [[UILabel alloc] init];
                [self.view addSubview:tip_onelabel];
                [tip_onelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(temp_img.mas_bottom).offset(10);
                    make.centerX.equalTo(temp_img.mas_centerX);
                    make.height.offset(20);
                }];
                tip_onelabel.text = @"暂无回复";
                tip_onelabel.textAlignment = NSTextAlignmentCenter;
                tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                
                UILabel *tip_twolabel = [[UILabel alloc] init];
                [self.view addSubview:tip_twolabel];
                [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                    make.centerX.equalTo(tip_onelabel.mas_centerX);
                    make.height.offset(15);
                }];
                tip_twolabel.text = @"快去发表感想吧";
                tip_twolabel.textAlignment = NSTextAlignmentCenter;
                tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
            }

            [self.mr_mainTableView reloadData];//刷新下
            
            if (get_jsonDic.count == 0) {
                
                self.mr_mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
            
                self.mr_mainTableView.footer.state = MJRefreshStateIdle;

            }
            
        });
    });
        
  
}

-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyCount"];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mr_modelArray.count;
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQMyCommentChildCell *childCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    childCell = [[DDQMyCommentChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    DDQMyCommentChildModel *childModel;
    if (self.mr_modelArray.count != 0) {
        childModel = self.mr_modelArray[indexPath.row];
    }
    childCell.commentChildModel = childModel;
    
    childCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mr_cellHeight = childCell.cell_height;
    
    childCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return childCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.mr_cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQMyCommentChildModel *model = [self.mr_modelArray objectAtIndex:indexPath.row];
    DDQUserCommentViewController *commentC = [[DDQUserCommentViewController alloc] init];
    commentC.hidesBottomBarWhenPushed = YES;
    commentC.userid = model.userid;
    commentC.articleId = model.id;
    commentC.ctime = model.ctime;
    
    [self.navigationController pushViewController:commentC animated:YES];
    
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
