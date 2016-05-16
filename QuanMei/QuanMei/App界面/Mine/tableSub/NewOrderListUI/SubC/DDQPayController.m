//
//  DDQPayController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQPayController.h"

#import "DDQPayCell.h"
#import "DDQNewPayController.h"
#import "DDQNewOrderDetailController.h"
#import "DDQPayModel.h"

@interface DDQPayController ()<UITableViewDataSource,UITableViewDelegate,PayCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pay_table;
@property ( assign, nonatomic) CGFloat cell_h;
@property ( strong, nonatomic) NSMutableArray *payC_source;

@end

@implementation DDQPayController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pay_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.payC_source = [NSMutableArray array];
    
    [self pay_controllerNetWithPage:1];
    
    /**
     *  重载上下拉
     */
    self.pay_table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.payC_source removeAllObjects];
        [self pay_controllerNetWithPage:1];
        [self.pay_table.header endRefreshing];
        
    }];
    
    self.pay_table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        int page = page_num + 1;
        [self pay_controllerNetWithPage:page];
        [self.pay_table.footer endRefreshing];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"fresh" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self.payC_source removeAllObjects];
        [self pay_controllerNetWithPage:1];
        
    }];
    
}
/**
 *  网络请求
 *
 *  @param page 页码
 */
static int page_num = 2;
- (void)pay_controllerNetWithPage:(int)page {

    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderUrl ParamArray:@[self.userid,@"1",[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
    
        if (!analysis_error) {
            
            for (NSDictionary *dic in source) {
                
                DDQPayModel *pay_model = [DDQPayModel mj_objectWithKeyValues:dic];
                [self.payC_source addObject:pay_model];
                
            }
            
            [self.pay_table reloadData];
            [self.wait_hud hide:YES];
            
            if ([source count] == 0) {
                
                self.pay_table.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.pay_table.footer.state = MJRefreshStateIdle;
                
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

    return self.payC_source.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pay"];
    if (cell == nil) {
        
        cell = [[DDQPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pay"];
        
    }
    DDQPayModel *pay_model = nil;
    if (self.payC_source.count > 0) {
        
        pay_model = self.payC_source[indexPath.row];
        
    }
    
    cell.pay_model = pay_model;
    self.cell_h = cell.cell_h;
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.cell_h > 0) {
        
        return self.cell_h;
        
    } else {
        
        return 1;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    DDQPayModel *pay_model = self.payC_source[indexPath.row];
//    DDQNewOrderDetailController *new_order_detailC = [[DDQNewOrderDetailController alloc] init];
//    new_order_detailC.orderid = pay_model.orderid;
//    [self.navigationController pushViewController:new_order_detailC animated:YES];
    DDQNewPayController *new_payC = [[DDQNewPayController alloc] init];
    new_payC.orderid = pay_model.orderid;
    [self.navigationController pushViewController:new_payC animated:YES];
    
}

- (void)paybutton_selectedMethod:(DDQPayCell *)pay_cell Model:(DDQPayModel *)model {
    
    DDQNewPayController *new_payC = [[DDQNewPayController alloc] init];
    new_payC.orderid = model.orderid;
    [self.navigationController pushViewController:new_payC animated:YES];
    
}

@end
