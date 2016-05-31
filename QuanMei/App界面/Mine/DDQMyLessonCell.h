//
//  DDQMyLessonCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/24.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQMyLessonModel.h"
@interface DDQMyLessonCell : UITableViewCell

@property (strong,nonatomic) UILabel *title_label;
@property (strong,nonatomic) UILabel *dingdan_label;
@property (strong,nonatomic) DDQMyLessonModel *lesson_model;
@property (assign,nonatomic) CGFloat new_rect;
@end
