//12-08
//  SLActivityDetailWebCell.m
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailWebCell.h"

#import "SLActivityModel.h"

#define SLDescLabelFontSize 12.f
#define SLSpace 80.f
#define SLDescLabelMagin 10.f

@interface SLActivityDetailWebCell ()

@end

@implementation SLActivityDetailWebCell

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
    
    self.headerLabel.text = @"  项目详情";
    self.headerLabel.backgroundColor = [UIColor backgroundColor];
    
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.headerLabel];

    _footImageView = [[UIImageView alloc]init];
    
    [self addSubview:_footImageView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerLabel.frame = CGRectMake(0, 0, SLGetScreenWidth(), 40);
}

#pragma mark - Override
- (void)reloadWithActivityModel:(SLActivityModel *)activity {
    [super reloadWithActivityModel:activity];

    //12-22
    [_footImageView sd_setImageWithURL:[NSURL URLWithString:activity.detail] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    _footImageView.frame = CGRectMake(5, _headerLabel.frame.size.height +_headerLabel.frame.origin.y, kScreenWidth - 10, [activity.height intValue]);
    height = _footImageView.frame.size.height;
}


static CGFloat height = 0;
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity {
    
    return 40 + height;
}

#pragma maark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityDetailBaseCell:webDidFinshWithError:)]) {
        [self.delegate activityDetailBaseCell:self webDidFinshWithError:error];
    }
}


@end
