//
//  LoopCollectionViewCell.m
//  我的轮播图
//
//  Created by Min-Fo_003 on 16/2/2.
//  Copyright © 2016年 ddq. All rights reserved.
//

#import "LoopCollectionViewCell.h"

@implementation LoopCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.loop_img = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.loop_img];
    }
    return self;
}


@end
