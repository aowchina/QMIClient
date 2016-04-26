//
//  DDQOrderModel.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQOrderModel : NSObject
@property (nonatomic ,strong)NSString *orderid;//订单号
@property (nonatomic ,strong)NSString * tid;//特惠id
@property (nonatomic ,strong)NSString *dj;//定金
@property (nonatomic ,strong)NSString *simg;
@property (nonatomic ,strong)NSString *name;//特惠名
@property (nonatomic ,strong)NSString *fname;
@property (nonatomic ,strong)NSString *hname;
@property (nonatomic ,strong)NSString *status;//订单状态
@property (nonatomic ,strong)NSString *intime;
@property (nonatomic ,strong)NSString *userid;
@property (nonatomic ,strong)NSString *idString;
@property (nonatomic ,strong)NSString *hid;
@property (nonatomic ,strong)NSString *tel;


@property (nonatomic ,strong)NSString *newval;

@end
