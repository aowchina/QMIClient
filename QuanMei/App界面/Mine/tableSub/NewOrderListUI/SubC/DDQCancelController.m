//
//  DDQCancelController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQCancelController.h"
#import "DDQNewOrderDetailController.h"
#import "DDQCancelCell.h"

#import "DDQPayModel.h"

@interface DDQCancelController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cancel_table;

@property ( assign, nonatomic) CGFloat cell_h;
/**
 *  数据源
 */
@property ( strong, nonatomic) NSMutableArray *cancelC_source;

@end

@implementation DDQCancelController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.cancel_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    /**
     *  数据获取
     */
    self.cancelC_source = [NSMutableArray array];
    [self cancelC_netServerWithPage:1];
    
    /**
     *  重载上下拉
     */
    self.cancel_table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.cancelC_source removeAllObjects];
        [self cancelC_netServerWithPage:1];
        [self.cancel_table.header endRefreshing];
        
    }];
    
    self.cancel_table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        page_num = page_num + 1;
        [self cancelC_netServerWithPage:page_num];
        [self.cancel_table.footer endRefreshing];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kFreshCancelCNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    
        [self.cancelC_source removeAllObjects];
        [self cancelC_netServerWithPage:1];
        
    }];
    
}

static int page_num = 2;
- (void)cancelC_netServerWithPage:(int)page {
    
    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderUrl ParamArray:@[self.userid,@"4",[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
        
        if (!analysis_error) {
            
            for (NSDictionary *dic in source) {

                DDQPayModel *pay_model = [DDQPayModel mj_objectWithKeyValues:dic];
                [self.cancelC_source addObject:pay_model];
                
            }
            
            [self.cancel_table reloadData];
            [self.wait_hud hide:YES];
            if ([source count] == 0) {
                
                self.cancel_table.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.cancel_table.footer.state = MJRefreshStateIdle;
                
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
    
    return self.cancelC_source.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cancel"];
    if (cell == nil) {
        
        cell = [[DDQCancelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cancel"];
        
    }

    DDQPayModel *pay_model = nil;
    if (self.cancelC_source.count > 0) {
        
        pay_model = self.cancelC_source[indexPath.row];
        
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
    
    DDQPayModel *model = self.cancelC_source[indexPath.row];
    DDQNewOrderDetailController *new_orderDetailC = [[DDQNewOrderDetailController alloc] init];
    new_orderDetailC.orderid = model.orderid;
    [self.navigationController pushViewController:new_orderDetailC animated:YES];
    
}

@end
