//
//  DDQEvaluateCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQPayModel.h"

@protocol EvaluateCellDelegate <NSObject>

@optional
- (void)evaluate_cellSelectedButtonMethod:(DDQPayModel *)model;

@end

@interface DDQEvaluateCell : UITableViewCell

@property ( strong, nonatomic) id <EvaluateCellDelegate> delegate;

- (CGFloat)heightForCellWithModel:(DDQPayModel *)pay_model;


@end
