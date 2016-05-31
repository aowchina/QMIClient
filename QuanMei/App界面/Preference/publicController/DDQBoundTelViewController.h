//
//  DDQBoundTelViewController.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/12.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQBoundTelViewController : UIViewController
@property (nonatomic ,strong)NSString * name;
@property (nonatomic ,strong)NSString * dj;
@property (nonatomic ,strong)NSString * tel;
@property (nonatomic ,strong)NSString * price;
@property (nonatomic ,strong)NSString * time;
@property (nonatomic ,strong)NSString * tid;
@property (nonatomic ,strong)NSString *orderid;
/**
 *  是什么控制器退的
 */
@property (assign,nonatomic) int type;
@end
