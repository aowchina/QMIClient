//
//  DDQMainViewControllerModel.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQMainViewControllerModel : NSObject


@property (nonatomic ,strong)NSString * bimgString ;//大
@property (nonatomic ,strong)NSString * fnameString ;//前
@property (nonatomic ,strong)NSString * sellout ;//售
@property (nonatomic ,strong)NSString * newvalString ;//新
@property (nonatomic ,strong)NSString * oldvalString ;//旧
@property (nonatomic ,strong)NSString * simgString ;//小
@property (nonatomic ,strong)NSString * IdString ;
@property (nonatomic ,strong)NSString * nameString;//标题

@property (nonatomic ,strong)NSString *hname;//医院

@property (nonatomic ,strong)NSString *amount;

//riji
@property (nonatomic ,strong)NSString *gname;//组
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *type;
@property (nonatomic ,strong)NSString *isjing;//精
@property (nonatomic ,strong)NSString *pltime;//zuishijian
@property (nonatomic ,strong)NSString *plusername;
@property (nonatomic ,strong)NSString *pluserimg;
@property (nonatomic ,strong)NSString *pluserid;

@property (nonatomic ,strong)NSString *img;
@property (nonatomic ,strong)NSString *text;//内
@property (nonatomic ,strong)NSString *pl;//评论
@property (nonatomic ,strong)NSString *zan;
@property (nonatomic ,strong)NSString *userid;

//10-16
@property (nonatomic ,strong)NSString *intro;//简介
@property (nonatomic ,strong)NSString *detail;//html
@property (nonatomic ,strong)NSString *pid;
@property (nonatomic ,strong)NSString *tid;
@property (nonatomic ,strong)NSString *hid;

//10-30
@property (nonatomic ,strong)NSDictionary *yyuserDic;

@end
