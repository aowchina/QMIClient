//
//  DDQDashesLine.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDashesLine.h"

@implementation DDQDashesLine

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,0.5);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {4,2};//先画4个点再画2个点
    
    CGContextSetLineDash(context,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);
    
    // CGContextClosePath(context);
    
}

@end
