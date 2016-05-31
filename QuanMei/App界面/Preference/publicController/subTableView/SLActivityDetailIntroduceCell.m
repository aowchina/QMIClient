//
//  SLActivityDetailIntroduceCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailIntroduceCell.h"

#import "SLActivityModel.h"

#define SLDescLabelFontSize 12.f
#define SLSpace 60.f
#define SLDescLabelMagin 10.f

@interface SLActivityDetailIntroduceCell ()


@end

@implementation SLActivityDetailIntroduceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubView];
    }
    return self;
}
#pragma mark - builder SubView
- (void)buildSubView {
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.text = @"  活动介绍";
    
    _headerLabel.backgroundColor = [UIColor backgroundColor];
    
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.headerLabel];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textColor = [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1];

    self.descLabel.numberOfLines = 0;
    
    self.descLabel.font = [UIFont fontWithName:@"Arial" size:15];

    [self.contentView addSubview:self.descLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerLabel.frame = CGRectMake(0, 0, SLGetScreenWidth(), 40);
    
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    CGSize size = CGSizeMake(300, MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    //    CGSize labelsize = [activity.intro sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize  a = [self.descLabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:tdic context:nil].size;
    self.descLabel.frame = CGRectMake(SLDescLabelMagin,
                                      _headerLabel.frame.size.height+SLDescLabelMagin,
                                      self.contentView.bounds.size.width - SLDescLabelMagin * 2.f,
                                      a.height);
}

#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];
    
//    self.descLabel.text = @"fdsafdsafdsakgjldfghdflkshgjkfdsgkdajdasljgdahgjkfdahgdkjsalgdkas";
    //活动介绍
    self.descLabel.text = activity.intro;//(接口文档不明确,不确定是不是这个key);
    
}
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
//    CGFloat descHeight = [activity.introduce sizeWithFont:[UIFont systemFontOfSize:SLDescLabelFontSize]
//                                        constrainedToSize:CGSizeMake(SLGetScreenWidth() - SLDescLabelMagin * 2.f, FLT_MAX)].height;
    
//    descHeight += SLSpace;
    
//    return descHeight;
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    CGSize size = CGSizeMake(300, MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    //    CGSize labelsize = [activity.intro sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize  a = [activity.intro boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:tdic context:nil].size;

    return (a.height + SLSpace);
}

@end
