//
//  DDQEvaluateController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQEvaluateController.h"
#import "DDQNewOrderDetailController.h"
#import "DDQEvaluateCell.h"
#import "DDQEvaluateViewController.h"
@interface DDQEvaluateController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *evaluate_table;

@property ( assign, nonatomic) CGFloat cell_h;

@property ( strong, nonatomic) NSMutableArray *evaluateC_source;

@end

@implementation DDQEvaluateController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.evaluate_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.evaluateC_source = [NSMutableArray array];
    [self evaluateC_netServerWithPage:1];
    /**
     *  重载上下拉
     */
    self.evaluate_table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.evaluateC_source removeAllObjects];
        [self evaluateC_netServerWithPage:1];
        [self.evaluate_table.header endRefreshing];
        
    }];
    
    self.evaluate_table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        int page = page_num + 1;
        [self evaluateC_netServerWithPage:page];
        [self.evaluate_table.footer endRefreshing];
        
    }];
    
}

static int page_num = 2;
- (void)evaluateC_netServerWithPage:(int)page {
    
    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderUrl ParamArray:@[self.userid,@"3",[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
        
        if (!analysis_error) {
            
            for (NSDictionary *dic in source) {
                
                DDQPayModel *pay_model = [DDQPayModel mj_objectWithKeyValues:dic];
                [self.evaluateC_source addObject:pay_model];
                
            }
            
            [self.evaluate_table reloadData];
            [self.wait_hud hide:YES];
            if ([source count] == 0) {
                
                self.evaluate_table.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.evaluate_table.footer.state = MJRefreshStateIdle;
                
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

    return self.evaluateC_source.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluate"];
    if (cell == nil) {
        
        cell = [[DDQEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"evaluate"];
        
    }
    DDQPayModel *pay_model = nil;
    if (self.evaluateC_source.count > 0) {
        
        pay_model = self.evaluateC_source[indexPath.row];
        
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
    
    DDQPayModel *model = self.evaluateC_source[indexPath.row];
//    DDQNewOrderDetailController *new_orderDetailC = [[DDQNewOrderDetailController alloc] init];
//    new_orderDetailC.orderid = model.orderid;
//    [self.navigationController pushViewController:new_orderDetailC animated:YES];
    DDQEvaluateViewController *vc = [[DDQEvaluateViewController alloc] init];
    vc.orderid = model.orderid;
    vc.hid = model.hid;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
