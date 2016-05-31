//
//  DDQHospitalIntroCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQHospitalIntroCell : UITableViewCell
/**
 *  新的高度
 */
@property (assign,nonatomic) CGRect newRect;


-(void)introLabelText:(NSString *)intro;

@end
