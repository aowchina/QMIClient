//
//  DDQCircleView.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/24.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQCircleView : UIView

/**
 *  画圆
 *
 *  @param frame   设置这个视图多大
 *  @param width   这个圆的边缘线多宽
 *  @param current 当前占多少份
 *  @param total   总共多少份
 *
 *  @return 返回当前这个视图
 */
- (instancetype)initWithFrame:(CGRect)frame arcWidth:(double)width current:(double)current total:(double)total;


@end
