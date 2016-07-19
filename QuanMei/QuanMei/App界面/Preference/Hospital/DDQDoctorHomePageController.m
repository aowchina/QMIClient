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

#import "ProjectNetWork.h"

@interface DDQDoctorHomePageController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  主表视图
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) NSMutableArray *homepage_sourceArray;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQDoctorHomePageController

- (MBProgressHUD *)hud {
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.detailsLabelText = @"请稍等...";
        
    }
    
    return _hud;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.homepage_sourceArray = [NSMutableArray array];
    [self initTableView];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self asyDoctorNetWork];

    self.title = @"主力医生";
    
}

-(void)asyDoctorNetWork {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kHospital_DoctorUrl andData:@[self.hospital_id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            NSDictionary *get_jsonDic = [DDQPublic nullDic:responseObjc];
            
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
            
            [self.hud hide:YES];
            
            [self.mainTableView reloadData];

        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
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

@end
