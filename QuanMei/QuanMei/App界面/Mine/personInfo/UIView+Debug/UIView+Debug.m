//
//  UIView+Debug.m
//  Pray
//
//  Created by Tapan Thaker on 29/08/14.
//  Copyright (c) 2014 Tapan. All rights reserved.
//

#import "UIView+Debug.h"
#import <objc/runtime.h>

/*本类用于debug时使用，将ShowBorderLine 设置为 0 不起作用，设置为大于0则可显示界面轮廓，不需要给view添加背景色 来区分显示*/

#ifndef ShowBorderLine
#define ShowBorderLine 0
#endif

@implementation UIView (Debug)

+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethodInit=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)load{
  
#if defined(ShowBorderLine)&&ShowBorderLine
    [self swizzleSelector:@selector(init) withSelector:@selector(init_debug)];
    [self swizzleSelector:@selector(awakeFromNib) withSelector:@selector(awakeFromNib_debug)];
    [self swizzleSelector:@selector(initWithFrame:) withSelector:@selector(initWithFrame_debug:)];
#else
#endif
}

-(id)init_debug{
    
    self = [self init_debug];
    [self addBorders];
    return self;
}


-(void)awakeFromNib_debug{
    [self addBorders];
}

-(id)initWithFrame_debug:(CGRect)frame{
    self = [self initWithFrame_debug:frame];
    [self addBorders];
    return self;
}

-(void)addBorders{
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
}

@end
