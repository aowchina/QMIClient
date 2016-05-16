//
//  DDQOrderCell.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderModel : NSObject

@property ( strong, nonatomic) NSString *create_time;
@property ( strong, nonatomic) NSString *dj;
@property ( strong, nonatomic) NSString *fname;
@property ( strong, nonatomic) NSString *hid;
@property ( strong, nonatomic) NSString *hname;
@property ( strong, nonatomic) NSString *name;
@property ( strong, nonatomic) NSString *newval;
@property ( strong, nonatomic) NSString *orderid;
@property ( strong, nonatomic) NSString *simg;
@property ( strong, nonatomic) NSString *status;
@property ( strong, nonatomic) NSString *tel;
@property ( strong, nonatomic) NSString *tid;
@property ( strong, nonatomic) NSString *userid;

@property ( assign, nonatomic) BOOL showSelected;

@end

#import "DDQPayModel.h"

@interface DDQOrderCell : UITableViewCell

@property (strong, nonatomic) UILabel *time_label;
@property (strong, nonatomic) UILabel *orderid_label;
@property (strong, nonatomic) UIImageView *goods_img;
@property (strong, nonatomic) UILabel *description_label;
@property (strong, nonatomic) UILabel *hospital_label;
@property (strong, nonatomic) UILabel *total_label;
@property (strong, nonatomic) UILabel *content_label;
@property (strong, nonatomic) UIButton *evaluate_button;

@property ( strong, nonatomic) UIButton *circle_button;

@property ( assign, nonatomic) CGFloat cell_h;

@property ( strong, nonatomic) DDQPayModel *model;


@end

