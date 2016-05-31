//
//  DDQHospitalNameCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQHospitalNameCell : UITableViewCell

/**
 *  医院小图片
 */
@property (strong,nonatomic) UIImageView *hospitalImage;

/**
 *  医院名称
 */
@property (strong,nonatomic) UILabel *hospitalName;

-(void)cellWithLogo:(NSString *)logo andHospitalName:(NSString *)hospitalName;

@end
