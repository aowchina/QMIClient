//
//  DDQGroupCollectionViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/21.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQGroupCollectionViewCell.h"
//12-04
@implementation DDQGroupCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = [[UILabel alloc]init];
        
        _title.textColor = [UIColor blackColor];
        _title.textAlignment  =1;
        
        //10-30
        _title.font = [UIFont systemFontOfSize:13];
        [self addSubview:_title];
    }
    return self;
}
- (void)layoutSubviews
{
    _title.frame = self.contentView.bounds;
}

@end
