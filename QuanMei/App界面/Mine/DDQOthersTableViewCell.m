//
//  DDQOthersTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQOthersTableViewCell.h"

@implementation DDQOthersTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setOthersModel:(DDQOthersModel *)othersModel {
    
    CGFloat spliteLeft = 10;
    CGFloat view_width = kScreenWidth * 0.25;
    
    
    
    if (othersModel.imgArray != 0) {
        
        self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, kScreenHeight * 0.2)];
        [self.contentView addSubview:self.mainScroll];
        self.mainScroll.contentSize   = CGSizeMake(view_width * othersModel.imgArray.count + spliteLeft * othersModel.imgArray.count, self.mainScroll.frame.size.height);
        self.mainScroll.pagingEnabled = YES;
        self.mainScroll.showsHorizontalScrollIndicator = NO;
        
        
        for (int i = 0; i<othersModel.imgArray.count; i++) {
            UIImageView *temp_View         = [[UIImageView alloc] initWithFrame:CGRectMake(spliteLeft * i + view_width * i, 10, view_width,view_width)];
            [temp_View sd_setImageWithURL:[NSURL URLWithString:[othersModel.imgArray[i] valueForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            [self.mainScroll addSubview:temp_View];
            
            UILabel *temp_label = [[UILabel alloc] initWithFrame:CGRectMake(spliteLeft * i + view_width * i, 10+temp_View.frame.size.height, view_width,15)];
            [self.mainScroll addSubview:temp_label];
            temp_label.textAlignment = NSTextAlignmentCenter;
            temp_label.text = [othersModel.imgArray[i] valueForKey:@"name"];
            temp_label.font = [UIFont systemFontOfSize:12.0f];
        }
        self.img_height = kScreenHeight * 0.2;
    } else {
    
        self.img_height = 0 ;

    }
    
}
@end
