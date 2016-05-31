//
//  DDQUserDetailCell.h
//  QuanMei
//
//  Created by superlian on 15/12/3.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQUserDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
