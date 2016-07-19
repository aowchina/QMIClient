//
//  DDQMyLessonViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/24.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQMyLessonViewController.h"
#import "DDQTeacherIntroViewController.h"
#import "DDQMyLessonCell.h"
#import "DDQMyLessonModel.h"
#import "ProjectNetWork.h"
#import "MJExtension.h"
#import "DDQLoginViewController.h"
@interface DDQMyLessonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ml_mainTableView;
@property (strong, nonatomic) NSMutableArray *ml_sourceArray;
@property (assign, nonatomic) CGFloat new_h;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) ProjectNetWork *netWork;
@property (assign, nonatomic) int page;
@end

@implementation DDQMyLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ml_mainTableView.tableFooterView = [[UIView alloc]  initWithFrame:CGRectZero];
    self.ml_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ml_mainTableView.backgroundColor = [UIColor backgroundColor];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    //小菊花
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    self.navigationItem.titleView = nil;

    self.navigationController.navigationBar.translucent = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text = @"我的课程";
    label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = label;
    
    self.ml_mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.ml_sourceArray removeAllObjects];
        [self lesson_netWork:self.page];
        [self.ml_mainTableView.header endRefreshing];
        
    }];
    
    self.ml_mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self lesson_netWork:self.page];
        [self.ml_mainTableView.footer endRefreshing];
        
    }];
    
    self.ml_sourceArray = [NSMutableArray array];
    
    self.page = 1;
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self lesson_netWork:self.page];

}
//static int page = 2;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.ml_sourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQMyLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DDQMyLessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.lesson_model = self.ml_sourceArray[indexPath.row];
        self.new_h = cell.new_rect;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.new_h;
}

-(void)lesson_netWork:(int)page {

    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kMy_lessonUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
        
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 11 || code == 12) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DDQLoginViewController alloc] init]];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }
            
        } else {
        
            for (NSDictionary *dic in responseObjc) {
                
                DDQMyLessonModel *lesson_model = [DDQMyLessonModel mj_objectWithKeyValues:dic];
                [self.ml_sourceArray addObject:lesson_model];
                
            }
            
            if (self.ml_sourceArray.count == 0 && [responseObjc count] == 0) {
                
                UIImageView *temp_img = [[UIImageView alloc] init];
                [self.view addSubview:temp_img];
                [temp_img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.centerY.equalTo(self.view.mas_centerY);
                    make.width.offset(70);
                    make.height.offset(70);
                }];
                temp_img.image = [UIImage imageNamed:@"default_pic"];
                
                UILabel *tip_onelabel = [[UILabel alloc] init];
                [self.view addSubview:tip_onelabel];
                [tip_onelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(temp_img.mas_bottom).offset(10);
                    make.centerX.equalTo(temp_img.mas_centerX);
                    make.height.offset(20);
                }];
                tip_onelabel.text = @"暂无课程";
                tip_onelabel.textAlignment = NSTextAlignmentCenter;
                tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                
                UILabel *tip_twolabel = [[UILabel alloc] init];
                [self.view addSubview:tip_twolabel];
                [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                    make.centerX.equalTo(tip_onelabel.mas_centerX);
                    make.height.offset(15);
                }];
                tip_twolabel.text = @"去内涵美看看吧";
                tip_twolabel.textAlignment = NSTextAlignmentCenter;
                tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
                
            }

            [self.hud hide:YES];
            
            [self.ml_mainTableView reloadData];
            
            if ([responseObjc count] == 0) {
                
                self.ml_mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
            
                self.ml_mainTableView.footer.state = MJRefreshStateIdle;
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQMyLessonModel *model = self.ml_sourceArray[indexPath.row];
    DDQTeacherIntroViewController *intro_vc = [DDQTeacherIntroViewController new];
    intro_vc.teacher_id  = model.teacherid;
    [self.navigationController pushViewController:intro_vc animated:YES];
}

-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}

@end
