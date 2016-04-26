//
//  DDQThemeActivityCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQThemeActivityCell.h"

@implementation DDQThemeActivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}


-(void)setMVCModel:(DDQMainViewControllerModel *)mVCModel {

    self.backgroundImage = [[UIImageView alloc] init];
    [self addSubview:self.backgroundImage];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
    }];
    
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:mVCModel.bimgString]];
    
    self.themeLabel = [[UILabel alloc] init];
    [self addSubview:self.themeLabel];
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(15);
        make.width.offset(50);
        make.height.offset(20);
    }];
    self.themeLabel.textColor = [UIColor whiteColor];
    self.themeLabel.text = @"| 主题";
    
    self.currentView = [[UIView alloc] init];
    [self addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.height.offset(30);
        make.width.equalTo(self.mas_width);
    }];
    self.currentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];;

    CGFloat splitL = 10;
    CGFloat imageW = 20;
    CGFloat imageH = 20;
    NSMutableArray *temp_array = [NSMutableArray array];

    if (mVCModel.yyuserDic.count != 0 || ![mVCModel.amount isKindOfClass:[NSNull class]]) {
        
//        for (int i = 0; i<mVCModel.yyuserDic.count; i++) {
//            
//            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(splitL + imageW*i, self.frame.size.height*0.01, imageW, imageH)];
//            [self.currentView addSubview:image];
//            
//            [image sd_setImageWithURL:[NSURL URLWithString:mVCModel.yyuserArray[i]]];
//        }
        for (NSDictionary *yyuser in mVCModel.yyuserDic) {
            [temp_array addObject:yyuser[@"userimg"]];
        }
        for (int i = 0; i<temp_array.count; i++) {

            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(splitL*i + imageW*i + 5, 5, imageW, imageH)];
            [self.currentView addSubview:image];
            image.layer.cornerRadius = imageH*0.5;
            image.layer.masksToBounds = YES;
            if (![temp_array[i] isEqualToString:@""]) {
                [image sd_setImageWithURL:[NSURL URLWithString:temp_array[i]]];
            } else {
                [image setImage:[UIImage imageNamed:@"default_pic"]];
            }
        }
        self.joinNumLabel = [[UILabel alloc] init];
        [self addSubview:self.joinNumLabel];
        [self.joinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(splitL*temp_array.count + imageW *temp_array.count + 5);
            make.centerY.equalTo(self.currentView.mas_centerY);
            
        }];
        self.joinNumLabel.text = [NSString stringWithFormat:@"已有%@人参加",mVCModel.amount];
        self.joinNumLabel.font = [UIFont systemFontOfSize:13.0f];
        self.joinNumLabel.textColor = [UIColor whiteColor];
        
    } else {
    
        self.joinNumLabel = [[UILabel alloc] init];
        [self addSubview:self.joinNumLabel];
        [self.joinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(splitL*temp_array.count + imageW * temp_array.count + 5);
            make.centerY.equalTo(self.currentView.mas_centerY);
            make.height.offset(15);
        }];
        self.joinNumLabel.text = @"已有0人参加";
        self.joinNumLabel.font = [UIFont systemFontOfSize:13.0f];
        self.joinNumLabel.textColor = [UIColor whiteColor];
    }
    
    
}

@end
