//
//  SLActivityDetailBaseCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailBaseCell.h"

static CGFloat p_screenWidth = 0;
CGFloat SLGetScreenWidth() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p_screenWidth = [UIScreen mainScreen].bounds.size.width;
    });
    return p_screenWidth;
}

@interface SLActivityDetailBaseCell ()

@property (nonatomic, strong, readwrite) SLActivityModel *activity;

@end

@implementation SLActivityDetailBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    self.activity = activity;
    
//    self.textLabel.text = NSStringFromClass([self class]);
}

+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    NSAssert2(NO, @"请子类调用实现，不要调用父类方法", __FUNCTION__, __LINE__);
    return 0;
}

@end
