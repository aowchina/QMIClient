//
//  DDQThemeActivityCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainActModel.h"

@interface DDQThemeActivityCell : UITableViewCell

@property (strong,nonatomic) UILabel *themeLabel;
/**
 *  背景美女图片
 */
@property (strong,nonatomic) UIImageView *backgroundImage;
/**
 *  下部显示参加人数和用户头像的view
 */
@property (strong,nonatomic) UIView *currentView;
/**
 *  参加的人数
 */
@property (strong,nonatomic) UILabel *joinNumLabel;
/**
 *  参与的用户的头像
 */
@property (strong,nonatomic) UIImageView *firstImageView;
@property (strong,nonatomic) UIImageView *secondImageView;

@property (strong,nonatomic) MainActModel *actModel;

@end
