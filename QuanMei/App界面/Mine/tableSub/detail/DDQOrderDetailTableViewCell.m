//
//  DDQOrderDetailTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQOrderDetailTableViewCell.h"

@implementation DDQOrderDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[ UILabel alloc]init];
        _titleLabel.textAlignment = 0;
        
        _titleLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_titleLabel];
        
        
        _contentLabel = [[UILabel alloc]init];
        
        _contentLabel.font = [UIFont systemFontOfSize:14];
        
        _contentLabel.textAlignment = 2;
        
        [self.contentView addSubview:_contentLabel];
    
    
    }
    return self;
}
-(void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(10, 0, (self.contentView.frame.size.width/2)-10, self.frame.size.height);
    
    _contentLabel.frame = CGRectMake(self.contentView.frame.size.width/2, 0, (self.contentView.frame.size.width/2)-10, self.contentView.frame.size.height);
}
@end
