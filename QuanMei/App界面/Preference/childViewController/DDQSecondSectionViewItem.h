//
//  DDQSecondSectionViewItem.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TypesModel.h"
#import "ListModel.h"
@interface DDQSecondSectionViewItem : UICollectionViewCell

/**
 *  图片你懂得
 */
@property (strong,nonatomic) UIImageView *picImageView;
/**
 *  标题你懂得
 */
@property (strong,nonatomic) UILabel *titleLabel;
/**
 *  项目简介你懂得
 */
@property (strong,nonatomic) UILabel *descriptionLabel;

@property (nonatomic,strong) ListModel *model;
@end
