//
//  DDQPersonHeadImageCell.h
//  QuanMei
//
//  Created by min-fo013 on 15/10/16.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDQMineInfoModel;

@interface DDQPersonHeadImageCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong)UIImageView *headView;
@property (nonatomic, strong)DDQMineInfoModel *mineInfoModel;

@end

