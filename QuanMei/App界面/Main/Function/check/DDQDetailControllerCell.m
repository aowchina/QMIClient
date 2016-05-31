//
//  DDQDetailControllerCell.m
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/27.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDetailControllerCell.h"

#import "Masonry.h"

@implementation DDQDetailControllerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        [self.contentView addSubview:self.titleLabel];
      
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.frame.size.height*0.3, self.contentView.frame.size.width-10, self.contentView.frame.size.height*0.7)];
        [self.contentView addSubview:self.descriptionLabel];
        
        [self.descriptionLabel setFont:[UIFont systemFontOfSize:15]];
        [self.descriptionLabel setNumberOfLines:0];
    }
    return self;
}

@end
