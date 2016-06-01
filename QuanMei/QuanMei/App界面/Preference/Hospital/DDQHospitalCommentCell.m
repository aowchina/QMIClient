//
//  DDQHospitalCommentCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalCommentCell.h"

@implementation DDQHospitalCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)judgeStarLight:(int)lightNum goodRate:(NSString *)goodRate {
    UIView  *tempView = [[UIView alloc] init];
    [self.contentView addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5);
    }];
    CGFloat imageWidth = self.contentView.frame.size.width*0.4/5;
    CGFloat imageHeight = self.contentView.frame.size.height*0.5;
    for (int i = 0; i<5; i++) {
        
        if (i<lightNum) {
            if (i == 0) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, imageWidth, imageHeight)];
                [tempView addSubview:imageView];
                imageView.image = [UIImage imageNamed:@"icon_big_star_fill"];
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * i+ 5*i, 5, imageWidth, imageHeight)];
                [tempView addSubview:imageView];
                imageView.image = [UIImage imageNamed:@"icon_big_star_fill"];
            }
            
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * i+ 5 * i, 5, imageWidth, imageHeight)];
            [tempView addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"icon_big_star_empty"];
        }
    }
    
    UILabel *rateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:rateLabel];
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.width.offset(40);
        make.bottom.equalTo(tempView.mas_bottom);
        make.height.equalTo(tempView.mas_height).multipliedBy(0.5).offset(5);
    }];
    rateLabel.text = goodRate;
    rateLabel.font = [UIFont systemFontOfSize:16.0f];
    
    UILabel *goodRateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:goodRateLabel];
    [goodRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rateLabel.mas_left);
        make.width.offset(40);
        make.height.equalTo(tempView.mas_height).multipliedBy(0.5);
        make.centerY.equalTo(rateLabel.mas_centerY);
    }];
    goodRateLabel.text = @"好评率";
    goodRateLabel.font = [UIFont systemFontOfSize:12.0f];
}

-(void)layOutCommentFirstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent commentNum:(NSString *)commentNum {
    UIView *tempView = [[UIView alloc] init];
    [self.contentView addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(self.contentView.frame.size.height*0.5+5);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5);
    }];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    [tempView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tempView.mas_centerY);
        make.left.equalTo(tempView.mas_left);
        make.width.offset(30);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5);
    }];
    firstLabel.text = @"审美";
    firstLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    [tempView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstLabel.mas_centerY);
        make.width.equalTo(firstLabel.mas_width).offset(-5);
        make.height.equalTo(firstLabel.mas_height);
        make.left.equalTo(firstLabel.mas_right);
    }];
    secondLabel.text = firstContent;
    secondLabel.font = [UIFont systemFontOfSize:13.0f];
    secondLabel.textColor = [UIColor orangeColor];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    [tempView addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondLabel.mas_right).offset(10);
        make.width.equalTo(firstLabel.mas_width);
        make.height.equalTo(secondLabel.mas_height);
        make.centerY.equalTo(secondLabel.mas_centerY);
    }];
    thirdLabel.text = @"环境";
    thirdLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UILabel *fourthLabel = [[UILabel alloc] init];
    [tempView addSubview:fourthLabel];
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdLabel.mas_right);
        make.centerY.equalTo(thirdLabel.mas_centerY);
        make.width.equalTo(firstLabel.mas_width);
        make.height.equalTo(thirdLabel.mas_height);
    }];
    fourthLabel.text = secondContent;
    fourthLabel.font = [UIFont systemFontOfSize:13.0f];
    fourthLabel.textColor = [UIColor orangeColor];
    
    UILabel *fifthLabel = [[UILabel alloc] init];
    [tempView addSubview:fifthLabel];
    [fifthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fourthLabel.mas_right).offset(10);
        make.width.equalTo(firstLabel.mas_width);
        make.height.equalTo(secondLabel.mas_height);
        make.centerY.equalTo(secondLabel.mas_centerY);
    }];
    fifthLabel.text = @"服务";
    fifthLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UILabel *sixthLabel = [[UILabel alloc] init];
    [tempView addSubview:sixthLabel];
    [sixthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fifthLabel.mas_right);
        make.centerY.equalTo(thirdLabel.mas_centerY);
        make.width.equalTo(firstLabel.mas_width);
        make.height.equalTo(thirdLabel.mas_height);
    }];
    sixthLabel.text = thirdContent;
    sixthLabel.font = [UIFont systemFontOfSize:13.0f];
    sixthLabel.textColor = [UIColor orangeColor];
    
    UILabel *seventhLabel = [[UILabel alloc] init];
    [self.contentView addSubview:seventhLabel];
    [seventhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.centerY.equalTo(tempView.mas_centerY);
        make.height.equalTo(tempView.mas_height).multipliedBy(0.5).offset(5);
    }];
    seventhLabel.text = commentNum;
    seventhLabel.textAlignment = NSTextAlignmentCenter;
    seventhLabel.font = [UIFont systemFontOfSize:13.0f];
}

@end
