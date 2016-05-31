//
//  DDQRowThreeTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/24.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQTeacherIntroModel.h"

@interface DDQRowThreeTableViewCell : UITableViewCell
@property (strong,nonatomic) UIView *temp_view;
@property (strong,nonatomic) DDQTeacherIntroModel *intro_model;
@property (assign,nonatomic) CGFloat row_h;
@end

