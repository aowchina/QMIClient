//
//  DDQPayCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQPayModel.h"

@class DDQPayCell;
@protocol PayCellDelegate <NSObject>

@optional
- (void)paybutton_selectedMethod:(DDQPayCell *)pay_cell Model:(DDQPayModel *)model;
- (void)cancelbutton_selectedMethod:(DDQPayCell *)pay_cell Model:(DDQPayModel *)model;

@end

@interface DDQPayCell : UITableViewCell

@property ( strong, nonatomic) DDQPayModel *pay_model;

@property ( assign, nonatomic) CGFloat cell_h;

@property ( weak, nonatomic) id <PayCellDelegate> delegate;

@end

