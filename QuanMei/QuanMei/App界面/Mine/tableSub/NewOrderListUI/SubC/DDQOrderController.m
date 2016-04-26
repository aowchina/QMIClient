//
//  DDQOrderController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQOrderController.h"

#import "DDQOrderCell.h"

@interface DDQOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *order_table;

@property ( assign, nonatomic) CGFloat cell_h;

@end

@implementation DDQOrderController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.order_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluate"];
    if (cell == nil) {
        
        cell = [[DDQOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"evaluate"];
        
    }
    
    cell.time = @"2016-05-06";
    cell.order = @"订单号:40008-820-8-820 THC你值得拥有";
    cell.intro = @"医院（Hospital）一词是来自于拉丁文原意为“客人”，因为一开始设立时，是供人避难，还备有休息间，使来者舒适，有招待意图";
    cell.content =  @"共10000000件商品，总计0.01元";
    cell.hosipital = @"北京武警医院要有意义有意义有";
    cell.price = @"￥10000000";
    
    self.cell_h = cell.cell_h;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cell_h > 0) {
        
        return self.cell_h;
        
    } else {
        
        return 280;
        
    }
    
}

@end
