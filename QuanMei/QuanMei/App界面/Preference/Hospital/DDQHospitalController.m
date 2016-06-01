//
//  DDQHospitalController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalController.h"

#import "DDQHospitalCell.h"
#import "DDQHospitalImageCell.h"
#import "DDQHospitalIntroCell.h"

#import "DDQHospitalModel.h"

@interface DDQHospitalController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  主的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) DDQHospitalModel *hospitalModel;

@end

@implementation DDQHospitalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self asyHospitalDetailNetWork];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            [self asyHospitalDetailNetWork];
            [self.mainTableView.header endRefreshing];
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.header endRefreshing];
        }
    }];
    //注册一个通知你懂得
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageBig:) name:@"show" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.header endRefreshing];
        }
    }];
}

-(void)showImageBig:(NSNotification *)notifiction {
    
    UIView *temp_view         = [[UIView alloc] initWithFrame:self.view.frame];
    temp_view.backgroundColor = [UIColor backgroundColor];
    
    UIScrollView *temp_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    
    CGFloat imageW = kScreenWidth;
    for (int i = 0; i< self.hospitalModel.alimg.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW*i, 0, imageW, self.view.frame.size.height*0.5)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.alimg[i]]];
        [temp_scroll addSubview:imageView];
    }
    
    temp_scroll.contentSize   = CGSizeMake(imageW*self.hospitalModel.alimg.count, 0);
    temp_scroll.showsHorizontalScrollIndicator = NO;
    temp_scroll.pagingEnabled = YES;
    
    UITapGestureRecognizer *scroll_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    
    [self.view addSubview:temp_view];
    [temp_view addSubview:temp_scroll];
    [temp_view addGestureRecognizer:scroll_tap];
}

-(void)hiddenView:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    [view removeFromSuperview];
}

-(void)asyHospitalDetailNetWork {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *spellString             = [SpellParameters getBasePostString];//八段
        
        NSString *post_baseString         = [NSString stringWithFormat:@"%@*%@",spellString,self.hospital_id];//post字符串
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];//加密类
        
        NSString *post_string             = [postEncryption stringWithPost:post_baseString];//加密下
        
        NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kHospital_DetailUrl];//发送下
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //解密
            //12-21
            NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:post_dic];
            NSDictionary *get_jsonDic = [DDQPublic nullDic:get_Dic];
            NSString *errorcode_string        = [get_jsonDic valueForKey:@"errorcode"];
            if ([errorcode_string intValue] == 0 && get_jsonDic != nil) {
              
                
                self.hospitalModel = [[DDQHospitalModel alloc] init];
                self.hospitalModel.alimg             = [get_jsonDic valueForKey:@"alimg"];
                self.hospitalModel.ID                = [NSString stringWithFormat:@"%@",[get_jsonDic valueForKey:@"id"]];
                self.hospitalModel.intro             = [get_jsonDic valueForKey:@"intro"];
                self.hospitalModel.logo              = [get_jsonDic valueForKey:@"logo"];
                self.hospitalModel.name              = [get_jsonDic valueForKey:@"name"];
                self.hospitalModel.xcimg             = [get_jsonDic valueForKey:@"xcimg"];
                
                [self.mainTableView reloadData];
                self.mainTableView.tableFooterView = [self tableViewFootView];
                
            } else if ([errorcode_string integerValue] == 11){
                
                [self alertController:@"医院信息不存在或已被删除"];
            } else {
            
                [self alertController:@"系统繁忙"];
            }
            
            [self.mainTableView.header endRefreshing];
        });
    });
}

-(UIView *)tableViewFootView {
    //先初始化
    UIView *view = [[UIView alloc] init];
    
    CGFloat imageW = self.view.frame.size.width;
    CGFloat splitH = 10;
    CGFloat imageH = self.view.frame.size.height*0.2;

    for (int i = 0; i<self.hospitalModel.xcimg.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageH*i + splitH * i, imageW, imageH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.xcimg[i]]];
        [view addSubview:imageView];
    }
    
    view.frame           = CGRectMake(0, 0, self.view.frame.size.width, imageH*self.hospitalModel.xcimg.count + splitH*self.hospitalModel.xcimg.count);
    view.backgroundColor = [UIColor backgroundColor];
    return view;
}

#pragma mark - tableView
-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
}

#pragma mark - delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1+1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            DDQHospitalCell *hospitalCell  = [[DDQHospitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hospital"];
            hospitalCell.selectionStyle    = UITableViewCellSelectionStyleNone;
            [hospitalCell.hospitalImage sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.logo]];
            hospitalCell.hospitalName.text = self.hospitalModel.name;
            return hospitalCell;
            
        } else {
            
            DDQHospitalImageCell *imageCell = [[DDQHospitalImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image"];
            imageCell.hospitalModel  = self.hospitalModel;
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;

        }
        
    } else  {
        
        DDQHospitalIntroCell *introCell = [[DDQHospitalIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"intro"];
        [introCell introLabelText:self.hospitalModel.intro];
        
        self.rowHeight           = introCell.newRect.size.height;
        introCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return introCell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    } else {
        
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 30;
        
    } else {
        
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return kScreenHeight*0.1 + 5;
            
        } else {
            return kScreenHeight*0.15 + 10;
            
        }
        
    } else if (indexPath.section == 1) {
        
        return  _rowHeight;
        
    } else {
        
        return 10;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1 ) {
        
        return @"医院介绍";
        
    }  else {
        
        return nil;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
         return @"医院案例";
        
    } else {
        
         return @"";
    }
}

#pragma mark - other methods
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}
@end
