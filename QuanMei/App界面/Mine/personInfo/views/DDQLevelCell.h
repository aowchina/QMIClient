//
//  DDQLevelCell.h
//  QuanMei
//
//  Created by superlian on 15/12/2.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQLevelCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *rightLabel;

@property (nonatomic, assign, getter=isUserHighlighted) BOOL userHighlighted;

@end
