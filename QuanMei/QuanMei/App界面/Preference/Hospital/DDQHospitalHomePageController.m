//
//  DDQHospitalHomePageController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalHomePageController.h"
#import "DDQHospitalController.h"
#import "DDQDoctorHomePageController.h"
#import "DDQHospitalEvaluateController.h"
#import "DDQPreferenceDetailViewController.h"
#import "DDQHospitalNameCell.h"
#import "DDQHospitalCommentCell.h"
#import "DDQUserCommentCell.h"
#import "DDQDoctorCell.h"
#import "DDQThemeActivityItem.h"

#import "DDQHomePageModel.h"
#import "DDQDoctorHomePageModel.h"
#import "zhutiModel.h"
#import "DDQHospitalEvaluteModel.h"
#import "ProjectNetWork.h"

@interface DDQHospitalHomePageController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


/**
 *  主表视图
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat rowHeight;
/**
 *  首页model
 */
@property (strong,nonatomic) DDQHomePageModel *homePageModel;

@property (strong,nonatomic) UICollectionView *foot_collectionView;
/**
 *  集合视图数据源
 */
@property (strong,nonatomic) NSMutableArray *collectionView_source;

@property (strong,nonatomic) NSMutableArray *temp_pjArray;
/**
 *  item高度
 */
@property ( assign, nonatomic) CGFloat new_height;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQHospitalHomePageController

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
    
    self.collectionView_source = [NSMutableArray array];
    self.temp_pjArray = [NSMutableArray array];
    
    [self initTableView];
    
    self.page = 1;

    self.netWork = [ProjectNetWork sharedWork];
    
    [self asyHospitalHomePageNetWork];
    
    [self asyTeHuiNetWorkWithPage:self.page];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        self.page = 1;
        [_collectionView_source removeAllObjects];
        [self asyHospitalHomePageNetWork];
        [self asyTeHuiNetWorkWithPage:self.page];
        [self.mainTableView.header endRefreshing];

    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self asyTeHuiNetWorkWithPage:self.page];
        [self.mainTableView.footer endRefreshing];
        
    }];

    self.title = self.hospital_name;
    
    self.homePageModel          = [[DDQHomePageModel alloc] init];

    self.temp_pjArray = [NSMutableArray array];
    
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
    
}
/** 医院请求 */
-(void)asyHospitalHomePageNetWork {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kHospital_MainUrl andData:@[self.hospital_id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            NSDictionary *get_jsonDic = [DDQPublic nullDic:responseObjc];
            
            self.homePageModel.doctor   = [get_jsonDic valueForKey:@"doctor"];
            self.homePageModel.fw       = [get_jsonDic valueForKey:@"fw"];
            self.homePageModel.hj       = [get_jsonDic valueForKey:@"hj"];
            self.homePageModel.Id       = [get_jsonDic valueForKey:@"id"];
            self.homePageModel.logo     = [get_jsonDic valueForKey:@"logo"];
            self.homePageModel.name     = [get_jsonDic valueForKey:@"name"];
            self.homePageModel.plamount = [get_jsonDic valueForKey:@"plamount"];
            self.homePageModel.sm       = [get_jsonDic valueForKey:@"sm"];
            self.homePageModel.stars    = [get_jsonDic valueForKey:@"stars"];
            self.homePageModel.pl       = [get_jsonDic valueForKey:@"pl"];
            self.homePageModel.hp       = [get_jsonDic valueForKey:@"hp"];
            
            [self.mainTableView reloadData];
            
        }
      
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}
//static int tehui_page = 2;
/** 医院对应的特惠 */
-(void)asyTeHuiNetWorkWithPage:(int)page {
    
    [self.hud show:YES];
    //填0表示：通用
    [self.netWork asyPOSTWithAFN_url:kTehui_alist andData:@[self.hospital_id, @"0", @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            for (NSDictionary *dataDic in responseObjc) {
                
                zhutiModel *zhuti_Model = [[zhutiModel alloc] init];
                zhuti_Model.hname       = [dataDic valueForKey:@"hname"];
                zhuti_Model.fname       = [dataDic valueForKey:@"fname"];
                zhuti_Model.ID          = [dataDic valueForKey:@"id"];
                zhuti_Model.name        = [dataDic valueForKey:@"name"];
                zhuti_Model.newval      = [dataDic valueForKey:@"newval"];
                zhuti_Model.oldval      = [dataDic valueForKey:@"oldval"];
                zhuti_Model.sellout     = [dataDic valueForKey:@"sellout"];
                zhuti_Model.simg        = [dataDic valueForKey:@"simg"];
                [self.collectionView_source addObject:zhuti_Model];
                
            }
            
            [self.hud hide:YES];
        
            if (self.collectionView_source.count%2 == 0) {
                
                self.foot_collectionView.frame = CGRectMake(0, 0, kScreenWidth, (250)*self.collectionView_source.count/2);
                
            } else {
                
                self.foot_collectionView.frame = CGRectMake(0, 0, kScreenWidth, (250)*self.collectionView_source.count/2 + 250);

            }
            
            self.mainTableView.tableFooterView = self.foot_collectionView;
            
            [self.foot_collectionView reloadData];
            
            if ([responseObjc count] == 0) {
                
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.mainTableView.footer.state = MJRefreshStateIdle;
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}


#pragma mark - 创建一个表视图和一个集合视图
-(void)initTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:self.mainTableView];
    
}

-(UICollectionView *)foot_collectionView {
    if (!_foot_collectionView) {
        UICollectionViewFlowLayout    *layout  = [[UICollectionViewFlowLayout alloc] init];
        _foot_collectionView                   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) collectionViewLayout:layout];
        [_foot_collectionView setDelegate:self];
        [_foot_collectionView setDataSource:self];
        _foot_collectionView.scrollEnabled     = NO;
        
        [_foot_collectionView setBackgroundColor:[UIColor backgroundColor]];
        [_foot_collectionView registerClass:[DDQThemeActivityItem class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:_foot_collectionView];
    }
    return _foot_collectionView;
}

#pragma mark - 表视图代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1+1;
    } else if (section == 1) {
        
        if (self.homePageModel.pl.count > 3) {
            
            return 4;
            
        } else {
        
            return self.homePageModel.pl.count+1;
            
        }
      
    } else {
       
        if (self.homePageModel.doctor.count > 0 && self.homePageModel.doctor != nil) {
            
            return 1;
            
        } else {
        
            return 0;
            
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            DDQHospitalNameCell *nameCell = [[DDQHospitalNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
            nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [nameCell cellWithLogo:self.homePageModel.logo andHospitalName:self.homePageModel.name];
            nameCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return nameCell;
            
        } else {
            
            DDQHospitalCommentCell *commentCell = [[DDQHospitalCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
            [commentCell judgeStarLight:[self.homePageModel.stars intValue] goodRate:self.homePageModel.hp];
            
            if (self.homePageModel.plamount == nil) {
                
                self.homePageModel.plamount = @"";
                
            }
            NSString *temp_string               = [NSString stringWithFormat:@"(%@人)",self.homePageModel.plamount];//将评论人数转换下
            [commentCell layOutCommentFirstContent:self.homePageModel.sm secondContent:self.homePageModel.hj thirdContent:self.homePageModel.fw commentNum:temp_string];
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return commentCell;
            
        }
        
    } else if (indexPath.section == 1) {
        
        
        if (indexPath.row == self.homePageModel.pl.count) {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
            cell.backgroundColor = [UIColor backgroundColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
            tempView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:tempView];
            
            UILabel *label = [[UILabel alloc] init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(tempView.mas_centerX);
                make.centerY.equalTo(tempView.mas_centerY);
                make.width.equalTo(cell.mas_width).multipliedBy(0.5);
                make.height.equalTo(tempView.mas_height).offset(20);
            }];
            label.textAlignment = NSTextAlignmentCenter;
            if (self.homePageModel.plamount == nil) {
                
                self.homePageModel.plamount = @"";
                
            }
            label.text = [NSString stringWithFormat:@"共%@条评论>>",self.homePageModel.plamount];
            label.font = [UIFont systemFontOfSize:15.0f];
            return cell;
            
        } else {
            
            if (self.homePageModel.pl.count != 0 && self.homePageModel.pl.count<=3) {
                
                for (NSDictionary *dataDic in self.homePageModel.pl) {
                    
                    DDQHospitalEvaluteModel *model = [[DDQHospitalEvaluteModel alloc] init];
                    model.fw = dataDic[@"fw"];
                    model.hid = dataDic[@"hid"];
                    model.hua = dataDic[@"hua"];
                    model.iD = dataDic[@"id"];
                    model.orderid = dataDic[@"orderid"];
                    model.pubtime = dataDic[@"pubtime"];
                    model.sm = dataDic[@"sm"];
                    model.stars = dataDic[@"stars"];
                    model.text = dataDic[@"text"];
                    model.userid = dataDic[@"userid"];
                    model.username = dataDic[@"username"];
                    [_temp_pjArray addObject:model];
                    
                }
                
            }
            
            DDQHospitalEvaluteModel *model;
            if (_temp_pjArray.count > 0) {
                
                model = _temp_pjArray[indexPath.row];
                
            }
            
            DDQUserCommentCell *userCell = [[DDQUserCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user"];
            [userCell layOutViewWithNickName:model.username date:model.pubtime intro:model.text andStars:[model.stars intValue]];
            self.rowHeight = userCell.newRect.size.height;
            userCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return userCell;
            
        }
        
    } else  {
        
        DDQDoctorCell *doctorCell = [[DDQDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doctor"];
        
        doctorCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *doctor_array = self.homePageModel.doctor;
        
        if (doctor_array != nil && doctor_array.count > 0) {
            NSMutableArray *temp_array = [NSMutableArray array];
            
            for (NSDictionary *introDic in doctor_array) {
                DDQDoctorHomePageModel *model = [[DDQDoctorHomePageModel alloc] init];
                model.direction = introDic[@"direction"];
                model.name      = introDic[@"name"];
                model.img       = introDic[@"img"];
                model.Id        = introDic[@"id"];
                [temp_array addObject:model];
            }
            
            DDQDoctorHomePageModel *model_one = temp_array[0];
            DDQDoctorHomePageModel *model_two = temp_array[1];
            
            [doctorCell layOutContentView:model_one.img docImage2:model_two.img docName1:model_one.name docName2:model_two.name
                              docProject1:model_one.direction docProject2:model_two.direction];

        }
        doctorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return doctorCell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kScreenHeight*0.1+5;
        } else {
            return kScreenHeight*0.1+5;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            return 35;

        } else {
            return 40+_rowHeight;

        }
    }  else {
        return kScreenHeight * 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 5;
    } else {
        return kScreenHeight*0.05;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"主力医生";
    } else {
        return nil;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return @"所有产品";
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            DDQHospitalController *hospitalVC = [[DDQHospitalController alloc] init];
            hospitalVC.hospital_id = self.homePageModel.Id;
            [self.navigationController pushViewController:hospitalVC animated:YES];
            
        }
    } else if (indexPath.section == 2) {
        
        DDQDoctorHomePageController *doctorVC = [[DDQDoctorHomePageController alloc] init];
        doctorVC.hospital_id = self.homePageModel.Id;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == self.homePageModel.pl.count) {
            
            return;
            
        } else {
        
            DDQHospitalEvaluteModel *model;
            if (_temp_pjArray.count != 0) {
                model = _temp_pjArray[indexPath.row];
            }
            //        if (model != nil) {
            
            DDQHospitalEvaluateController *hospitalEvaluateVC = [[DDQHospitalEvaluateController alloc] init];
            hospitalEvaluateVC.hospitalId = model.hid;
            hospitalEvaluateVC.fw = self.homePageModel.fw;
            hospitalEvaluateVC.hj = self.homePageModel.hj;
            hospitalEvaluateVC.hp = self.homePageModel.hp;
            hospitalEvaluateVC.sm = self.homePageModel.sm;
            [self.navigationController pushViewController:hospitalEvaluateVC animated:YES];
            
            //        }
        }
    
    }
}

#pragma mark - delegate and dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.collectionView_source.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDQThemeActivityItem *activityItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    activityItem.backgroundColor       = [UIColor whiteColor];
    zhutiModel *model;
    if (self.collectionView_source.count != 0) {
        model = self.collectionView_source[indexPath.row];
    }
    activityItem.model                 = model;
    self.new_height    =     activityItem.item_height;

    return activityItem;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth * 0.45, 250);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    zhutiModel *model;
    if (self.collectionView_source.count != 0) {
        model = self.collectionView_source[indexPath.row];
    }
    DDQPreferenceDetailViewController *perferenceDetail = [[DDQPreferenceDetailViewController alloc] initWithActivityID:model.ID];
    [self.navigationController pushViewController:perferenceDetail animated:YES];
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
