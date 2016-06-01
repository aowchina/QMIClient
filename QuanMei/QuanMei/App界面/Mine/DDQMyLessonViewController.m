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

@interface DDQMyLessonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ml_mainTableView;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) NSMutableArray *ml_sourceArray;
@property (assign,nonatomic) CGFloat new_h;

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
    
    self.ml_sourceArray = [NSMutableArray array];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            self.ml_mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        [self.ml_sourceArray removeAllObjects];
                        [self lesson_netWork:1];
                        [self.ml_mainTableView.header endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.ml_mainTableView.header endRefreshing];
                    }
                }];
            }];
            
            self.ml_mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
                    
                    if (errorDic == nil) {
                        
                        int num = page++;
                        [self lesson_netWork:num];
                        [self.ml_mainTableView.footer endRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                        [self.ml_mainTableView.footer endRefreshing];
                    }
                }];
            }];
        } else {
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

static int page = 2;
-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.ml_sourceArray removeAllObjects];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self lesson_netWork:1];
            
        } else {
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    page = 2;
}

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

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        //拼参数
        NSString *base_str = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],[NSString stringWithFormat:@"%d",page]];
        //加密这个八段
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_baseString = [postEncryption stringWithPost:base_str];
        //post一小下
        NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kMy_lessonUrl];
        
        NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
        
        //11-06
        //11-30-15
        if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
            
            NSArray *get_json = [DDQPOSTEncryption judgePOSTDic:get_serverDic];            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                [self.hud removeFromSuperViewOnHide];
                
                for (NSDictionary *dic in get_json) {
                    DDQMyLessonModel *lesson_model = [DDQMyLessonModel new];
                    lesson_model.amount = dic[@"amount"];
                    lesson_model.courseid = dic[@"courseid"];
                    lesson_model.name = dic[@"name"];
                    lesson_model.orderid = dic[@"orderid"];
                    lesson_model.teacherid = dic[@"teacherid"];
                    [self.ml_sourceArray addObject:lesson_model];
                }
                
                if (get_json.count == 0) {
                    
                    [self.ml_mainTableView reloadData];
                    
                    if (self.ml_sourceArray.count == 0) {
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
                        tip_onelabel.text = @"暂无日记";
                        tip_onelabel.textAlignment = NSTextAlignmentCenter;
                        tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                        
                        UILabel *tip_twolabel = [[UILabel alloc] init];
                        [self.view addSubview:tip_twolabel];
                        [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                            make.centerX.equalTo(tip_onelabel.mas_centerX);
                            make.height.offset(15);
                        }];
                        tip_twolabel.text = @"快去发表日记吧";
                        tip_twolabel.textAlignment = NSTextAlignmentCenter;
                        tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
                        
                    } else {
                        [self alertController:@"暂无更多数据"];
                        
                    }
                    
                } else {
                    
                    [self.ml_mainTableView reloadData];

                }
                [self.ml_mainTableView.header endRefreshing];
                [self.ml_mainTableView.footer endRefreshing];
            });
        } else if (([errorcode_string intValue] == 11 && get_serverDic !=nil) || ([errorcode_string intValue] == 12 && get_serverDic !=nil)) {
            
            [self.hud hide:YES];
            [self.hud removeFromSuperViewOnHide];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"账号异常,请重新登录" andShowDim:YES andSetDelay:YES andCustomView:nil];
        } else {
            
            [self.hud hide:YES];
            [self.hud removeFromSuperViewOnHide];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:YES andSetDelay:YES andCustomView:nil];
        }
    });
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
