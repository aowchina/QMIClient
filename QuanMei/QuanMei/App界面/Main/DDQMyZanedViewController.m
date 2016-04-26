//
//  DDQMyZanedViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMyZanedViewController.h"

#import "DDQZanedCell.h"
#import "DDQMyZanedModel.h"

@interface DDQMyZanedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mz_mainTableView;

@property (strong,nonatomic) NSMutableArray *mz_dataArray;

@end

@implementation DDQMyZanedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.mz_dataArray = [NSMutableArray array];
    
    [self.mz_mainTableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.mz_mainTableView.tableFooterView = [[UIView alloc] init];
    self.mz_mainTableView.backgroundColor = [UIColor backgroundColor];
    
    //请求接口
    [self mz_netWorkWithPage:1];
    
    //下拉刷新
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            self.mz_mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        [self.mz_dataArray removeAllObjects];
                        [self mz_netWorkWithPage:1];
                        [self.mz_mainTableView.header endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.mz_mainTableView.header endRefreshing];
                    }
                }];
                
            }];
            
            self.mz_mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                //确保网络连接无错误,防止别人手贱
                if (errorDic == nil) {
                    
                    int num = mz_page ++;
                    [self mz_netWorkWithPage:num];
                    
                    [self.mz_mainTableView.footer endRefreshing];
                } else {
                    
                    [self.mz_mainTableView.footer endRefreshing];
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
                
            }];
            
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

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"replyCount"];
    
}

static int mz_page = 2;
-(void)mz_netWorkWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%d",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kUser_bzanUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
            
            //请求回来有东西
            if (get_jsonDic.count != 0) {
                
                for (NSDictionary *dic in get_jsonDic) {
                    
                    DDQMyZanedModel *zanModel = [[DDQMyZanedModel alloc] init];
                    zanModel.iD        = dic[@"id"];
                    zanModel.text2     = dic[@"text2"];
                    zanModel.userid    = dic[@"userid"];
                    zanModel.userimg   = dic[@"userimg"];
                    zanModel.username  = dic[@"username"];
                    zanModel.pubtime   = dic[@"pubtime"];
                    
                    [self.mz_dataArray addObject:zanModel];
                }
                
            } else {
                
                [self alertController:@"无更多数据"];
                
            }
            
            if (self.mz_dataArray.count == 0) {
                
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
                tip_onelabel.text = @"暂无点赞";
                tip_onelabel.textAlignment = NSTextAlignmentCenter;
                tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                
                UILabel *tip_twolabel = [[UILabel alloc] init];
                [self.view addSubview:tip_twolabel];
                [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                    make.centerX.equalTo(tip_onelabel.mas_centerX);
                    make.height.offset(15);
                }];
                tip_twolabel.text = @"快去美人圈看看吧";
                tip_twolabel.textAlignment = NSTextAlignmentCenter;
                tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
            }
            
            [self.mz_mainTableView reloadData];
        });
    });

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mz_dataArray.count;
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQZanedCell *zanCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!zanCell) {
        DDQMyZanedModel *zanModel;
        if (self.mz_dataArray.count != 0) {
            zanModel = self.mz_dataArray[indexPath.row];
        }
        
        zanCell = [[DDQZanedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [zanCell.mz_userimg sd_setImageWithURL:[NSURL URLWithString:zanModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        zanCell.mz_username.text = zanModel.username;
        zanCell.mz_pubtime.text  = zanModel.pubtime;
        zanCell.mz_content.text  = zanModel.text2;
    }
    return zanCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
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
