//
//  ProjectNetWork.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectNetWork : NSObject

/** 单例 */
+ (instancetype)sharedWork;

/**
 *  网络请求
 *
 *  @param url_s   请求地址
 *  @param param_a 请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)asy_netWithUrlString:(NSString *)url_s ParamArray:(NSArray *)param_a Success:(void(^)(id source,NSError *analysis_error))success Failure:(void(^)(NSError *net_error))failure;

/**
 *  根据公司POST特性，封装了下AFN
 *
 *  @param url     url
 *  @param data    参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)asyPOSTWithAFN_url:(NSString *)url andData:(NSArray *)data andSuccess:(void(^)(id responseObjc,NSError *code_error))success andFailure:(void(^)(NSError *error))failure;

-(void)asyPOST_url:(NSString *)url Photo:(NSMutableArray *)imageArray Data:(NSArray *)data TagArray:(NSArray *)tagArray Success:(void (^)(id objc))success andFailure:(void (^)(NSError *error))failure;

/**
 *  利用AFN传图
 *
 *  @param url      url
 *  @param imgArray 图片数组
 *  @param param    参数数组
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
- (void)asynPOSTPicUseAFN:(NSString *)url PhotoArray:(NSArray *)imgArray Param:(NSArray *)param Success:(void(^)(id responseObjc, NSError *codeErr))success Failure:(void(^)(NSError *netErr))failure;

@end
