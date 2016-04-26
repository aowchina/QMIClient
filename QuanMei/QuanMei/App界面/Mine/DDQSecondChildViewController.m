 //
//  DDQSecondChildViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSecondChildViewController.h"

#import "DDQMyCommentChildCell.h"

#import "DDQMyCommentChildModel.h"

@interface DDQSecondChildViewController () <UITableViewDataSource,UITableViewDelegate,MyCommentChildCellDelegate>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat new_cellHeight;

@property (strong,nonatomic) DDQMyCommentChildModel *childCommentModel;

@property (strong,nonatomic) NSMutableArray *chileModelArray;

@property (copy,nonatomic) NSString *hf_id;
@end

@implementation DDQSecondChildViewController
static int num = 2;
- (void)viewDidLoad {
    [super viewDidLoad];
    //2
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainTabelView];
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        //网络连接无错误
        if (errorDic == nil) {
            
            [self requestDataWith:1 url:kMyreply];
            
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                //确保网络连接无错误,防止别人手贱
                if (errorDic == nil) {
                    [self.chileModelArray removeAllObjects];
                    [self requestDataWith:1 url:kMyreply];
                    [self.mainTableView.header endRefreshing];
                }
                
            }];
            self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        int page = num ++;
                        [self requestDataWith:page url:kMyreply];
                        [self.mainTableView.footer endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.mainTableView.footer endRefreshing];
                    }
                }];
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
    self.chileModelArray = [NSMutableArray array];

}

-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-111) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.chileModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.new_cellHeight + 5;
}

static NSString *identifier = @"cell1";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQMyCommentChildCell *childCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    DDQMyCommentChildModel *childModel;
    if (self.chileModelArray.count != 0) {
        childModel = self.chileModelArray[indexPath.row];
    }
    childCell = [[DDQMyCommentChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    childCell.commentChildModel = childModel;
    self.new_cellHeight         = childCell.cell_height;
    childCell.selectionStyle = UITableViewCellSelectionStyleNone;
    childCell.delegate = self;
    
    return childCell;
}

-(void)myCommentCellDelegateWithTapMethodAndWenzhangId:(NSString *)iD {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除" preferredStyle:0];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_string = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],iD];
        
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryptionString = [postEncryption stringWithPost:post_string];
        
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryptionString AndUrl:kDel_hfUrl];
        
        if ([post_dic[@"errorcode"] intValue] == 0) {
            [self.chileModelArray removeAllObjects];
            [self requestDataWith:1 url:kMyreply];
        }
        
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    [alertController addAction:actionOne];
    [alertController addAction:actionTwo];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)requestDataWith:(NSInteger )page url:(NSString *)url{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //调用点赞接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%lu",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                for (NSDictionary *dic in get_jsonDic) {
                    
                    DDQMyCommentChildModel *childModel = [[DDQMyCommentChildModel alloc] init];
                    
                    childModel.iD = dic[@"id"];
                    childModel.pubtime = dic[@"pubtime"];
                    childModel.title = dic[@"text"];
                    childModel.intro = dic[@"text2"];
                    childModel.userid = dic[@"userid"];
                    childModel.userid2 = dic[@"userid2"];
                    childModel.userimg = dic[@"userimg"];
                    childModel.username = dic[@"username"];
                    childModel.username2 = dic[@"username2"];
                    [self.chileModelArray addObject:childModel];
                }
                if (get_jsonDic.count == 0) {
                    
                    [self.mainTableView reloadData];

                    if (self.chileModelArray.count == 0) {
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
                        tip_twolabel.text = @"快去回复别人吧";
                        tip_twolabel.textAlignment = NSTextAlignmentCenter;
                        tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
                    } else {
                        [self alertController:@"暂无更多数据"];
                        
                    }
                    
                } else {
                    
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];

                }

                
            }else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });
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
