//
//  DDQUserCommentViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/20.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQUserCommentViewCell.h"

@implementation DDQUserCommentViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.currentView = [[UIView alloc] init];
        [self.contentView addSubview:self.currentView];
        [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).with.offset(-5);
        }];
        self.currentView.backgroundColor = [UIColor whiteColor];
        
        self.replyUserImage = [[UIImageView alloc] init];
        [self.currentView addSubview:self.replyUserImage];
        [self.replyUserImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(-self.bounds.size.width*0.01);
            make.left.equalTo(self.mas_left).with.offset(self.bounds.size.width*0.01);
            if (kScreenHeight == 480) {
                make.width.equalTo(@30);
                make.height.equalTo(@30);
            } else if (kScreenHeight == 568) {
                make.width.equalTo(@40);
                make.height.equalTo(@40);
            } else if (kScreenHeight == 667) {
                make.width.equalTo(@45);
                make.height.equalTo(@45);
            } else {
                make.width.equalTo(@50);
                make.height.equalTo(@50);
            }

        }];
        if (kScreenHeight == 480) {
            [_replyUserImage.layer setCornerRadius:15.0f];
            
        } else if (kScreenHeight == 568) {
            [_replyUserImage.layer setCornerRadius:20.0f];
            
        } else if (kScreenHeight == 667) {
            [_replyUserImage.layer setCornerRadius:22.5f];
            
        } else {
            [_replyUserImage.layer setCornerRadius:25.0f];
            
        }
        [_replyUserImage setBackgroundColor:[UIColor orangeColor]];
    }
    return self;
}


-(void)setCommentModel:(DDQCommentModel *)commentModel {

}

@end
