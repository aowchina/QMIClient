//
//  DDQMainHotProjectTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/15.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQMainHotProjectTableViewCell : UITableViewCell
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
 *  旧的报价
 */
@property (strong,nonatomic) UILabel *oldPrice;
/**
 *  销售数量
 */
@property (strong,nonatomic) UILabel *sellNum;
@end
