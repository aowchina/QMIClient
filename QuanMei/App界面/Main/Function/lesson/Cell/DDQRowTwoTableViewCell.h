//
//  DDQRowTwoTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQRowTwoTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *rt_countLabel;
@property (strong,nonatomic) UIButton *rt_minusBtn;
@property (strong,nonatomic) UIButton *rt_addBtn;
@property (strong,nonatomic) UILabel *rt_showLabel;

@property (assign,nonatomic) int lesson_count;

@end
