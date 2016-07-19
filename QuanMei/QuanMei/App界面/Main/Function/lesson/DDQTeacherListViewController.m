//
//  DDQTeacherListViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQTeacherListViewController.h"
#import "DDQTeacherView.h"
#import "DDQTeacherIntroViewController.h"
#import "DDQTeacherlistModel.h"
#import "ProjectNetWork.h"

@interface DDQTeacherListViewController ()<TeacherViewDelegate>

@property (strong,nonatomic) DDQTeacherView *teacherview;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) NSMutableArray *source_array;
@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQTeacherListViewController

-(void)loadView {

    [super loadView];
    
    _teacherview = [[DDQTeacherView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-80)];
    _teacherview.backgroundColor = [UIColor cyanColor];
    
    _teacherview.delegate = self;
    
    [self.view addSubview:_teacherview];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }

    //隐藏背景图
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
    //设置左按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_return"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackMethod)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    label.text = @"百名大师";
    label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = label;
    
    //设置图片
    UIImageView *img = [[UIImageView alloc] init];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.height.offset(40);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    img.image = [UIImage imageNamed:@"img_caitiao"];
    
    UILabel *title = [[UILabel alloc] init];
    [img addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img.mas_centerY);
        make.centerX.equalTo(img.mas_centerX);
        make.height.equalTo(img.mas_height);
    }];
    title.font = [UIFont systemFontOfSize:20.0f weight:5.0f];
    title.text = @"来了,就对了!";
    title.textColor = [UIColor whiteColor];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    self.source_array = [NSMutableArray array];

    self.netWork = [ProjectNetWork sharedWork];

    [self teacher_netWork];
    
}

-(void)teacher_netWork {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kteacher_listUrl andData:nil andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
         
            for (NSDictionary *dic in responseObjc) {
                
                DDQTeacherlistModel *list_model = [DDQTeacherlistModel new];
                list_model.iD = dic[@"id"];
                list_model.logo = dic[@"logo"];
                list_model.name = dic[@"name"];
                [self.source_array addObject:list_model];
                
            }
            
            [self.hud hide:YES];

            self.teacherview.collectionview_dataSource = self.source_array;
            [self.teacherview.teacher_collectionview reloadData];
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}


-(void)goBackMethod {

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)teacherView:(UICollectionView *)tacherView didSelectedOfViewIndexPath:(NSIndexPath *)path {
    
    DDQTeacherlistModel *listmodel = nil;
    if (self.source_array != nil && self.source_array.count != 0) {
        listmodel = self.source_array[path.row];
    }
    DDQTeacherIntroViewController *introVC = [DDQTeacherIntroViewController new];
    
    if (listmodel == nil) {
        
        return;
        
    } else {
        
        introVC.teacher_id = listmodel.iD;
        introVC.lesson_name = listmodel.name;
        [self.navigationController pushViewController:introVC animated:YES];
    }
    
}

@end
