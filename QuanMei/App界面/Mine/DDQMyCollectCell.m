//
//  DDQMyCollectCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyCollectCell.h"

@implementation DDQMyCollectCell

-(void)setMyCollectModel:(DDQMyCollectModel *)myCollectModel {

    CGRect titleRect = [myCollectModel.title boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:2.0f]} context:nil];
    
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, titleRect.size.height)];
    [self.contentView addSubview:title_label];
    title_label.font          = [UIFont systemFontOfSize:15.0f weight:2.0f];
    title_label.text          = myCollectModel.title;
    title_label.numberOfLines = 0;
    title_label.tag           = 1;
    
    //评论内容
    CGRect introRect = [myCollectModel.intro boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    UILabel *intro_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+titleRect.size.height+10, kScreenWidth - 20, introRect.size.height)];
    [self.contentView addSubview:intro_label];
    intro_label.numberOfLines = 0;
    intro_label.font          = [UIFont systemFontOfSize:13.0f];
    intro_label.text          = myCollectModel.intro;
    intro_label.tag           = 2;
    
    //一根小线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 25+titleRect.size.height+introRect.size.height, kScreenWidth, 1)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor backgroundColor];
    lineView.tag             = 3;
    
    //用户头像
    CGFloat img_w;
    CGFloat img_h;
    if (kScreenWidth == 320) {
        img_w = 30;
        img_h = 30;
    } else {
        img_w = 50;
        img_h = 50;
    }
    UIImageView *userimg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35+titleRect.size.height+introRect.size.height, img_w, img_h)];
    [self.contentView addSubview:userimg];
    userimg.backgroundColor    = [UIColor greenColor];
    userimg.layer.cornerRadius = img_h*0.5;
    userimg.layer.masksToBounds= YES;
    userimg.tag                = 4;
    
    //给cell的高度赋个值
    self.cell_height = 45+titleRect.size.height+introRect.size.height+img_h;
    
    //用户名
    CGRect nickRect = [myCollectModel.username boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *username_label = [[UILabel alloc] init];
    [self.contentView addSubview:username_label];
    [username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userimg.mas_centerY);
        make.width.offset(nickRect.size.width);
        make.height.offset(nickRect.size.height);
        make.left.equalTo(userimg.mas_right).offset(10);
    }];
    username_label.numberOfLines = 0;
    username_label.text          = myCollectModel.username;
    username_label.font          = [UIFont systemFontOfSize:11.0f];
    username_label.tag           = 5;
    
    //发布时间
    CGRect pubtimeRect = [myCollectModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *pubtime_label = [[UILabel alloc] init];
    [self.contentView addSubview:pubtime_label];
    [pubtime_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(username_label.mas_centerY);
        make.width.offset(pubtimeRect.size.width);
        make.height.offset(pubtimeRect.size.height);
        make.left.equalTo(username_label.mas_right).offset(10);
    }];
    pubtime_label.numberOfLines = 0;
    pubtime_label.text          = myCollectModel.pubtime;
    pubtime_label.font          = [UIFont systemFontOfSize:11.0f];
    pubtime_label.tag           = 6;
    
    //评论
    CGFloat imgW;
    CGFloat imgH;
    if (kScreenWidth == 320) {
        imgW = 15;
        imgH = 15;
    } else {
        imgW = 25;
        imgH = 25;
    }
    
    BOOL ret = NO;
    ret = (myCollectModel.zan.length > myCollectModel.reply.length)? YES:NO;//如果赞的长度大于评论的长度，ret=yes;
    NSString *temp_string;
    if (ret == YES) {
        temp_string = myCollectModel.zan;
        
    } else {
        temp_string = myCollectModel.reply;
    }
    CGRect newRect = [temp_string boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    UIView *reply_view = [[UIView alloc] init];
    [self.contentView addSubview:reply_view];
    [reply_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userimg.mas_centerY);
        make.width.offset(imgW+newRect.size.width+5);
        make.height.offset(imgH);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    UIImageView *reply_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    [reply_view addSubview:reply_img];
    reply_img.contentMode  = UIImageResizingModeStretch;
    reply_img.image        = [UIImage imageNamed:@"review"];
    
    UILabel *reply_label = [[UILabel alloc] init];
    [reply_view addSubview:reply_label];
    [reply_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(reply_img.mas_centerY);
        make.width.offset(newRect.size.width);
        make.height.offset(newRect.size.height);
        make.left.equalTo(reply_img.mas_right).offset(5);
    }];
    reply_label.numberOfLines = 0;
    reply_label.text          = myCollectModel.reply;
    reply_label.font          = [UIFont systemFontOfSize:12.0f];
    
    UIView *zan_view = [[UIView alloc] init];
    [self.contentView addSubview:zan_view];
    [zan_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userimg.mas_centerY);
        make.width.offset(imgW+newRect.size.width+5);
        make.height.offset(imgH);
        make.right.equalTo(reply_view.mas_left).offset(-10);
    }];
    
    UIImageView *zan_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    [zan_view addSubview:zan_img];
    zan_img.contentMode  = UIImageResizingModeStretch;
    zan_img.image        = [UIImage imageNamed:@"like"];
    
    UILabel *zan_label = [[UILabel alloc] init];
    [zan_view addSubview:zan_label];
    [zan_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zan_img.mas_centerY);
        make.width.offset(newRect.size.width);
        make.height.offset(newRect.size.height);
        make.left.equalTo(zan_img.mas_right).offset(5);
    }];
    zan_label.numberOfLines = 0;
    zan_label.text          = myCollectModel.zan;
    zan_label.font          = [UIFont systemFontOfSize:12.0f];
}

@end
