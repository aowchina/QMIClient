//
//  DDQFirstSectionViewItem.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypesModel.h"

@interface DDQFirstSectionViewItem : UICollectionViewCell

/**
 *  身体部位
 */
@property (strong,nonatomic) UILabel *positionLabel;
@property (strong,nonatomic) TypesModel *model;
@end
