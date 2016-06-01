//
//  DDQDetailControllerProjectCell.h
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/28.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQDetailControllerProjectCell : UITableViewCell
/**
 *  背景view
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  模特图片
 */
@property (strong,nonatomic) UIImageView *modelImageView;
/**
 *  项目简介
 */
@property (strong,nonatomic) UILabel *projectIntro;
/**
 *  项目所在医院
 */
@property (strong,nonatomic) UILabel *projectHospital;
/**
 *  项目报价
 */
@property (strong,nonatomic) UILabel *projectPrice;
/**
 *  销售数量
 */
@property (strong,nonatomic) UILabel *sellNum;
@end
