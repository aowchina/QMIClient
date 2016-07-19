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
#import "ProjectNetWork.h"
#import "MJExtension.h"

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

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) ProjectNetWork *netWork;
@property (assign, nonatomic) int page;

@end

@implementation DDQMyWalletViewController

//static int page = 2;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"我的钱包";
    self.navigationItem.titleView = title;
    title.textColor = [UIColor meiHongSe];
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回re"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self initMainTabelView];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self qianbao_wangLuoQingQiuDeYeMa:self.page];
        
    }];
    
    self.source_array = [NSMutableArray array];
    
    self.page = 1;
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self qianbao_wangLuoQingQiuDeYeMa:self.page];

}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  钱包的网络请求
 */
- (void)qianbao_wangLuoQingQiuDeYeMa:(int)page {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kGet_jfUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
        
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
            
            NSArray *list_array = responseObjc[@"list"];

            for (NSDictionary *dic in list_array) {
                
                DDQMyWalletModel *model = [DDQMyWalletModel mj_objectWithKeyValues:dic];
                
                [self.source_array addObject:model];
                
            }
            
            [self.hud hide:YES];

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
            jifen.text = [NSString stringWithFormat:@"%@",responseObjc[@"point"]];
            jifen.font = [UIFont systemFontOfSize:25.0f];
            self.mainTableView.tableHeaderView = view;

            [self.mainTableView reloadData];
            
            if ([list_array count] == 0) {
                
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

-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
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
    view.backgroundColor = [UIColor whiteColor];
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
