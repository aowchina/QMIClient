//
//  CheckNetWork.h
//  BISTU
//
//  Created by guoning  on 13-6-17.
//  Copyright (c) 2013年 Min-Fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface CheckNetWork : NSObject
+(BOOL)isExistenceNetwork;
+(BOOL)connectedToNetwork;
@end
