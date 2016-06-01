//
//  DDQQiandaoView.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/2/20.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDQQiandaoView;
@protocol QiandaoDelegate <NSObject>

@optional
- (void)qiandao_view:(DDQQiandaoView *)view;
- (void)qiandao_viewSelected:(DDQQiandaoView *)view;
@end

@interface DDQQiandaoView : UIView

@property (weak,nonatomic) id <QiandaoDelegate> delegate;
@property (strong,nonatomic) UILabel *huodefenshu;
@property (strong,nonatomic) NSString *title;


@end
