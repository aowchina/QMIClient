//
//  DDQFirstDiaryChildController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//


#import "DDQFirstDiaryChildController.h"
#import "DDQMyCommentCell.h"

#import "DDQUserCommentViewController.h"
#import "DDQHeaderSingleModel.h"

@interface DDQFirstDiaryChildController ()<UITableViewDataSource,UITableViewDelegate,MyCommentCellDelegate>

/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat new_cellHeight;


@property (strong,nonatomic) NSMutableArray *articleModelArray;
@property (strong,nonatomic) DDQHeaderSingleModel *singleModel;

@end

@implementation DDQFirstDiaryChildController
static int num = 2;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //1
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainTabelView];
    self.singleModel       = [DDQHeaderSingleModel singleModelByValue];

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        //网络连接无错误
        if (errorDic == nil) {
            
            [self requestDataWith:1 url:kMyDiaryUrl];
            
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                //确保网络连接无错误,防止别人手贱
                if (errorDic == nil) {
                    [self.articleModelArray removeAllObjects];
                    [self requestDataWith:1 url:kMyDiaryUrl];
                    [self.mainTableView.header endRefreshing];

                }
                
            }];
            
            self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        int page = num ++;
                        [self requestDataWith:page url:kMyDiaryUrl];
                        [self.mainTableView.footer endRefreshing];
                        self.mainTableView.footer.state = MJRefreshStateNoMoreData;

                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
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
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    self.articleModelArray = [NSMutableArray array];
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
    
    return self.articleModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.new_cellHeight != 0) {
    
        return  self.new_cellHeight;
        
//    } else {
        
//        return kScreenHeight * 0.5;
//    }
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQMyCommentCell *myCommentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    DDQGroupArticleModel *model;
    if (self.articleModelArray.count != 0) {
        model = self.articleModelArray[indexPath.row];
    }
    myCommentCell = [[DDQMyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    myCommentCell.articleModel = model;
    
    self.new_cellHeight = myCommentCell.cell_height;
    
    myCommentCell.backgroundColor = [UIColor backgroundColor];
    
    myCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    myCommentCell.delegate = self;
    
    return myCommentCell;
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
        
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryptionString AndUrl:kDel_wenzhangUrl];
        
        if ([post_dic[@"errorcode"] intValue] == 0 && post_dic != nil) {
            [self.articleModelArray removeAllObjects];
            [self requestDataWith:1 url:kMyDiaryUrl];
        } else {
         
            [MBProgressHUD myCustomHudWithView:self.view
                                 andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }
        
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    [alertController addAction:actionOne];
    [alertController addAction:actionTwo];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQGroupArticleModel *articleModel;
    if (self.articleModelArray.count != 0 && self.articleModelArray != nil) {
        articleModel = self.articleModelArray[indexPath.row];
    }
    DDQUserCommentViewController *userCommentVC = [[DDQUserCommentViewController alloc] init];
    self.singleModel.ctime                      = articleModel.ctime;
    self.singleModel.articleId                  = articleModel.articleId;
    self.singleModel.userId                     = articleModel.userid;
    [self.navigationController pushViewController:userCommentVC animated:YES];
}

/**
 * @ author SuperLian
 *
 * @ date   15/12/4
 *
 * @ func   调用接口解析数据
 */
- (void)requestDataWith:(NSInteger )page url:(NSString *)url{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //调用点赞接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        NSInteger type = 1;
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%lu*%lu",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],type,page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
            //判断errorcode
            NSString *errorcode = get_jsonDic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0 && get_jsonDic != nil) {
                
                for (NSDictionary *dic in get_jsonDic) {
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
                if (get_jsonDic.count == 0) {
                    
                    [self.mainTableView reloadData];

                    if (self.articleModelArray.count == 0) {
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
                        tip_onelabel.text = @"暂无日记";
                        tip_onelabel.textAlignment = NSTextAlignmentCenter;
                        tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                        
                        UILabel *tip_twolabel = [[UILabel alloc] init];
                        [self.view addSubview:tip_twolabel];
                        [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                            make.centerX.equalTo(tip_onelabel.mas_centerX);
                            make.height.offset(15);
                        }];
                        tip_twolabel.text = @"快去发表日记吧";
                        tip_twolabel.textAlignment = NSTextAlignmentCenter;
                        tip_twolabel.font = [UIFont systemFontOfSize:13.0f];

                    }
                    
                } else {
                    
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                }
                
            }else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
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
