//
//  DDQServerController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQServerController.h"

#import "DDQNewOrderDetailController.h"
#import "DDQServerCell.h"
#import "DDQEvaluateViewController.h"
#import "DDQPayModel.h"
#import "DDQNewPayController.h"

#import "DDQEvaluateCell.h"
#import "DDQOrderCell.h"

@interface DDQServerController ()<UITableViewDataSource,UITableViewDelegate,ServerCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *server_table;

@property ( assign, nonatomic) CGFloat cell_h;

@property ( strong, nonatomic) NSMutableArray *serverC_source;
/** 页码 */
@property (assign, nonatomic) int page;
@end

@implementation DDQServerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.serverC_source = [NSMutableArray array];
    self.server_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.page = 1;
    
    [self serverC_netServerWithPage:1];
    
    /**
     *  重载上下拉
     */
    self.server_table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.serverC_source removeAllObjects];
        [self serverC_netServerWithPage:self.page];
        [self.server_table.header endRefreshing];
        
    }];
    
    self.server_table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self serverC_netServerWithPage:self.page];
        [self.server_table.footer endRefreshing];

    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kFreshControllerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self.serverC_source removeAllObjects];
        [self serverC_netServerWithPage:1];
        
    }];
    
}

//static int page_num = 2;
- (void)serverC_netServerWithPage:(int)page {
    
    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderUrl ParamArray:@[self.userid,@"2",[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
        
        if (!analysis_error) {
            
            for (NSDictionary *dic in source) {
                
                DDQPayModel *pay_model = [DDQPayModel mj_objectWithKeyValues:dic];
                [self.serverC_source addObject:pay_model];
                
            }
            
            [self.server_table reloadData];
            [self.wait_hud hide:YES];
            if ([source count] == 0) {
                
                self.server_table.footer.state = MJRefreshStateNoMoreData;

            } else {
            
                self.server_table.footer.state = MJRefreshStateIdle;

            }
            
        } else {
            
            [self.wait_hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.serverC_source.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"server"];
    if (cell == nil) {
        
        cell = [[DDQServerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"server"];
        
    }
    cell.delegate = self;
    DDQPayModel *pay_model = nil;
    if (self.serverC_source.count > 0) {
        
        pay_model = self.serverC_source[indexPath.row];
        
    }

    self.cell_h = [cell heightForCellWithModel:pay_model];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.cell_h > 0) {
        
        return self.cell_h;
        
    } else {
        
        return 1;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQPayModel *model = self.serverC_source[indexPath.row];
    DDQNewOrderDetailController *new_orderDetailC = [[DDQNewOrderDetailController alloc] init];
    new_orderDetailC.orderid = model.orderid;
    [self.navigationController pushViewController:new_orderDetailC animated:YES];
    
}

- (void)serverCell_addManeyButtonSelectedMethod:(DDQServerCell *)cell Model:(DDQPayModel *)model {

    DDQNewPayController *new_payC = [[DDQNewPayController alloc] init];
    new_payC.orderid = model.orderid;
    new_payC.pay_type = WeiKuan;
    new_payC.what_pay = isPay;
    new_payC.c_type = kServerController;
    [self.navigationController pushViewController:new_payC animated:YES];
    
}

/**
 *  cell的代理
 *
 *  @param cell  这个cell
 *  @param model 这个cell的model
 */
- (void)serverCell_cancelButtonSelectedMethod:(DDQServerCell *)cell Model:(DDQPayModel *)model {

    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kBack_moneyUrl ParamArray:@[self.userid,model.orderid] Success:^(id source, NSError *analysis_error) {
        
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            NSInteger code = analysis_error.code;
            if (code == 13 || code == 18 || code == 20) {
                
                switch (code) {
                        
                    case 13:
                        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DDQLoginViewController alloc] init]];
                        break;
                        
                    case 18:
                        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DDQLoginViewController alloc] init]];
                        break;
                        
                    case 20:
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"订单不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        break;
                        
                    default:
                        break;
                        
                }
                
            } else {
                
                [self.wait_hud hide:YES];
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }
            
        } else {
        
            [self.wait_hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"操作成功，请等待退款" andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.serverC_source removeAllObjects];
            [self serverC_netServerWithPage:1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFreshCancelCNotification object:nil];
            
        }
        
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

@end
