//
//  DDQOrderTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQOrderModel.h"

typedef void(^OrderCellBlock)();
//dingdan
//12-17
@interface DDQOrderTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *godsOrderImageView;

@property (nonatomic ,strong)UILabel *titleLabel;

@property (nonatomic ,strong)UILabel *hospitalLabel;

@property (nonatomic ,strong)UILabel *priceLabel;

@property (nonatomic ,strong)UILabel *typeLabel;

@property (nonatomic ,strong)DDQOrderModel * model;

@property (copy,nonatomic) OrderCellBlock block;
-(void)orderCellCallBackMethod:(OrderCellBlock)block;

@end
