//
//  DDQScreenProjectViewController.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQScreenProjectViewController : UIViewController
@property (nonatomic,copy)NSString *ID;
//点击特惠
@property (nonatomic,copy)NSString *Name;
////点击赛选类型
//@property (nonatomic,copy)NSString *TypesName;

@property (nonatomic,copy)NSString *types_id;

//省id
@property (nonatomic,copy)NSString *sheng_id;
//类别id
@property (nonatomic,copy)NSString *type_id;
//排序方式
@property (nonatomic,copy)NSString *px_id;
//页码
@property (nonatomic,copy)NSString *page_id;

@end
