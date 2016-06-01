//
//  DDQMyCollectCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQMyCollectModel.h"
@interface DDQMyCollectCell : UITableViewCell

/**
 *  cell总共高多少
 */
@property (assign,nonatomic) CGFloat cell_height;
@property (strong,nonatomic) DDQMyCollectModel *myCollectModel;
@end
