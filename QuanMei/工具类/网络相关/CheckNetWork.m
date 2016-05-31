//
//  CheckNetWork.m
//  BISTU
//
//  Created by guoning  on 13-6-17.
//  Copyright (c) 2013年 Min-Fo. All rights reserved.
//

#import "CheckNetWork.h"

@implementation CheckNetWork

+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork = YES;
    struct sockaddr_in addr;
    bzero(&addr, sizeof(addr));
    addr.sin_family=AF_INET;
    addr.sin_len=sizeof(addr);
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&addr);
    SCNetworkReachabilityFlags flags;
    //BOOL didRetrieveFlags=SCNetworkReachabilityGetFlags(reachability, &flags);
    SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    /*
     if (!didRetrieveFlags) {
     isExistenceNetwork = NO;
     }
     */
    BOOL isReachable=flags&kSCNetworkFlagsReachable;
    if (isReachable) {
        isExistenceNetwork=YES;
    }else {
        isExistenceNetwork=NO;
    }
    return isExistenceNetwork;
}
//判断当前有没有网络
+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
