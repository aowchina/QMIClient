//
//  DDQMainSearchDetailCollectionViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/9.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMainSearchDetailCollectionViewController.h"

#import "DDQThemeActivityItem.h"

#import "DDQPreferenceDetailViewController.h"

#import "zhutiModel.h"//数据

#import "Header.h"
#import "ProjectNetWork.h"

@interface DDQMainSearchDetailCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) UIScrollView * mainScrollView;

@property (nonatomic ,strong) NSMutableArray * godsArray;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ProjectNetWork *netWork;
@property (nonatomic, assign) int page;

@end

@implementation DDQMainSearchDetailCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor backgroundColor];
    
    
    _godsArray = [[NSMutableArray alloc]init];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    
    //背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];
    
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    
    //title 颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    
    //返回颜色
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    self.page = 1;
    
    [self asyncListForSearchDetailVCWithPage:self.page];
    

}

- (void)asyncListForSearchDetailVCWithPage:(int)page {
  
    if (![_searchTehuiText isEqualToString:@""] || _searchTehuiText != nil) {
        
        [self.hud show:YES];

        NSData *data1 = [_searchTehuiText dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray1 = (Byte *)[data1 bytes];
        NSMutableString *searchtext = [[NSMutableString alloc] init];
        
        for(int i=0;i<[data1 length];i++) {
            [searchtext appendFormat:@"%d#",byteArray1[i]];
        }
        
        [self.netWork asyPOSTWithAFN_url:kSearchTehuiUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],searchtext,@(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            } else {
                
                for (NSDictionary *dic1 in responseObjc) {
                    
                    NSDictionary * dic = [DDQPublic nullDic:dic1];
                    
                    zhutiModel *thmodel = [[zhutiModel alloc]init];
                    
                    thmodel.fname = dic[@"fname"];
                    thmodel.ID = dic[@"id"];
                    thmodel.name = dic[@"name"];
                    thmodel.newval = dic[@"newval"];
                    thmodel.oldval = dic[@"oldval"];
                    thmodel.simg = dic[@"simg"];
                    thmodel.hname = dic[@"hname"];
                    
                    [_godsArray addObject:thmodel];
                    
                }
                
                [self.hud hide:YES];
                [self crratSearchCollectionView];
                
                if ([responseObjc count] > 0) {
                    
                    self.mainScrollView.footer.state = MJRefreshStateNoMoreData;
                    
                } else {
                
                    self.mainScrollView.footer.state = MJRefreshStateIdle;

                }
                
            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];

    } else {
    
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"请输入搜索内容" andShowDim:NO andSetDelay:YES andCustomView:nil];

    }
  
}

- (void)crratSearchCollectionView {
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    [self.view addSubview:_mainScrollView];
    
    //加载
    [self loading];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];

    if (_godsArray.count%2 == 0) {
        
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, (_godsArray.count/2)*250);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (_godsArray.count/2)*250) collectionViewLayout:flowlayout];

    } else {
        
        _mainScrollView.contentSize = CGSizeMake(0, (_godsArray.count+1)/2 *250);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (_godsArray.count+1)/2 *250) collectionViewLayout:flowlayout];

    }
    _collectionView.backgroundColor = [UIColor backgroundColor];
    //11-05
    _collectionView.delegate =self;
    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[DDQThemeActivityItem class] forCellWithReuseIdentifier:@"collcell"];
    
    [_mainScrollView addSubview: _collectionView];
    
}
#pragma mark - delegate for collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _godsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDQThemeActivityItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
    //11-06
    item.backgroundColor = [UIColor whiteColor];
    zhutiModel *model = _godsArray[indexPath.row];
    
    item.model =model;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zhutiModel *model = _godsArray[indexPath.row];
    
    DDQPreferenceDetailViewController *preferenceDetailVC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:model.ID];
    
    preferenceDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:preferenceDetailVC animated:YES];

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth*0.5-10, 250);
}
//加载
-(void)loading
{
    
    //    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    self.mainTableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.mainScrollView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [_mainScrollView removeFromSuperview];
        [self asyncListForSearchDetailVCWithPage:self.page];
        
        // 结束刷新
        [self.mainScrollView.footer endRefreshing];
        
    }];
}


@end
