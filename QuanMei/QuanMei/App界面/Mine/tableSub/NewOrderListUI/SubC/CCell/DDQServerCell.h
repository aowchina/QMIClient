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

@end

@interface DDQServerCell : UITableViewCell

@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *cancel_button;
/**
 *  这个订单现在的状态
 */
@property (strong, nonatomic) UILabel *state_label;

@property ( weak, nonatomic) id <ServerCellDelegate> delegate;

- (CGFloat)heightForCellWithModel:(DDQPayModel *)pay_model;

@property ( assign, nonatomic) CGFloat cell_h;

@end
