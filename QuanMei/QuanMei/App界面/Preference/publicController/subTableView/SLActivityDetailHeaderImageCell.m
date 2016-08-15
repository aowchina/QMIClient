//
//  SLActivityDetailHeaderImageCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailHeaderImageCell.h"

#import "SLActivityModel.h"

#define SLDescLabelFontSize 12.f
#define SLSpace 80.f
#define SLDescLabelMagin 6.f
@interface SLActivityDetailHeaderImageCell ()


@end
@implementation SLActivityDetailHeaderImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubView];
    }
    return self;
}
#pragma mark - builder SubView
- (void)buildSubView {
    self.photo = [[UIImageView alloc] init];
   // [self.photo setImage:[UIImage imageNamed:@"示例图片.jpg"]];
    [self.contentView addSubview:self.photo];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.photo.frame = self.contentView.bounds;
}
#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];
    
    //头部大图
    //12-22
    [self.photo sd_setImageWithURL:[NSURL URLWithString:activity.bimg] placeholderImage:[UIImage imageNamed:@"default_big_pic"]];//setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.bimg]]]];
}
//12-14
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    return kScreenWidth/1.9;
}

@end
