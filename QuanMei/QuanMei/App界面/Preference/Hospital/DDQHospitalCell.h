//
//  DDQHospitalCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQHospitalCell : UITableViewCell
/**
 *  医院小图片
 */
@property (strong,nonatomic) UIImageView *hospitalImage;

/**
 *  医院名称
 */
@property (strong,nonatomic) UILabel *hospitalName;
@end
