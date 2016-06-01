//
//  DDQTableViewCell.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQButton.h"

typedef void(^MyCellBlock)(DDQItem *item);

@interface DDQTableViewCell : UITableViewCell

@property(nonatomic,strong,readonly)NSArray *arrItem;

@property(nonatomic,assign,readonly)BOOL showAll;


-(void)cellBlock:(MyCellBlock )thisblock;

-(void)setItemArr:(NSArray *)arrItem andShowAll:(BOOL)boolean;

@end
