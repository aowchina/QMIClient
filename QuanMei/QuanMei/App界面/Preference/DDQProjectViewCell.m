//
//  DDQProjectViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQProjectViewCell.h"

@implementation DDQProjectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if (kScreenHeight == 480) {
            
            self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight*0.3)];
            [self.contentView addSubview:self.currentView];
            
        } else if (kScreenHeight == 568) {
            
            self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight*0.3)];
            [self.contentView addSubview:self.currentView];
            
        } else if (kScreenHeight == 667) {
            
            self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, kScreenHeight*0.3)];
            [self.contentView addSubview:self.currentView];
            
        } else {
            
            self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, kScreenHeight*0.3)];
            [self.contentView addSubview:self.currentView];
            
        }
        
    }
    
    return self;
    
}


@end
