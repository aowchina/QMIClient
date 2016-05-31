//
//  DDQFirstSectionViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQFirstSectionViewController.h"
#import "DDQScreenProjectViewController.h"

#import "DDQFirstSectionViewItem.h"
#import "TypesModel.h"


@interface DDQFirstSectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UIView *currentView;

@property (strong,nonatomic) UICollectionView *myCollectionView;
/**
 *  用来装假数据的数组
 */
@property (strong,nonatomic) NSArray *falseDataArray;


@property (strong,nonatomic)NSMutableArray *typesArray;
@property (strong,nonatomic)NSMutableArray *nameArray;
@property (strong,nonatomic)NSMutableArray *array;
//list
@property (strong,nonatomic)NSMutableArray *act_fitst_array;

@end

@implementation DDQFirstSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kScreenHeight == 480) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight*0.3)];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else if (kScreenHeight == 568) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568*0.3)];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else if (kScreenHeight == 667) {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, kScreenHeight*0.3)];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    } else {
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, kScreenHeight*0.3)];
        [self.view addSubview:self.currentView];
        [self initCollectionView];
    }
    [self asyProductList];
}

-(void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.currentView.bounds collectionViewLayout:layout];
    [self.myCollectionView setDelegate:self];
    [self.myCollectionView setDataSource:self];
    
    [self.myCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.myCollectionView setShowsVerticalScrollIndicator:NO];
    [self.myCollectionView registerClass:[DDQFirstSectionViewItem class] forCellWithReuseIdentifier:@"cell"];
    [self.currentView addSubview:self.myCollectionView];
}
#pragma mark - 网络相关
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
        NSString *get_JsonString = [postEncryption stringWithDic:get_postDic];
        //转换
        NSDictionary *get_JsonDic = [[[SBJsonParser alloc] init] objectWithString:get_JsonString];
//        NSMutableArray *firstArray = [get_JsonDic objectForKey:@"act_first"];
        NSMutableArray *tArray = [get_JsonDic objectForKey:@"types"];
        _typesArray = [NSMutableArray new];
        _nameArray = [NSMutableArray new];
        _array = [NSMutableArray new];
        _act_fitst_array = [NSMutableArray new];
        //表视图
//        for (NSDictionary *dic in firstArray) {
//            NSString *str1 = [dic objectForKey:@"amount"];
//            NSString *str2 = [dic objectForKey:@"bimg"];
//            NSString *str3 = [dic objectForKey:@"fname"];
//            NSString *str4 = [dic objectForKey:@"hid"];
//            NSString *str5 = [dic objectForKey:@"id"];
//            NSString *str6 = [dic objectForKey:@"intime"];
//            NSString *str7 = [dic objectForKey:@"name"];
//            NSString *str8 = [dic objectForKey:@"pid"];
//            NSString *str9 = [dic objectForKey:@"simg"];
//            NSMutableArray *array = [NSMutableArray arrayWithObjects:str1,str2,str3,str4,str5,str6,str7,str8,str9, nil];
//            [_act_fitst_array addObject:array];
//        }
        
        //特惠列表
        for (NSDictionary *dic in tArray) {
            NSString *str = [dic objectForKey:@"name"];
            [_nameArray addObject:str];
            
            TypesModel *model = [[TypesModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_typesArray addObject:model];
            
        }
        if (_nameArray.count>=7) {
            NSArray *arr = [_nameArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7)]];
            for (NSString *str in arr) {
                [_array addObject:str];
            }
            [_array addObject:@"更多"];
         }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myCollectionView reloadData];
        });
    });
}


#pragma mark - collectionView Delegate And DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    if (_typesArray.count<=6) {
        return _typesArray.count;
    }else
    {
        return 8;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDQFirstSectionViewItem *firstItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [firstItem.positionLabel setText:[self.falseDataArray objectAtIndex:indexPath.row]];
    if (indexPath.row == 6) {
        [firstItem.positionLabel setFont:[UIFont systemFontOfSize:11]];
    } else {
        [firstItem.positionLabel setFont:[UIFont systemFontOfSize:12]];
        [firstItem.positionLabel setTextAlignment:NSTextAlignmentCenter];
    }
    if (_typesArray.count<=6) {
//        TypesModel *model = [_typesArray objectAtIndex:indexPath.row];
//        firstItem.model = model;
        return firstItem;

    }else
    {
        [firstItem.positionLabel setText:[_array objectAtIndex:indexPath.row]];
        return firstItem;
    }
    
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.currentView.frame.size.width*0.25, self.currentView.frame.size.height*0.5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//七点21
//    TypesModel *model = [_typesArray objectAtIndex:indexPath.row];
    
    DDQScreenProjectViewController *screenProjectVC = [[DDQScreenProjectViewController alloc] init];
//    if (_typesArray.count<=6) {
//        
//    }else
//    {
//        
//    }

    
    screenProjectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:screenProjectVC animated:YES];
}

#pragma mark - lazy load
//-(NSArray *)falseDataArray{
//    if (!_falseDataArray) {
//        _falseDataArray = [NSArray arrayWithObjects:@"脸型",@"眼部",@"鼻部",@"胸部",@"皮肤",@"身材",@"微整形",@"更多", nil];
//    }
//    return _falseDataArray;
//}

@end
