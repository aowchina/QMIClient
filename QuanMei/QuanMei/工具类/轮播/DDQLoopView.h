//
//  DDQLoopView.h
//  我的轮播图
//
//  Created by Min-Fo_003 on 16/2/2.
//  Copyright © 2016年 ddq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoopCollectionViewCell.h"

@protocol DDQLoopViewDelegate <NSObject>

@optional
-(void)loopview_selectedMethod:(NSInteger)count;

@end

@interface DDQLoopView : UIView

@property (strong,nonatomic) id <DDQLoopViewDelegate> delegate;

//图片数据源数组
@property (strong,nonatomic) NSArray *source_array;

//轮播用的collectionview
@property (strong,nonatomic) UICollectionView *loop_collection;

@property (strong,nonatomic) NSTimer *loop_timer;

@property ( strong, nonatomic) UIPageControl *page_control;

//开启定时器
-(void)star;

//关闭定时器
-(void)stop;

@end
