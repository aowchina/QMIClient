//
//  DDQHospitalIntroCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalIntroCell.h"

@implementation DDQHospitalIntroCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)introLabelText:(NSString *)intro {
    UILabel *introLabel = [[UILabel alloc] init];
    
    _newRect = [intro boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    introLabel.frame = CGRectMake(0, 0, _newRect.size.width, _newRect.size.height);
    introLabel.numberOfLines = 0;
    introLabel.text = intro;
    introLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:introLabel];
}



@end
