//
//  DDQDoctorHomePageController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDoctorHomePageController.h"

#import "DDQDoctorIntroCell.h"

#import "DDQDoctorHomePageModel.h"

@interface DDQDoctorHomePageController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  主表视图
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) NSMutableArray *homepage_sourceArray;

@end

@implementation DDQDoctorHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homepage_sourceArray = [NSMutableArray array];
    [self initTableView];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.header endRefreshing];
        }
    }];
    
    self.title = @"主力医生";

    
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyDoctorNetWork];

        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.header endRefreshing];
        }
    }];
}

-(void)asyDoctorNetWork {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,self.hospital_id];
        //加密这个段数
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_string = [postEncryption stringWithPost:post_baseString];
        //post
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:kHospital_DoctorUrl];
        
        NSString *errorcode_string = [post_dic valueForKey:@"errorcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (post_dic) {
                
                if ([errorcode_string intValue] == 0) {
                    //解密
                    //12-21
                    NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                    
                    NSDictionary *get_jsonDic = [DDQPublic nullDic:get_Dic];
                    
                    for (NSDictionary *dataDic in [get_jsonDic valueForKey:@"doctor"]) {
                        DDQDoctorHomePageModel *pageModel = [[DDQDoctorHomePageModel alloc] init];
                        pageModel.direction  = [dataDic valueForKey:@"direction"];
                        pageModel.Id         = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
                        pageModel.img        = [dataDic valueForKey:@"img"];
                        pageModel.intro      = [dataDic valueForKey:@"intro"];
                        pageModel.name       = [dataDic valueForKey:@"name"];
                        pageModel.pos        = [dataDic valueForKey:@"pos"];
                        [self.homepage_sourceArray addObject:pageModel];
                    }
                    [self.mainTableView reloadData];
                    
                } else {
                    [self alertController:@"系统繁忙"];
                }
                [self.mainTableView.header endRefreshing];

            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
         });
    });
}


-(void)initTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
}

#pragma mark - delegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.homepage_sourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    DDQDoctorHomePageModel *homepage_model = [self.homepage_sourceArray objectAtIndex:indexPath.section];
    static NSString *identifier = @"cell";
    DDQDoctorIntroCell *introCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!introCell) {
        introCell = [[DDQDoctorIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [introCell cellWithDoctorIntro:homepage_model.intro andImageStr:homepage_model.img andDoctorName:homepage_model.name andDoctorSkill:homepage_model.direction andDoctorMajor:homepage_model.pos];
        self.rowHeight = introCell.newRect.size.height + 10;
        introCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    return introCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kScreenHeight == 480) {
        return 50 + self.rowHeight;

    } else if (kScreenHeight == 568) {
        return 55 + self.rowHeight;

    } else if (kScreenHeight == 667) {
        return 60 + self.rowHeight;

    } else {
        
        return 70 + self.rowHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 10)];
    view.backgroundColor = [UIColor backgroundColor];
    return view;
    
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
