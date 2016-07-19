//
//  DDQPersonHeadImageCell.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/16.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQPersonHeadImageCell.h"
#import "DDQMineInfoModel.h"

#import "UIImageView+WebCache.h"

#define AVATAR_IMAGE_MAGIN 15.f
#define AVATAR_IMAGE_SIZE 50.f

@implementation DDQPersonHeadImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildLeftLabel];
        [self buildHeadView];
    }
    return self;
}

-(void)setMineInfoModel:(DDQMineInfoModel *)mineInfoModel {
    NSURL *url = [NSURL URLWithString:mineInfoModel.userimg];
    [self.headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftLabel.frame = CGRectMake(0, 0, 60, 30);
    self.leftLabel.center = CGPointMake(self.leftLabel.bounds.size.width / 2, self.contentView.center.y);
    
    self.headView.frame = CGRectMake(self.contentView.bounds.size.width - AVATAR_IMAGE_SIZE - AVATAR_IMAGE_MAGIN,
                                     (self.contentView.bounds.size.height - AVATAR_IMAGE_SIZE) / 2.f,
                                     50.f,
                                     50.f);
    
    self.headView.backgroundColor = [UIColor grayColor];
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = self.headView.bounds.size.width / 2;
}

#pragma mark - builder

- (void)buildLeftLabel {
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = @"    头像";
    self.leftLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.leftLabel];
}
- (void)buildHeadView {
    
    self.headView = [[UIImageView alloc] init];
    [self.headView setImage:[UIImage imageNamed:@"iconfont-yuanxing副本"]];
    
    [self.contentView addSubview:self.headView];
    
}

@end
