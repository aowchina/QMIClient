//
//  DDQPostingCollectionViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/22.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQPostingCollectionViewCell.h"

@implementation DDQPostingCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _postingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.1, self.contentView.frame.size.height*0.1, self.contentView.frame.size.width*0.8, self.contentView.frame.size.height*0.8)];
    
    
    [self.contentView addSubview:_postingImageView];
    
    _postingCancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _postingCancelButton.frame = CGRectMake(self.contentView.frame.size.width*0.8, 0, self.contentView.frame.size.width*0.2, self.contentView.frame.size.height*0.2);
    
    [self.contentView addSubview:_postingCancelButton];
    
    return self;
}
@end
