//
//  NSString+DDQStringRect.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/26.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "NSString+DDQStringRect.h"

@implementation NSString (DDQStringRect)

- (CGRect)boundStringRect_size:(CGSize)size Attributes:(NSDictionary *)dic {

    CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
    
}

@end
