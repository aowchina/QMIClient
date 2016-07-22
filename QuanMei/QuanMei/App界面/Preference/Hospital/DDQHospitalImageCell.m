//
//  DDQHospitalImageCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalImageCell.h"

@implementation DDQHospitalImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kScreenHeight*0.15)];
        [self.contentView addSubview:self.myScrollView];
    }
    return self;
}

-(void)setHospitalModel:(DDQHospitalModel *)hospitalModel {
    
    CGFloat imageW;
    if (hospitalModel.xcimg.count <= 3) {
        
        imageW = self.myScrollView.frame.size.width / hospitalModel.xcimg.count;
        
    } else {
        
        imageW = self.myScrollView.frame.size.width * 0.25;

    }
    CGFloat splitL = 5;
    CGFloat imageH = self.myScrollView.frame.size.height;
    
    for (int i = 0; i<hospitalModel.xcimg.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW * i + splitL * i, 0, imageW, imageH)];
        [self.myScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:hospitalModel.xcimg[i]]];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *image_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImageValue:)];
        [imageView addGestureRecognizer:image_tap];
        imageView.tag = i;
    }
    
    self.myScrollView.contentSize                    = CGSizeMake(imageW * hospitalModel.xcimg.count + splitL * hospitalModel.xcimg.count, 0);
    self.myScrollView.showsHorizontalScrollIndicator = NO;
}

-(void)getImageValue:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)[tap view];
    NSString *string = [NSString stringWithFormat:@"%d",imageView.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil userInfo:@{@"viewtag":string}];
}


@end
