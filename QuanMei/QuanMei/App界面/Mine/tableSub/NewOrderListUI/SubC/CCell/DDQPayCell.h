//
//  DDQPayCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModelDelegate <NSObject>

@property ( strong, nonatomic) NSString *time;
@property ( strong, nonatomic) NSString *order;
@property ( strong, nonatomic) NSString *intro;
@property ( strong, nonatomic) NSString *hosipital;
@property ( strong, nonatomic) NSString *price;
@property ( strong, nonatomic) NSString *content;

@end

@interface DDQPayCell : UITableViewCell<ModelDelegate>

@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *pay_button;

@property ( assign, nonatomic) CGFloat cell_h;

@end
