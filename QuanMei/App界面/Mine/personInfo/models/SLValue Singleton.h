//
//  SLValue Singleton.h
//  pickView
//
//  Created by superlian on 15/12/1.
//  Copyright © 2015年 superlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLValue_Singleton : NSObject

@property (nonatomic, strong) NSString *pickTimeStr;
@property (nonatomic, strong) NSString *pickCityStr;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *provinceID;
@property (nonatomic, strong) NSString *cityID;


+(instancetype)shareInstance;


@end
