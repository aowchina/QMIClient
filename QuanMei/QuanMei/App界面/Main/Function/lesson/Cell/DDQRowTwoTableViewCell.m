//
//  DDQRowTwoTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQRowTwoTableViewCell.h"

@implementation DDQRowTwoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rt_countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rt_countLabel];
        [self.rt_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.offset(20);
        }];
        
        NSAttributedString *atrributedString = [[NSAttributedString alloc] initWithString:@"数量:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor grayColor]}];
        self.rt_countLabel.font = [UIFont systemFontOfSize:14.0f];
        self.rt_countLabel.attributedText = atrributedString;
        
        self.rt_minusBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.rt_minusBtn];
        [self.rt_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rt_countLabel.mas_right).offset(10);
            make.centerY.equalTo(self.rt_countLabel.mas_centerY);
            make.height.offset(30);
            make.width.offset(30);
        }];
        [self.rt_minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.rt_minusBtn addTarget:self action:@selector(minusButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rt_showLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rt_showLabel];
        [self.rt_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rt_minusBtn.mas_right);
            make.width.offset(40);
            make.height.offset(30);
            make.centerY.equalTo(self.rt_minusBtn.mas_centerY);
        }];
        self.rt_showLabel.text = @"1";
        self.rt_showLabel.textAlignment = NSTextAlignmentCenter;
        self.rt_showLabel.font = [UIFont systemFontOfSize:15.0f];
        
        self.rt_addBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.rt_addBtn];
        [self.rt_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rt_showLabel.mas_right);
            make.centerY.equalTo(self.rt_showLabel.mas_centerY);
            make.height.offset(30);
            make.width.offset(30);
        }];
        [self.rt_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.rt_addBtn addTarget:self action:@selector(addButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rt_minusBtn.layer.borderWidth = 1.0f;
        self.rt_minusBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [self.rt_minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.rt_addBtn.layer.borderWidth = 1.0f;
        self.rt_addBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [self.rt_addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        self.rt_showLabel.layer.borderWidth = 1.0f;
        self.rt_showLabel.layer.borderColor = [UIColor grayColor].CGColor;
        
//        UIView *lineview = [UIView new];
//        [self.contentView addSubview:lineview];
//        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left);
//            make.right.equalTo(self.contentView.mas_right);
//            make.bottom.equalTo(self.contentView.mas_bottom);
//            make.height.offset(1);
//        }];
//        lineview.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8f];
        
        self.lesson_count = 0;
    }
    return self;
}
//两个button的点击方法
-(void)minusButtonClickMethod:(UIButton *)button {
    
    if (self.lesson_count > 1) {
        
        int i = self.lesson_count--;
        [self.rt_showLabel setText:[NSString stringWithFormat:@"%d",i]];
    } else {
        
        self.lesson_count = 1;
        [self.rt_showLabel setText:[NSString stringWithFormat:@"%d",self.lesson_count]];
        return;
    }
    
}

-(void)addButtonClickMethod:(UIButton *)button {

    self.lesson_count++;
    int i = self.lesson_count+1;
    [self.rt_showLabel setText:[NSString stringWithFormat:@"%d",i]];
}


@end
