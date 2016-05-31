//
//  ProjectNetWork.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectNetWork : NSObject

+ (instancetype)sharedWork;

- (void)asy_netWithUrlString:(NSString *)url_s ParamArray:(NSArray *)param_a Success:(void(^)(id source,NSError *analysis_error))success Failure:(void(^)(NSError *net_error))failure;

@end
