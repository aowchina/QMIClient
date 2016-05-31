//
//  SLActivityModel.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLActivityModel : NSObject
// 图片名
@property (nonatomic, strong) NSString *localImageName;

@property (nonatomic, copy) NSNumber *currentPrice;
@property (nonatomic, copy) NSNumber *refPrice;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) NSNumber *webHeight;



//10-28
@property (nonatomic ,strong)NSString * bimg ;//大

@property (nonatomic ,strong)NSString * newval ;//新
@property (nonatomic ,strong)NSString * oldval ;//旧

@property (nonatomic ,strong)NSString * IdString ;
@property (nonatomic ,strong)NSString *hid;

@property (nonatomic ,strong)NSString *hname;//医院

@property (nonatomic ,strong)NSString *himg;//医院logo

@property (nonatomic ,strong)NSString *dj;

@property (nonatomic ,strong)NSString *intro;//简介

@property (nonatomic ,strong)NSString *detail;//html

@property (nonatomic ,strong)NSString *height;//html
@property (nonatomic ,strong)NSString *width;//html


@property (nonatomic ,strong)NSString *lc;//预约流程说明

@property (nonatomic ,strong)NSString *lcnote;//预约流程备注

@property (nonatomic ,strong)NSMutableArray *users;
//12-13
@property (nonatomic ,strong)NSString * name;

@end
