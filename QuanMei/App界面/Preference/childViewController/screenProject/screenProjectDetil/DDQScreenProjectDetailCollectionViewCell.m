//
//  DDQScreenProjectDetailCollectionViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectDetailCollectionViewCell.h"

@implementation DDQScreenProjectDetailCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIView *view = [[UIView alloc]init];
        
        view.frame = CGRectMake(10, 10, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-20);
        
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        
        [self.contentView addSubview:view];
        
        
        _typeLabel =[[UILabel alloc]initWithFrame:view.bounds];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont boldSystemFontOfSize:12];
        
        [view addSubview:_typeLabel];
        
    }
    return self;
}
@end
