//
//  DDQThemeActivityViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQThemeActivityViewController.h"
#import "DDQPreferenceDetailViewController.h"

#import "DDQThemeActivityItem.h"

#import "zhutiModel.h"

@interface DDQThemeActivityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>

@property (strong,nonatomic) UICollectionView *mainCollectionView;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (nonatomic ,strong)MBProgressHUD *hud;


@end

@implementation DDQThemeActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主题活动";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self initCollectionView];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    [self.hud show:YES];
    
    _listArray = [[NSMutableArray alloc]init];

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyProductListWithPage:1];

            self.mainCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
                int num = page + 1;
                [self asyProductListWithPage:num];
                
            }];
            
        } else {
            [self.hud hide:YES];
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;

}

#pragma mark - item target action
-(void)goBackViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:YES];
    page = 2;
}

#pragma mark - 网络相关
static int page = 2;
-(void)asyProductListWithPage:(int)page {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [NSString stringWithFormat:@"%@*%@*%@*%d",[SpellParameters getBasePostString],_hid,_pid,page];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:spellString];
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kTehui_alist];
        NSDictionary *get_JsonDic = [DDQPOSTEncryption judgePOSTDic:get_postDic];
        
        
        for (NSDictionary *dic in get_JsonDic) {

            zhutiModel *model = [[zhutiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_listArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            [_mainCollectionView reloadData];
            [_mainCollectionView.footer endRefreshing];
            self.mainCollectionView.footer.state = MJRefreshStateNoMoreData;
        });
    });
}
#pragma mark - collectionView
-(void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];    [self.mainCollectionView setDelegate:self];
    [self.mainCollectionView setDataSource:self];
    
    [self.mainCollectionView setBackgroundColor:[UIColor backgroundColor]];
    [self.mainCollectionView registerClass:[DDQThemeActivityItem class] forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.mainCollectionView];
}

#pragma mark - delegate and dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    DDQThemeActivityItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    zhutiModel *model = [_listArray objectAtIndex:indexPath.row];
    item.backgroundColor = [UIColor whiteColor];
    item.model = model;
    return item;
}

//设置页眉
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader){
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, reusableView.frame.size.width, reusableView.frame.size.width / 1.9)];
        [reusableView addSubview:headerImageView];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:_ImgURL] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        return reusableView;
    } else {
        return nil;
    }
}

//设置页眉frame
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kScreenHeight*0.3f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 5;
}

//设置item的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (kScreenWidth == 320) {
//        CGFloat itemWidth = 140;
//        if (kScreenHeight == 480) {
//            CGFloat itemHeight = 220;
//            return CGSizeMake(itemWidth, itemHeight);
//        } else {
//            CGFloat itemHeight = (kScreenHeight-64)/2;
//            return CGSizeMake(itemWidth, itemHeight);
//        }
//    } else if (kScreenWidth == 375) {
//        return CGSizeMake(160, (kScreenHeight-64)/2);
//    } else {
//        return CGSizeMake(185, (kScreenHeight-64)/2);
//    }
    return CGSizeMake(kScreenWidth * 0.5 - 10, 250);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //10-28
    zhutiModel *model = _listArray[indexPath.row];
    //10-28
    
    DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:model.ID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
