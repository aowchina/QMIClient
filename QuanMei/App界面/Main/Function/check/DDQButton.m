//
//  DDQButton.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQButton.h"

@implementation DDQButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor backgroundColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = frame.size.height*0.2;
    }
    return self;
}

-(void)setItem:(DDQItem *)item{
    _item = item;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self setTitle:item.name forState:UIControlStateNormal];
}

@end
