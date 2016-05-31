//
//  DDQSetModel.h
//  QuanMei
//
//  Created by min-fo013 on 15/10/15.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQSetModel : NSObject

@property (copy,nonatomic) NSString *img;

@property (nonatomic, strong) NSString *niceName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *level;

- (DDQSetModel *)loadDataWithDictionary:(NSDictionary *)dic;

@end
