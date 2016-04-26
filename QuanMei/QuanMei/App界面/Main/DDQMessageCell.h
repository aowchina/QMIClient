//
//  DDQMessageCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mesCell_image;
@property (weak, nonatomic) IBOutlet UILabel *mesCell_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mesCell_introLabel;
@property (weak, nonatomic) IBOutlet UILabel *mesCell_pubtimeLabel;


@end
