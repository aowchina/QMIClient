//
//  DDQHospitalImageCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQHospitalModel.h"
@interface DDQHospitalImageCell : UITableViewCell
@property (strong,nonatomic) UIScrollView *myScrollView;
@property (strong,nonatomic) DDQHospitalModel *hospitalModel;
@end
