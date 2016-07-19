//
//  DDQDoctorCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDoctorCell.h"

@implementation DDQDoctorCell

-(void)layOutContentView:(NSString *)docImage1 docImage2:(NSString *)docImage2 docName1:(NSString *)name1 docName2:(NSString *)name2 docProject1:(NSString *)project1 docProject2:(NSString *)project2 {
    
    UIView *doc_View1 = [[UIView alloc] init];
    [self.contentView addSubview:doc_View1];
    [doc_View1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(self.contentView.mas_height);
    }];
    
    UIImageView *doc_image1 = [[UIImageView alloc] init];
    [doc_View1 addSubview:doc_image1];
    [doc_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight == 480) {
            make.width.offset(40);
            make.height.offset(40);
        } else if (kScreenHeight == 568) {
            make.width.offset(45);
            make.height.offset(45);
        } else if (kScreenHeight == 667) {
            make.width.offset(55);
            make.height.offset(55);
        } else {
            make.width.offset(60);
            make.height.offset(60);
        }
        make.centerY.equalTo(doc_View1.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    if (kScreenHeight == 480) {
        doc_image1.layer.cornerRadius = 20.0f;
        doc_image1.layer.masksToBounds = YES;
    } else if (kScreenHeight == 568) {
        doc_image1.layer.cornerRadius = 22.5f;
        doc_image1.layer.masksToBounds = YES;
    } else if (kScreenHeight == 667) {
        doc_image1.layer.cornerRadius = 27.5f;
        doc_image1.layer.masksToBounds = YES;
    } else {
        doc_image1.layer.cornerRadius = 30.0f;
        doc_image1.layer.masksToBounds = YES;
    }
    [doc_image1 sd_setImageWithURL:[NSURL URLWithString:docImage1] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    UILabel *doc_label1 = [[UILabel alloc] init];
    [doc_View1 addSubview:doc_label1];
    [doc_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doc_image1.mas_right);
        make.width.equalTo(doc_View1.mas_width).multipliedBy(0.5);
        make.height.equalTo(doc_View1.mas_height).multipliedBy(0.5);
        make.bottom.equalTo(doc_View1.mas_centerY);
    }];
    doc_label1.text = name1;
    doc_label1.font = [UIFont systemFontOfSize:16.0f];
    
    UILabel *doc_project1 = [[UILabel alloc] init];
    [doc_View1 addSubview:doc_project1];
    [doc_project1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doc_label1.mas_left);
        make.width.equalTo(doc_label1.mas_width);
        make.height.equalTo(doc_label1.mas_height);
        make.top.equalTo(doc_label1.mas_bottom);
    }];
    doc_project1.text = project1;
    doc_project1.font = [UIFont systemFontOfSize:13.0f weight:0.5f];
    
    
    
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.offset(1);
    }];
    

    
    
    UIView *doc_view2 = [[UIView alloc] init];
    [self.contentView addSubview:doc_view2];
    [doc_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(0.5);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIImageView *doc_image2 = [[UIImageView alloc] init];
    [doc_view2 addSubview:doc_image2];
    [doc_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight == 480) {
            make.width.offset(40);
            make.height.offset(40);
        } else if (kScreenHeight == 568) {
            make.width.offset(45);
            make.height.offset(45);
        } else if (kScreenHeight == 667) {
            make.width.offset(55);
            make.height.offset(55);
        } else {
            make.width.offset(60);
            make.height.offset(60);
        }
        make.centerY.equalTo(doc_View1.mas_centerY);
        make.left.equalTo(lineView.mas_left).offset(5);
    }];
    if (kScreenHeight == 480) {
        doc_image2.layer.cornerRadius = 20.0f;
        doc_image2.layer.masksToBounds = YES;
    } else if (kScreenHeight == 568) {
        doc_image2.layer.cornerRadius = 22.5f;
        doc_image2.layer.masksToBounds = YES;
    } else if (kScreenHeight == 667) {
        doc_image2.layer.cornerRadius = 27.5f;
        doc_image2.layer.masksToBounds = YES;
    } else {
        doc_image2.layer.cornerRadius = 30.0f;
        doc_image2.layer.masksToBounds = YES;
    }
    [doc_image2 sd_setImageWithURL:[NSURL URLWithString:docImage2] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    UILabel *doc_label2 = [[UILabel alloc] init];
    [doc_view2 addSubview:doc_label2];
    [doc_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doc_image2.mas_right);
        make.width.equalTo(doc_View1.mas_width).multipliedBy(0.5);
        make.height.equalTo(doc_View1.mas_height).multipliedBy(0.5);
        make.bottom.equalTo(doc_View1.mas_centerY);
    }];
    doc_label2.text = name2;
    doc_label2.font = [UIFont systemFontOfSize:16.0f weight:3.0f];
    
    UILabel *doc_project2 = [[UILabel alloc] init];
    [doc_view2 addSubview:doc_project2];
    [doc_project2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doc_label2.mas_left);
        make.width.equalTo(doc_label1.mas_width);
        make.height.equalTo(doc_label1.mas_height);
        make.top.equalTo(doc_label1.mas_bottom);
    }];
    doc_project2.text = project2;
    doc_project2.font = [UIFont systemFontOfSize:13.0f weight:0.5f];
}

@end
