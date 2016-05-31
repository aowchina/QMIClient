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

@interface DDQMainSearchDetailCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    //页码
    NSString * page_id;

}
@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic ,strong)UIScrollView * mainScrollView;

@property (nonatomic ,strong)NSMutableArray * godsArray;


@property ( strong, nonatomic) MBProgressHUD *hud;

@end

@implementation DDQMainSearchDetailCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor backgroundColor];
    
    page_id = @"1";
    
    _godsArray = [[NSMutableArray alloc]init];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];
    
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    
    //title 颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //返回颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic) {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
            
        
            [self.hud show:YES];
            [self asyncListForSearchDetailVC];
        }
        
    }];
    
}

- (void)asyncListForSearchDetailVC
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //
        NSData *data1 = [_searchTehuiText dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray1 = (Byte *)[data1 bytes];
        NSMutableString *searchtext = [[NSMutableString alloc] init];
        
        for(int i=0;i<[data1 length];i++) {
            [searchtext appendFormat:@"%d#",byteArray1[i]];
        }
        
        
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        
        //加密
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],searchtext,page_id];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kSearchTehuiUrl];
        
        
        if (get_postDic[@"errorcode"] == 0) {
            //10-19
            //10-30
            NSDictionary * get_JsonDic = [DDQPOSTEncryption judgePOSTDic:get_postDic];

            if (![get_JsonDic isKindOfClass:[NSNull class]] && get_JsonDic!=nil) {
                
                //12-21
                for (NSDictionary *dic1 in get_JsonDic) {
                    
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
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self crratSearchCollectionView];
            });
            
        } else {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            });
            
        }
        
        
    });

}
- (void)crratSearchCollectionView
{
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    [self.view addSubview:_mainScrollView];
    
    //加载
    [self loading];
    
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];

    if (_godsArray.count%2 == 0) {
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, (_godsArray.count/2)*kScreenHeight*0.4);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (_godsArray.count/2)*kScreenHeight*0.4) collectionViewLayout:flowlayout];

    }else
    {
        _mainScrollView.contentSize = CGSizeMake(0, (_godsArray.count+1)/2 *kScreenHeight*0.4);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (_godsArray.count+1)/2 *kScreenHeight*0.4) collectionViewLayout:flowlayout];

    }
    
    //collection
    
    
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
    return CGSizeMake(kScreenWidth*0.5-10, kScreenHeight*0.4);
}
//加载
-(void)loading
{
    
    //    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    self.mainTableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.mainScrollView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int count = 1;
        count++;
        page_id = [NSString stringWithFormat:@"%d",count];
        [_mainScrollView removeFromSuperview];
        [self asyncListForSearchDetailVC];
        
        // 结束刷新
        [self.mainScrollView.footer endRefreshing];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
