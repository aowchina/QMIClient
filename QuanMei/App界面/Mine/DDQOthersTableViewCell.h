//
//  DDQOthersTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQOthersModel.h"
@interface DDQOthersTableViewCell : UITableViewCell

/**
 *  说不定能滑呢
 */
@property (strong,nonatomic) UIScrollView *mainScroll;

/**
 *  新高度
 */
@property (assign,nonatomic) CGFloat img_height;

@property (strong,nonatomic) DDQOthersModel *othersModel;

@end
