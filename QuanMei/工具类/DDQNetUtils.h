//
//  DDQNetUtils.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDQCircleView.h"
@interface DDQNetUtils : NSObject
/**
 *  第一步：检测当前是否有网络连接
 *
 *  @return BOOL值判断
 */
-(BOOL)isNetConnected;
/**
 *  第二步：检测连接状态
 *
 *  @return BOOL值判断
 */
-(BOOL)checkNetWorkStates;
/**
 *  第三步：检测json文件接受是否成功
 *
 *  @return BOOL值判断
 */
-(BOOL)checkJsonDic:(NSString *)jsonString;
/**
 *  第四步：检测字典里是否有我需要的键值
 *
 *  @param jsonDic json字典
 *
 *  @param keyArray 我需要的键值的key
 *
 *  @return BOOL值判断
 */
-(BOOL)getNeedKey:(NSDictionary *)jsonDic keyArray:(NSArray *)keyArray;
/**
 *  获取一个类的所有属性
 *
 *  @param model 这个类
 *
 *  @return 所有属性的数组
 */
- (NSArray *)getAllPropertiesOfModel:(Class)model;

/**
 *  第五步:判断json解析是否成功
 *
 *  @param dic 一个小字典
 *  @param key 一个小键值
 *
 *  @return 返回这个小键值的类型
 */
-(Class)judgeValuesType:(NSDictionary *)dic key:(NSString *)key;

@end
