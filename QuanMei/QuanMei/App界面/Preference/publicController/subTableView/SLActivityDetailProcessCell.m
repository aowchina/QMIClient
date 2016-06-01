//
//  SLActivityDetailProcessCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailProcessCell.h"

#import "SLActivityModel.h"

#define SLDescLabelFontSize 12.f
#define SLSpace 80.f
#define SLDescLabelMagin 10.f

@interface SLActivityDetailProcessCell ()
{
    UILabel * noteLabel;
}

@end

@implementation SLActivityDetailProcessCell

//12-13
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubView];
        
        //        self.contentView.backgroundColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.5];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - builder SubView
- (void)buildSubView {
    
    
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.text = @"  预约流程";
    _headerLabel.backgroundColor = [UIColor backgroundColor];
    
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.headerLabel];
    
    //流程
    self.processLabel = [[UILabel alloc] init];
    
    _processLabel.font = [UIFont fontWithName:@"Arial" size:15];
    
    _processLabel.textColor = [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1];

    _processLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.processLabel];
    
    
    //流程须知
    noteLabel = [[UILabel alloc]init];
    
    noteLabel.text = @"  预约须知";
    
    noteLabel.backgroundColor = [UIColor backgroundColor];
    
    [self addSubview:noteLabel];
    
    //备注
    self.attentionLabel = [[UILabel alloc] init];
    
    _attentionLabel.font = [UIFont fontWithName:@"Arial" size:15];
    
    _attentionLabel.textColor =  [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1];

    _attentionLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.attentionLabel];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerLabel.frame = CGRectMake(0, 0, SLGetScreenWidth(), 40);

    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    CGSize size = CGSizeMake(self.contentView.frame.size.width - SLDescLabelMagin *2, MAXFLOAT);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    CGSize processHeight = [_processLabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    
    self.processLabel.frame = CGRectMake(SLDescLabelMagin,
                                         _headerLabel.frame.size.height + _headerLabel.frame.origin.y + SLDescLabelMagin,
                                         SLGetScreenWidth()- SLDescLabelMagin * 2,
                                         processHeight.height);
    
    
    CGSize attentionHeight = [_attentionLabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    
    //须知
    noteLabel.frame = CGRectMake(0, processHeight.height +_headerLabel.frame.size.height + SLDescLabelMagin*2, SLGetScreenWidth(), 30);
    
    self.attentionLabel.frame = CGRectMake(SLDescLabelMagin,
                                           processHeight.height +_headerLabel.frame.size.height + SLDescLabelMagin*3 +noteLabel.frame.size.height,
                                           SLGetScreenWidth() - SLDescLabelMagin * 2,
                                           attentionHeight.height);
    
}
#pragma mark - override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];
    
    _processLabel.text = activity.lc;
    
    _attentionLabel.text = activity.lcnote;
    
}
//12-14
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    CGSize size = CGSizeMake(SLGetScreenWidth() - SLDescLabelMagin *2, MAXFLOAT);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    CGSize processHeight = [activity.lc boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    
    CGSize attentionHeight = [activity.lcnote boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;

    return 40 + processHeight.height + 30 + attentionHeight.height +SLDescLabelMagin * 4;
}

@end
