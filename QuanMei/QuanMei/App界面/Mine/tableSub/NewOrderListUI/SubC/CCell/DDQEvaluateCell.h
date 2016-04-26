//
//  DDQEvaluateCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQPayCell.h"

@interface DDQEvaluateCell : UITableViewCell<ModelDelegate>

@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *evaluate_button;
/**
 *  这个订单现在的状态
 */
@property (strong, nonatomic) UILabel *state_label;

@property ( assign, nonatomic) CGFloat cell_h;

@end
