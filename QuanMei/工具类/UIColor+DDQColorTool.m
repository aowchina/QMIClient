//
//  UIColor+DDQColorTool.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "UIColor+DDQColorTool.h"

@implementation UIColor (DDQColorTool)

+(instancetype)meiHongSe{
    return [UIColor colorWithRed:250.0/255.0 green:66.0/255.0 blue:136.0/255.0 alpha:1.0];
}
+(instancetype)xueBaiSe{
    return [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
}
+(instancetype)shadowColor{
    return [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.4];
}
+(instancetype)backgroundColor{
    return [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

+(instancetype)myBlueColor {
    return [UIColor colorWithRed:90.0/255 green:145.0/255 blue:210.0/255 alpha:1.0f];
}
+(instancetype)myGrayColor {
    return [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0f];
}

+(instancetype)titleColor {
    return [UIColor colorWithRed:250.0/255 green:66.0/255 blue:135.0/255 alpha:1.0f];

}

+ (instancetype)payColor {

    return [UIColor colorWithRed:255.0/255.0 green:118.0/255.0 blue:140.0/255.0 alpha:1.0f];
}
@end
