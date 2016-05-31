//
//  DDQMineInfoModel.h
//  QuanMei
//
//  Created by min-fo013 on 15/10/19.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQMineInfoModel : NSObject

@property (nonatomic, copy) NSString *userimg;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *sex;
@property (strong,nonatomic) NSArray *group;
@property (strong,nonatomic) NSString *bgimg;
//-(DDQMineInfoModel *)loadModelWithDictionary:(NSDictionary *)dict;

@end
