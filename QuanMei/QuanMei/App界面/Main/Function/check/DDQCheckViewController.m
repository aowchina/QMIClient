//
//  DDQCheckViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQCheckViewController.h"
#import "DDQProjectViewController.h"
#import "DDQProjectDetailViewController.h"
#import "DDQUserDiaryViewController.h"
#import "DDQTableViewCell.h"
#import "DDQDiaryViewController.h"
#import "DDQCheckControllerModel.h"
#import "DDQItem.h"
#import "ProjectNetWork.h"

@interface DDQCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  数据源
 */
@property (strong,nonatomic) NSMutableArray *dataArray;
/**
 *  判断是否展开
 */
@property (strong,nonatomic) NSMutableArray *isShowArray;
/**
 *  头视图
 */
@property (strong,nonatomic) NSMutableArray *headerViewArray;
/**
 *  分区对应的数据源
 */
@property (strong,nonatomic) NSMutableArray *sectionArray;

@property (strong,nonatomic) MBProgressHUD *hud;

@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQCheckViewController

#pragma mark - lazy load
-(UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor backgroundColor];
    }
    return _mainTableView;
}

#pragma mark - view life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"加载中...";
    
    //初始化数组
    _dataArray = [NSMutableArray array];
    _isShowArray = [NSMutableArray array];
    _headerViewArray = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
    self.navigationItem.title = @"项目大全";
    
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.mainTableView];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self dataAnalysis];

}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    
}

#pragma mark - reload cell 
-(void)reloadTableViewCell {
    
    //看有多少个分区
    NSArray *temp_array = [self.sectionArray objectAtIndex:0];
    
    for (int section = 0 ; section < temp_array.count; section++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        
        //cell的名字
        NSMutableArray *current_array = [temp_array objectAtIndex:section];
        
        for (int row = 0 ; row < current_array.count; row++) {
            NSString *cellName = [[current_array objectAtIndex:row] valueForKey:@"name"];
            NSString *cellId = [[current_array objectAtIndex:row] valueForKey:@"id"];
            
            DDQItem *item = [[DDQItem alloc] init];
            item.name = cellName; item.ID = cellId;
            
            [sectionArray addObject:item];
        }
        [_dataArray addObject:sectionArray];
        [_isShowArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.mainTableView reloadData];
}

#pragma mark - netWork
-(void)dataAnalysis {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kProjectListUrl andData:nil andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            for (NSDictionary *dic_one in responseObjc) {//获得分区标题和图片
                
                DDQCheckControllerModel *model = [[DDQCheckControllerModel alloc] init];
                model.iconString = [dic_one valueForKey:@"icon"];
                model.nameString = [dic_one valueForKey:@"name"];
                [_headerViewArray addObject:model];
                //[temp_Array addObject:[json_Dic valueForKey:@"list"]];
                [self.sectionArray addObject:[responseObjc valueForKey:@"list"]];
                
            }
            
            [self.hud hide:YES];
            
            [self reloadTableViewCell];
            [self.mainTableView reloadData];

        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];

}

#pragma mark - delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerViewArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DDQCheckControllerModel *checkModel = [self.headerViewArray objectAtIndex:section];
    
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    currentView.backgroundColor = [UIColor backgroundColor];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [currentView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentView.mas_left).offset(10);
        make.centerY.equalTo(currentView.mas_centerY);
        make.width.offset(20);
        make.height.offset(20);
    }];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:checkModel.iconString]];
    
    
    UILabel *leftLabel = [[UILabel alloc] init];
    [currentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right);
        make.centerY.equalTo(leftImageView.mas_centerY);
        make.height.equalTo(leftImageView.mas_height);
        make.width.equalTo(currentView.mas_width).multipliedBy(0.4);
    }];
    leftLabel.text = checkModel.nameString;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    return currentView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    DDQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[DDQTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor backgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *sectionArray = _dataArray[indexPath.section];
    BOOL showAll = [_isShowArray[indexPath.section] boolValue];
    
    [cell setItemArr:sectionArray andShowAll:showAll];
    
    [cell cellBlock:^(DDQItem *item) {
        
        if (item) {
            
            DDQProjectViewController *projectDetail = [[DDQProjectViewController alloc] init];

            DDQSingleModel *singelModel = [DDQSingleModel singleModelByValue];
            singelModel.projectId = item.ID;
            [self.navigationController pushViewController:projectDetail animated:YES];
            
        }else{
            
            [_isShowArray replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:YES]];
            
            //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat splitH = 45;
    
    NSArray *sectionArr = _dataArray[indexPath.section];
    
    BOOL showAll = [_isShowArray[indexPath.section] boolValue];
    
//    if (!showAll && sectionArr.count>=9) {
//        return splitH*3;
//    } else if (showAll && sectionArr.count <9) {
//        return  sectionArr.count/3*splitH  + ((sectionArr.count/3==0 && sectionArr.count>0)?splitH :0);
//
//    } else {
//        return  sectionArr.count/3*splitH  + ((sectionArr.count/3==0 && sectionArr.count>0)?splitH :0) + splitH;
//
//    }
    if (sectionArr.count >= 9 && !showAll) {
        return splitH*3;
    } else {
        if (sectionArr.count%3==0) {
            return sectionArr.count/3*splitH;
        } else {
            return  sectionArr.count/3*splitH  + ((sectionArr.count/3==0 && sectionArr.count>0)?splitH :0) + splitH;

        }

    }
//    return  ((sectionArr.count/3==0 && sectionArr.count>0)?splitH :0) + splitH;

}

@end
