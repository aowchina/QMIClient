//
//  QRCode.h
//  Two_dimension_Code
//
//  Created by Min-Fo_003 on 15/9/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCode : NSObject

@property (nonatomic, strong, readonly) UIImage *filterImage;
@property (nonatomic, strong, readonly) UIImage *QRCodeImage;

- (instancetype)initWithQRCodeString:(NSString *)string width:(CGFloat)width;
- (instancetype)initWithImage:(UIImage *)image filterName:(NSString *)name;

@end
