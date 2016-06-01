//
//  DDQMyWalletViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyWalletViewController.h"
#import "DDQMyWalletCell.h"
#import "DDQMyWalletModel.h"
@interface DDQMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign,nonatomic) CGFloat new_cellHeight;
/**
 *  数据源
 */
@property (strong,nonatomic) NSMutableArray *source_array;

@end

@implementation DDQMyWalletViewController
static int page = 2;
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"我的钱包";
    self.navigationItem.titleView = title;
    title.textColor = [UIColor meiHongSe];
    title.textAlignment = NSTextAlignmentCenter;
    //1
//    self.view.backgroundColor = [UIColor redColor];
    [self initMainTabelView];
    self.source_array = [NSMutableArray array];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        if (!errorDic) {
            [self qianbao_wangLuoQingQiuDeYeMa:1];
            self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                int num = page ++;
                [self qianbao_wangLuoQingQiuDeYeMa:num];
            }];
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.footer endRefreshing];
        }
    }];
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回re"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    page = 2;
}

/**
 *  钱包的网络请求
 */
- (void)qianbao_wangLuoQingQiuDeYeMa:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *spell = [SpellParameters getBasePostString];
        
        NSString *post = [NSString stringWithFormat:@"%@*%@*%@",spell,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],[NSString stringWithFormat:@"%d",page]];
        
        DDQPOSTEncryption *encryption = [[DDQPOSTEncryption alloc] init];
        NSString *jiami = [encryption stringWithPost:post];
        
        NSMutableDictionary *data_dic = [[PostData alloc] postData:jiami AndUrl:kGet_jfUrl];

        NSString *errorcode_str = data_dic[@"errorcode"];
        int errorcode = [errorcode_str intValue];
        
        if (errorcode == 0) {
            NSDictionary *result_dic = [DDQPOSTEncryption judgePOSTDic:data_dic];
            NSArray *list_array = result_dic[@"list"];
            for (NSDictionary *dic in list_array) {
                DDQMyWalletModel *model = [DDQMyWalletModel new];
                model.day = dic[@"day"];
                model.iD = dic[@"id"];
                model.month = dic[@"month"];
                model.point = dic[@"point"];
                model.status = dic[@"status"];
                model.type = dic[@"type"];
                model.userid = dic[@"userid"];
                model.week = dic[@"week"];
                model.year = dic[@"year"];
                model.order_num = dic[@"order_num"];
                [self.source_array addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
                view.backgroundColor = [UIColor whiteColor];
                /**
                 *  当前积分
                 */
                UILabel *dangjianjifen = [UILabel new];
                [view addSubview:dangjianjifen];
                [dangjianjifen mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(10);
                    make.top.equalTo(view.mas_top).offset(10);
                    make.height.offset(20);
                }];
                dangjianjifen.text = @"当前积分:";
                
                UILabel *jifen = [UILabel new];
                [view addSubview:jifen];
                [jifen mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX);
                    make.bottom.equalTo(view.mas_bottom).offset(-10);
                    make.height.offset(60);
                }];
                jifen.textColor = [UIColor meiHongSe];
                jifen.text = [NSString stringWithFormat:@"%@",result_dic[@"point"]];
                jifen.font = [UIFont systemFontOfSize:25.0f];
                self.mainTableView.tableHeaderView = view;
                
                [self.mainTableView.footer endRefreshing];
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertController:@"服务器繁忙"];
            });
        }
    });
}

-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.source_array.count;
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDQMyWalletModel *model;
    if (self.source_array.count > 0) {
        model = self.source_array[indexPath.row];
    }
    DDQMyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DDQMyWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        cell.zhouji.text = model.week;
        cell.shijian.text = [NSString stringWithFormat:@"%@-%@",model.month,model.day];
        cell.jifen.text = [NSString stringWithFormat:@"+%@",model.point];
        if ([model.type isEqualToString:@"1"]) {
            
            cell.tupian.image = [UIImage imageNamed:@"签"];
            cell.neirong.text = [NSString stringWithFormat:@"%@-%@-%@:签到",model.year,model.month,model.day];
        } else {
        
            cell.tupian.image = [UIImage imageNamed:@"money-bag"];
            cell.neirong.text = [NSString stringWithFormat:@"%@",model.order_num];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(20);
        make.height.offset(20);
    }];
    label.text = @"明细详情";
    label.textColor = [UIColor lightGrayColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
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
