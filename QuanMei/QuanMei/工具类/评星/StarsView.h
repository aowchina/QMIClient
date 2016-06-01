//
//  StarsView.h
//
//  Created by StarLord on 15/7/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarsView;
@protocol StarsDelegate <NSObject>

@optional
- (void)stars_viewCount:(NSInteger)cout View:(StarsView *)view;

@end
@interface StarsView : UIView
@property ( weak, nonatomic) id <StarsDelegate> delegate;
@property (nonatomic, assign) BOOL selectable;  //是否触摸选择分数(默认为YES)
@property (nonatomic, assign) CGFloat score;    //分数
@property (nonatomic, assign) BOOL supportDecimal; //是否支持触摸选择小数(默认为NO)
//size是你的图片的size   space是Star间的间距  
- (instancetype)initWithStarSize:(CGSize)size space:(CGFloat)space numberOfStar:(NSInteger)number;

- (void)setStarSize:(CGSize)size space:(CGFloat)space numberOfStar:(NSInteger)number;

@end
