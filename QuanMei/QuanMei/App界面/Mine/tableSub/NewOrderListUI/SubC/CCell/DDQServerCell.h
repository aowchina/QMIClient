//
//  DDQServerCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQPayModel.h"

@class DDQServerCell;
@protocol ServerCellDelegate <NSObject>

@optional
- (void)serverCell_cancelButtonSelectedMethod:(DDQServerCell *)cell Model:(DDQPayModel *)model;
- (void)serverCell_addManeyButtonSelectedMethod:(DDQServerCell *)cell Model:(DDQPayModel *)model;


@end

@interface DDQServerCell : UITableViewCell



@property ( weak, nonatomic) id <ServerCellDelegate> delegate;

- (CGFloat)heightForCellWithModel:(DDQPayModel *)pay_model;

@end
