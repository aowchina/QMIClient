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


@interface DDQMyCollectViewController () <UITableViewDelegate,UITableViewDataSource>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat new_cellHeight;

@property (strong,nonatomic) DDQMyCollectModel *myCollectModel;

@property (strong,nonatomic) NSMutableArray *collect_sourceArray;


@end

@implementation DDQMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1
//    self.myCollectModel          = [[DDQMyCollectModel alloc] init];
//    self.myCollectModel.username = @"我叫咚咚枪";
//    self.myCollectModel.intro    = @"等了好久终于等到今天";
//    self.myCollectModel.title    = @"今天-刘德华";
//    self.myCollectModel.pubtime  = @"2015-11-10";
//    self.myCollectModel.zan      = @"1111";
//    self.myCollectModel.reply    = @"111";
//    
    self.collect_sourceArray = [NSMutableArray array];
    //2
    [self initMainTabelView];
    
    [self collectListNetWorkWithPage:1];

    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                [self.collect_sourceArray removeAllObjects];
                [self collectListNetWorkWithPage:1];
                [self.mainTableView.header endRefreshing];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.mainTableView.header endRefreshing];
            }
        }];
        
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {

            //确保网络连接无错误,防止别人手贱
            if (errorDic == nil) {
                int num = page ++;
                [self collectListNetWorkWithPage:num];
                [self.mainTableView.footer endRefreshing];
            } else {
                [self.mainTableView.footer endRefreshing];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
        }];

    }];


}
static int page = 2;
-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

-(void)collectListNetWorkWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%d",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kSc_listUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                
                NSDictionary *data = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                //请求回来有东西
                if (data.count != 0) {

                    for (NSDictionary *dic in data) {
                        
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
                    [self.mainTableView reloadData];
                } else {
                    
                    [self alertController:@"无更多数据"];
                    [self.mainTableView.footer endRefreshing];
                    
                }
                //停止刷新
                [self.mainTableView.header endRefreshing];
                [self.mainTableView.footer endRefreshing];

                //给数据源赋值
//                DDQMineInfoModel *model = [[DDQMineInfoModel alloc] init];
//                model.age = [NSString stringWithFormat:@"%@",data[@"age"]];
//                model.city = data[@"city"];
//                model.level = [NSString stringWithFormat:@"%@",data[@"level"]];
//                model.sex = data[@"sex"];
//                model.star = [NSString stringWithFormat:@"%@",data[@"star"]];
//                model.userimg = data[@"userimg"];
//                model.userid = [NSString stringWithFormat:@"%@",data[@"userid"]];
//                model.username = data[@"username"];
//                self.mineInfoModel = model;
//                [self.mainTabelView reloadData];
                
            } else if (num == 13) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户未登录，请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1213;
                [alertView show];
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });

}

#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.collect_sourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == self.collect_sourceArray.count) {
            
            return 44;
            
        } else if (self.new_cellHeight != 0) {
            
            return  self.new_cellHeight + kScreenHeight*0.25;
            
        } else {
            
            return kScreenHeight * 0.5;
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
    self.new_cellHeight        = diaryCell.newRect.size.height;
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
