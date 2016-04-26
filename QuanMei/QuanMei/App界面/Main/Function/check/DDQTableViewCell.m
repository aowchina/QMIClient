//
//  DDQTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQTableViewCell.h"

@interface DDQTableViewCell ()
@property(nonatomic,strong)UIButton *btnShowAll;
@end

@implementation DDQTableViewCell{
    
    CGFloat leftSpan;
    CGFloat upSpan;
    CGFloat splitW;
    CGFloat splitH;
    CGFloat btn_w;
    CGFloat btn_h;
    
    
    NSMutableArray *_mybtnArr;
    MyCellBlock _MCBlock;
}

-(void)setItemArr:(NSArray *)arrItem andShowAll:(BOOL)boolean{
    _arrItem = arrItem; _showAll = boolean;
    if (_arrItem) {
        [self reloadUIItems];
    }
}


-(void)reloadUIItems{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (!_mybtnArr) {
        _mybtnArr = [NSMutableArray array];
    }
    [_mybtnArr removeAllObjects];
    
    leftSpan    = 0;
    upSpan      = 0;
    splitW      = ([UIScreen mainScreen].bounds.size.width-leftSpan)/3;
    splitH      = 45;
    btn_w       = ([UIScreen mainScreen].bounds.size.width)/3;
    btn_h       = 46;
    
    if (_arrItem.count <= 8) {
        for (int i=0; i<_arrItem.count; i++) {
            DDQButton *myBtn = [[DDQButton alloc] initWithFrame:CGRectMake(leftSpan+i%3*splitW, upSpan+i/3*splitH, btn_w, btn_h)];
            myBtn.item = self.arrItem[i];
            [myBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_mybtnArr addObject:myBtn];
            [self.contentView addSubview:myBtn];
        }
    }else if (!_showAll){
        for (int i=0; i<8; i++) {
            DDQButton *myBtn = [[DDQButton alloc] initWithFrame:CGRectMake(leftSpan+i%3*splitW, upSpan+i/3*splitH, btn_w, btn_h)];
            myBtn.item = self.arrItem[i];
            [myBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_mybtnArr addObject:myBtn];
            [self.contentView addSubview:myBtn];
        }
        self.btnShowAll.frame = CGRectMake(leftSpan+2*splitW, upSpan+2*splitH, btn_w, btn_h);
        [self.contentView addSubview:self.btnShowAll];
    }else{
        for (int i=0; i<_arrItem.count; i++) {
            DDQButton *myBtn = [[DDQButton alloc] initWithFrame:CGRectMake(leftSpan+i%3*splitW, upSpan+i/3*splitH, btn_w, btn_h)];
            myBtn.item = self.arrItem[i];
            [myBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_mybtnArr addObject:myBtn];
            [self.contentView addSubview:myBtn];
        }
    }
}

-(UIButton *)btnShowAll{
    if (!_btnShowAll) {
        _btnShowAll = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, btn_w-kScreenWidth*0.05, btn_h-1)];
        _btnShowAll.layer.borderWidth = 1.0f;
        _btnShowAll.layer.borderColor = [UIColor backgroundColor].CGColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        [_btnShowAll addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_btnShowAll.mas_centerX);
            make.centerY.equalTo(_btnShowAll.mas_centerY);
            make.width.offset(20);
            make.height.offset(10);
        }];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"iv_tomore"];
        _btnShowAll.backgroundColor = [UIColor whiteColor];
        [_btnShowAll addTarget:self action:@selector(showAllClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShowAll;
}

-(void)showAllClick:(UIButton *)btn{
    if (_MCBlock) {
        _MCBlock(nil);
    }
}

-(void)btnClick:(DDQButton *)btn{
    if (_MCBlock) {
        _MCBlock(btn.item);
    }
}

-(void)cellBlock:(MyCellBlock)thisblock{
    _MCBlock = thisblock;
}

@end
