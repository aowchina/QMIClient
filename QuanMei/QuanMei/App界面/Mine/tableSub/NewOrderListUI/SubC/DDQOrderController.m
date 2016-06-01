//
//  DDQOrderController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQOrderController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DDQNewOrderDetailController.h"
#import "DDQOrderCell.h"
#import "DDQPayModel.h"

@interface DDQOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *order_table;

@property ( assign, nonatomic) CGFloat cell_h;
@property (weak, nonatomic) IBOutlet UIButton *circle_button;
@property (weak, nonatomic) IBOutlet UILabel *total_label;
@property (weak, nonatomic) IBOutlet UIButton *pay_button;
@property ( strong, nonatomic) NSMutableArray *orderC_source;

@end

@implementation DDQOrderController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.order_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.orderC_source = [NSMutableArray array];
    [self orderC_netServerWithPage:1];
    
    /**
     *  重载上下拉
     */
    self.order_table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.orderC_source removeAllObjects];
        [self orderC_netServerWithPage:1];
        [self.order_table.header endRefreshing];
        
    }];
    
    self.order_table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        page_num = page_num + 1;
        [self orderC_netServerWithPage:page_num];
        [self.order_table.footer endRefreshing];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kFreshOrderCNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self.orderC_source removeAllObjects];
        [self orderC_netServerWithPage:1];
        
    }];

}

static int page_num = 2;
- (void)orderC_netServerWithPage:(int)page {
    
    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderUrl ParamArray:@[self.userid,@"5",[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
        
        if (!analysis_error) {
            
            for (NSDictionary *dic in source) {
                
                DDQPayModel *order_model = [DDQPayModel mj_objectWithKeyValues:dic];
                [self.orderC_source addObject:order_model];
                
            }
            
            [self.order_table reloadData];
            [self.wait_hud hide:YES];
            if ([source count] == 0) {
                
                self.order_table.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.order_table.footer.state = MJRefreshStateIdle;
                
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
    
    return self.orderC_source.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluate"];
    if (cell == nil) {
        
        cell = [[DDQOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"evaluate"];
        
    }
   
    DDQPayModel *model = nil;
    if (self.orderC_source.count > 0) {
        
        model = self.orderC_source[indexPath.row];
        
    }
    cell.model = model;
    self.cell_h = cell.cell_h;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cell_h > 0) {
        
        return self.cell_h;
        
    } else {
        
        return 1;
        
    }
    
}

- (IBAction)circle_buttonSelectedMethod:(UIButton *)sender {
    
    if ([sender isSelected] == NO) {
        
        [sender setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected_"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        for (OrderModel *model in self.orderC_source) {
            
            model.showSelected = YES;
            
        }
        [self.order_table reloadData];
        
    } else {
    
        [sender setBackgroundImage:[UIImage imageNamed:@"img_Gray-is-selected"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        for (OrderModel *model in self.orderC_source) {
            
            model.showSelected = NO;
            
        }
        [self.order_table reloadData];
        
    }
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQPayModel *model = self.orderC_source[indexPath.row];
    DDQNewOrderDetailController *new_orderDetailC = [[DDQNewOrderDetailController alloc] init];
    new_orderDetailC.orderid = model.orderid;
    [self.navigationController pushViewController:new_orderDetailC animated:YES];
    
}
@end
