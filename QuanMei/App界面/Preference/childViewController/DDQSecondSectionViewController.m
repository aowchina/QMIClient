//
//  DDQSecondSectionViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQSecondSectionViewController.h"
#import "DDQThemeActivityViewController.h"

#import "DDQSecondSectionViewItem.h"

#import "TypesModel.h"

@interface DDQSecondSectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UIView *currentView;

@property (strong,nonatomic) UICollectionView *myCollectionView;

@property (strong,nonatomic) NSMutableArray *act_list;
@end

@implementation DDQSecondSectionViewController

- (void)viewDidLoad {
//
    [super viewDidLoad];
    [self asyProductList];
}
-(void)UI
{
    if (kScreenHeight == 480) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight*0.15*ceil(_act_list.count/2+1))];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else if (kScreenHeight == 568) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight*0.15*ceil(_act_list.count/2+1))];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else if (kScreenHeight == 667) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, kScreenHeight*0.15*ceil(_act_list.count/2+1))];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, kScreenHeight*0.15*ceil(_act_list.count/2+1))];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    }
}



-(void)asyProductList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:spellString];
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kTeHuiListUrl];
        //解密
//        NSString *get_JsonString = [postEncryption stringWithDic:get_postDic];
//        //转换
//        NSDictionary *get_JsonDic = [[[SBJsonParser alloc] init] objectWithString:get_JsonString];
        NSDictionary *get_JsonDic = [DDQPOSTEncryption judgePOSTDic:get_postDic];

        NSMutableArray *firstArray = [get_JsonDic objectForKey:@"act_list"];
        _act_list = [NSMutableArray new];
        for (NSDictionary *dic in firstArray) {
            TypesModel *model = [[TypesModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_act_list addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myCollectionView reloadData];
            [self UI];
        });
    });
}

-(void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.currentView.bounds collectionViewLayout:layout];
    [self.myCollectionView setDelegate:self];
    [self.myCollectionView setDataSource:self];
    
    [self.myCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.myCollectionView setShowsVerticalScrollIndicator:NO];
    [self.myCollectionView registerClass:[DDQSecondSectionViewItem class] forCellWithReuseIdentifier:@"cell"];
    [self.currentView addSubview:self.myCollectionView];
}

#pragma mark - collectionView Delegate And DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _act_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DDQSecondSectionViewItem *secondCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TypesModel *model = [_act_list objectAtIndex:indexPath.row];
    secondCell.model = model;
    return secondCell;
    
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.currentView.frame.size.width*0.5, kScreenHeight*0.15);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDQThemeActivityViewController *activityVC = [[DDQThemeActivityViewController alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];
}
@end
