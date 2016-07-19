//
//  DDQMainSearchViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/6.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMainSearchViewController.h"

//
#import "DDQGroupArticleModel.h"

//日记cell
#import "DDQDiaryViewCell.h"

//特惠自定义cell
#import "DDQThemeActivityItem.h"

//#import "DDQThemeActivityViewController.h"

//跳转详情
#import "DDQMainSearchDetailViewController.h"

//跳转gods详情
#import "DDQMainSearchDetailCollectionViewController.h"

//xiangmu
#import "DDQMainSearchDetailCollectionViewController.h"

//gods model
#import "zhutiModel.h"


//list model
#import "DDQMainSearchModel.h"

//12-11
//跳转日记
#import "DDQUserCommentViewController.h"
#import "DDQHeaderSingleModel.h"
//特惠详情
#import "DDQPreferenceDetailViewController.h"

#import "DDQSearchBar.h"
#import "Header.h"

#import "ProjectNetWork.h"

@interface DDQMainSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,SearchDelegate>
{
    //搜索的字
    NSString * searchBarText;
    //搜索结果
    UIView *searchHearderView;
    
    int riji_count;
    int tiezi_count;
    int tehui_count;
    
}
@property (nonatomic ,strong)UITableView * searchTableView;

@property (nonatomic ,strong)UICollectionView *searchCollectionView;//xiangmu


//日记
@property (nonatomic ,strong)NSMutableArray * diarySearchArray;

//项目
@property (nonatomic ,strong)NSMutableArray *godsSearchArray;

//帖子
@property (nonatomic ,strong)NSMutableArray *postSearchArray;

@property (strong, nonatomic)DDQSearchBar *searchBar;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) ProjectNetWork *netWork;

@property (strong, nonatomic) NSMutableDictionary *sourceDic;

@property (assign, nonatomic) CGFloat rowHeight;

@end

@implementation DDQMainSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    self.searchBar = [[DDQSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 30)];
    self.searchBar.layer.cornerRadius = 15.0f;
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.layer.borderWidth = 2.0f;
    self.searchBar.layer.borderColor = [UIColor backgroundColor].CGColor;
    self.searchBar.layer.masksToBounds = YES;
    
    //11-06
    self.searchBar.delegate = self;
    
    self.searchBar.attributeHolder = [[NSAttributedString alloc] initWithString:@"搜索项目,日记,特惠" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(searchBarEndEditing)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    
    self.netWork = [ProjectNetWork sharedWork];
    
    _godsSearchArray  = [NSMutableArray array];
    _diarySearchArray = [NSMutableArray array];
    _postSearchArray  = [NSMutableArray array];
    
    self.sourceDic = [NSMutableDictionary dictionary];
    
}

- (void)searchBarEndEditing {

    [self.view endEditing:YES];
    
    searchBarText = self.searchBar.inputField.text;
    
    if (searchBarText == nil || [searchBarText isEqualToString:@""]) {
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"请输入搜索内容" andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }else{
        
        [self asyncListForSearchVC];

    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //背景

    //不透明
    self.navigationController.navigationBar.translucent = NO;
    
    //title 颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //返回颜色
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
}

#pragma mark - delegate for searchBar

//页面布局
- (void)creatView
{
    //头
    searchHearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    searchHearderView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:searchHearderView];
    
    UILabel *searchHearderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, searchHearderView.frame.size.width-20, searchHearderView.frame.size.height)];
    
    searchHearderLabel.text = [NSString stringWithFormat:@"关于\"%@\"的搜索结果",searchBarText];
    
    searchHearderLabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1];
    
    [searchHearderView addSubview:searchHearderLabel];
    
    
    //tableView
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
    
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    _searchTableView.tableHeaderView = [self collectionForSearchVC];
    //去线
    _searchTableView.tableFooterView=[[UIView alloc]init];
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_searchTableView];
}

//相关项目
- (UIView*)collectionForSearchVC
{
    //区头
    UIView *view = [[UIView alloc]init];//WithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    //    view.backgroundColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.7f];
    
    
    UILabel * godsSearchLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth, 44)];
    
    godsSearchLabel.text = @"相关项目";
    
    [view addSubview:godsSearchLabel];
    
    //collection
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    _searchCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, godsSearchLabel.frame.size.height, kScreenWidth, 60)  collectionViewLayout:flowlayout];
    
    
    _searchCollectionView.backgroundColor = [UIColor backgroundColor];
    
    _searchCollectionView.scrollEnabled = NO;
    
    _searchCollectionView.delegate =self;
    
    _searchCollectionView.dataSource = self;
    
    [_searchCollectionView registerClass:[DDQThemeActivityItem class] forCellWithReuseIdentifier:@"collcell"];
    
    [view addSubview: _searchCollectionView];
    
    if (_godsSearchArray.count!=0 && _godsSearchArray!=nil) {
        if (_godsSearchArray.count%2 == 0) {
            _searchCollectionView.frame = CGRectMake(0, godsSearchLabel.frame.size.height, kScreenWidth, _godsSearchArray.count/2 * 250+44);
        }else
        {
            _searchCollectionView.frame = CGRectMake(0, godsSearchLabel.frame.size.height, kScreenWidth, (_godsSearchArray.count+1)/2 * 250+44);
            
        }
        
        //更多
        UIView *moreSearchView = [[UIView alloc]initWithFrame:CGRectMake(  0,   _searchCollectionView.frame.origin.y + _searchCollectionView.frame.size.height , kScreenWidth, 44)];
        moreSearchView.backgroundColor = [UIColor whiteColor];
        [view addSubview:moreSearchView];
        
        UILabel *moreLabel = [[UILabel alloc]init];
        moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
        moreLabel.text = @"查看更多";
        moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
        [moreSearchView addSubview:moreLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
        imageView.image = [UIImage imageNamed:@"puss_load_more"];
        [moreSearchView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreSearchCollectionClick)];
        [moreSearchView addGestureRecognizer:tap];
        
        
        view.frame = CGRectMake(0, 0,kScreenWidth , moreSearchView.frame.origin.y + moreSearchView.frame.size.height);
        return view;
    }
    else
    {
        return nil;
    }
}


#pragma mark - delegate for collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _godsSearchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DDQThemeActivityItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
    
    item.backgroundColor = [UIColor whiteColor];
    
    zhutiModel * model = _godsSearchArray[indexPath.row];
    
    item.model = model;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zhutiModel *model = _godsSearchArray[indexPath.row];
    
    
    DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc]initWithActivityID:model.ID];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //    DDQMainSearchDetailCollectionViewController *detailVC =[[ DDQMainSearchDetailCollectionViewController alloc]init];
    //
    //    detailVC.searchTehuiText = searchBarText;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth*0.5-20, 250);
}
- (void)moreSearchCollectionClick
{
    DDQMainSearchDetailCollectionViewController *searchDVC = [[DDQMainSearchDetailCollectionViewController alloc]init];
    searchDVC.searchTehuiText =searchBarText;
    [self.navigationController pushViewController:searchDVC animated:YES];
}

#pragma mark  - delegate for tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (riji_count > 0){
        
        //有日记,有帖子
        if (tiezi_count > 0) {
            //日记的
            if (indexPath.section == 0){
                
                //更多
                if ([indexPath row] ==_diarySearchArray.count){
                    
                    UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
                    UILabel *moreLabel = [[UILabel alloc]init];
                    
                    moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
                    moreLabel.text = @"查看更多";
                    
                    moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
                    [moreCell.contentView addSubview:moreLabel];
                    
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
                    imageView.image = [UIImage imageNamed:@"puss_load_more"];
                    
                    [moreCell.contentView addSubview:imageView];
                    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return moreCell;
                    
                } else {
                    
                    DDQGroupArticleModel *articleModel;
                    if (_diarySearchArray.count > 0) {
                        
                        articleModel = [_diarySearchArray objectAtIndex:indexPath.row];
                        
                    }
                    
                    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
                    diaryCell.articleModel = articleModel;
                    self.rowHeight = diaryCell.newRect.size.height;
                    diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
                    diaryCell.backgroundColor = [UIColor myGrayColor];
                    
                    return diaryCell;
                    
                }
                
            }
            
            //帖子的
            if (indexPath.section == 1) {
                
                if ([indexPath row] ==_postSearchArray.count) {
                    
                    UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
                    UILabel *moreLabel = [[UILabel alloc]init];
                    
                    moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
                    moreLabel.text = @"查看更多";
                    
                    moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
                    [moreCell.contentView addSubview:moreLabel];
                    
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
                    imageView.image = [UIImage imageNamed:@"puss_load_more"];
                    
                    [moreCell.contentView addSubview:imageView];
                    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return moreCell;
                    
                } else {
                    
                    DDQGroupArticleModel *articleModel;
                    if (_postSearchArray.count > 0) {
                        
                        articleModel = [_postSearchArray objectAtIndex:indexPath.row];
                        
                    }
                    
                    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
                    diaryCell.articleModel = articleModel;
                    self.rowHeight = diaryCell.newRect.size.height;

                    diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
                    diaryCell.backgroundColor = [UIColor myGrayColor];
                    
                    return diaryCell;
                }
                
            }
            
        //只有日记
        } else {
            
            //更多
            if ([indexPath row] ==_diarySearchArray.count) {
                
                UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
                UILabel *moreLabel = [[UILabel alloc]init];
                
                moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
                moreLabel.text = @"查看更多";
                
                moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
                [moreCell.contentView addSubview:moreLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
                imageView.image = [UIImage imageNamed:@"puss_load_more"];
                
                [moreCell.contentView addSubview:imageView];
                moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return moreCell;
                
            } else {
                
                DDQGroupArticleModel *articleModel;
                if (_diarySearchArray.count > 0) {
                    
                    articleModel = [_diarySearchArray objectAtIndex:indexPath.row];
                    
                }
                
                DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
                diaryCell.articleModel = articleModel;
                self.rowHeight = diaryCell.newRect.size.height;

                diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
                diaryCell.backgroundColor = [UIColor myGrayColor];
                return diaryCell;
                
            }
            
        }
        
    //没有日记
    } else {
        //有帖子
        if (tiezi_count > 0) {
            
            if ([indexPath row] ==_postSearchArray.count) {
                
                UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
                UILabel *moreLabel = [[UILabel alloc]init];
                
                moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
                moreLabel.text = @"查看更多";
                
                moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
                [moreCell.contentView addSubview:moreLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
                imageView.image = [UIImage imageNamed:@"puss_load_more"];
                
                [moreCell.contentView addSubview:imageView];
                moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return moreCell;
        
            } else {
                
                DDQGroupArticleModel *articleModel;
                if (_postSearchArray.count > 0) {
                    
                    articleModel = [_postSearchArray objectAtIndex:indexPath.row];
                    
                }
                
                DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
                diaryCell.articleModel = articleModel;
                self.rowHeight = diaryCell.newRect.size.height;

                diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
                diaryCell.backgroundColor = [UIColor myGrayColor];
                return diaryCell;
                
                
            }
            
        //没有帖子
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            return cell;
            
        }
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
    
}
//12-11
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (riji_count > 0) {
        //日记
        if (indexPath.section ==0 ) {
            
            //hangwei
            return [self sectionRowHeightWithSource:self.diarySearchArray Path:indexPath];
            
        //帖子
        } else if (indexPath.section ==1) {
            
           return [self sectionRowHeightWithSource:self.postSearchArray Path:indexPath];
            
        }
        
    } else if (tiezi_count > 0) {
        
        return [self sectionRowHeightWithSource:self.postSearchArray Path:indexPath];
        
    }
    return 44;
}

//12-11
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    NSString *key = @(section).stringValue;
//    NSArray *allKey = [self.sourceDic allKeys];
//    
//    if ([allKey containsObject:key]) {
//        
//        NSArray *array = [self.sourceDic valueForKey:key];
//        NSLog(@"%@,%s", array, __func__);
//        return array.count;
//        
//    } else {
//    
//        return 0;
//        
//    }
    
    if (riji_count > 0) {
        
        if (tiezi_count > 0) {
            
            switch (section) {
                    
                case 0:{
                    
                    return _diarySearchArray.count + 1;
                    break;
                }
                    
                case 1: {
                    
                    return _postSearchArray.count + 1;
                    break;
                }
                    
                default:
                    break;
                    
            }
            
        } else {
            
            return _postSearchArray.count + 1;
            
        }
        
    } else if (tiezi_count > 0) {
        
        return _postSearchArray.count + 1;
        
    } else {
        
        return 0;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //返回数组个数
//    NSLog(@"%ld", self.sourceDic.allKeys.count);
//    return self.sourceDic.allKeys.count;
    
    if (riji_count > 0) {
        
        if (tiezi_count > 0) {
            
            return 2;
            
        } else {
            
            return 1;
            
        }
        
    } else if (tiezi_count > 0) {
        
        return 1;
        
    } else {
        
        return 0;
        
    }
    return 0;
    
}
//12-11
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (![DDQPublic isBlankString:riji_count] && [riji_count intValue] !=0) {
//
//        if (![DDQPublic isBlankString:tiezi_count]&& [tiezi_count intValue] !=0) {
//            switch (section) {
//                case 0:
//                {
//                    return @"相关日记";
//                    break;
//                }
//                case 1:
//                {
//                    return @"相关帖子";
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//        else
//        {
//            return @"相关日记";
//        }
//    }
//    else
//        if (![DDQPublic isBlankString:tiezi_count] &&[tiezi_count intValue] !=0) {
//
//            return @"相关帖子";
//        }
//        else
//        {
//            return nil;
//        }
//    return nil;
//}
//12-11
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (riji_count > 0) {
        
        if (tiezi_count > 0) {
            
            if (indexPath.section ==0 ) {
                
                //日记更多
                if ( _diarySearchArray.count == indexPath.row) {
                    
                    DDQMainSearchDetailViewController * searchDetail = [[DDQMainSearchDetailViewController alloc]init];
                    
                    searchDetail.navigationItem.title = @"日记";
                    
                    searchDetail.type = @"1";
                    
                    searchDetail.searchWenzhangText = searchBarText;
                    [self.navigationController pushViewController:searchDetail animated:YES];
                
                //详情
                } else {
                    
                    DDQGroupArticleModel *articleModel =self.diarySearchArray[indexPath.row];
                    
                    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
                    commentVC.hidesBottomBarWhenPushed = YES;
                    //赋值
                    commentVC.ctime                      = articleModel.ctime;
                    commentVC.articleId                  = articleModel.articleId;
                    commentVC.userid                     = articleModel.userid;
                    [self.navigationController pushViewController:commentVC animated:YES];
                    
                }

            }

            if (indexPath.section ==1) {
                
                if (_postSearchArray.count == indexPath.row) {
                    
                    DDQMainSearchDetailViewController *searchDetail = [[DDQMainSearchDetailViewController alloc]init];
                    
                    searchDetail.navigationItem.title = @"帖子";
                    
                    searchDetail.type = @"2";
                    
                    searchDetail.searchWenzhangText = searchBarText;
                    
                    [self.navigationController pushViewController:searchDetail animated:YES];
                    
                //帖子详情
                } else {
                    
                    DDQGroupArticleModel *articleModel = _postSearchArray[indexPath.row];
                    
                    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
                    commentVC.hidesBottomBarWhenPushed = YES;
                    //赋值
                    commentVC.ctime                      = articleModel.ctime;
                    commentVC.articleId                  = articleModel.articleId;
                    commentVC.userid                     = articleModel.userid;
                    [self.navigationController pushViewController:commentVC animated:YES];
                }
                
            }
            
        //只有日记
        } else {
            
            //日记更多
            if (indexPath.section ==0) {
                
                if(_diarySearchArray.count == indexPath.row) {
                    
                    DDQMainSearchDetailViewController * searchDetail = [[DDQMainSearchDetailViewController alloc]init];
                    
                    searchDetail.navigationItem.title = @"日记";
                    
                    searchDetail.type = @"1";
                    
                    searchDetail.searchWenzhangText = searchBarText;
                    [self.navigationController pushViewController:searchDetail animated:YES];
                
                //日记详情
                } else {
                    
                    DDQGroupArticleModel *articleModel = _diarySearchArray [indexPath.row];
                    
                    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
                    commentVC.hidesBottomBarWhenPushed = YES;
                    //赋值
                    commentVC.ctime                      = articleModel.ctime;
                    commentVC.articleId                  = articleModel.articleId;
                    commentVC.userid                     = articleModel.userid;
                    [self.navigationController pushViewController:commentVC animated:YES];
                    
                }
                
            }
            
        }
       
    //没有日记
    } else if (tiezi_count > 0) {
        
        //帖子更多
        if (indexPath.section ==0) {
            
            if (_postSearchArray.count == indexPath.row) {
                
                DDQMainSearchDetailViewController *searchDetail = [[DDQMainSearchDetailViewController alloc]init];
                
                searchDetail.navigationItem.title = @"帖子";
                
                searchDetail.type = @"2";
                
                searchDetail.searchWenzhangText = searchBarText;
                
                [self.navigationController pushViewController:searchDetail animated:YES];
                
            //帖子详情
            } else {
                
                DDQGroupArticleModel *articleModel = _postSearchArray[indexPath.row];
                
                DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
                commentVC.hidesBottomBarWhenPushed = YES;
                //赋值
                commentVC.ctime                      = articleModel.ctime;
                commentVC.articleId                  = articleModel.articleId;
                commentVC.userid                     = articleModel.userid;
                [self.navigationController pushViewController:commentVC animated:YES];
                
            }
            
        }
        
    }
    
}

//12-21
- (void)asyncListForSearchVC {
    
    if (searchBarText != nil && ![searchBarText isEqualToString:@""]) {
        
        [self.hud show:YES];
        
        NSData *data1 = [searchBarText dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray1 = (Byte *)[data1 bytes];
        NSMutableString *searchtext = [[NSMutableString alloc] init];
        
        for(int i=0;i<[data1 length];i++) {
            
            [searchtext appendFormat:@"%d#",byteArray1[i]];
            
        }
        
        [self.netWork asyPOSTWithAFN_url:kSearchUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],searchtext] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            } else {
            
                tehui_count = [responseObjc[@"th_amount"] intValue];
                riji_count  = [responseObjc[@"rj_amount"] intValue];
                tiezi_count = [responseObjc[@"tz_amount"] intValue];
                
                if (tehui_count > 0) {
                
                    for (NSDictionary *dic1 in responseObjc[@"th"]) {
                        
                        NSDictionary * dic = [DDQPublic nullDic:dic1];
                        
                        zhutiModel *thmodel = [[zhutiModel alloc]init];
                        
                        thmodel.fname = dic[@"fname"];
                        thmodel.ID = dic[@"id"];
                        thmodel.name = dic[@"name"];
                        thmodel.newval = dic[@"newval"];
                        thmodel.oldval = dic[@"oldval"];
                        thmodel.simg = dic[@"simg"];
                        thmodel.hname = dic[@"hname"];
                        
                        [_godsSearchArray addObject: thmodel];
                        
                    }
                    
                    [self.sourceDic setValue:_godsSearchArray forKey:@"2"];
                    
                }
                
                if (riji_count > 0) {
                    
                    for (NSDictionary *dic1 in responseObjc[@"rj"]) {
                        
                        NSDictionary * dic = [DDQPublic nullDic:dic1];
                        
                        DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                        //精或热
                        articleModel.isJing        = [dic valueForKey:@"isjing"];//1是精,0不是
                        articleModel.articleTitle  = [dic valueForKey:@"title"];
                        articleModel.articleType   = [dic valueForKey:@"type"];
                        articleModel.introString   = [dic valueForKey:@"text"];
                        articleModel.replyNum      = [dic valueForKey:@"pl"];
                        articleModel.thumbNum      = [dic valueForKey:@"zan"];
                        articleModel.groupName     = [dic valueForKey:@"groupname"];
                        articleModel.articleId     = dic[@"id"];
                        articleModel.userid = [dic valueForKey:@"userid"];
                        articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                        articleModel.userName      = [dic valueForKey:@"username"];
                        articleModel.imgArray      = [dic valueForKey:@"imgs"];
                        articleModel.ctime         = [dic valueForKey:@"ctime"];
                        
                        [_diarySearchArray addObject:articleModel];
                        
                    }
                    
                    [self.sourceDic setValue:_diarySearchArray forKey:@"0"];

                }
                
                if (tiezi_count > 0) {
                    
                    for (NSDictionary *dic1 in responseObjc[@"tz"]) {
                        
                        NSDictionary * dic = [DDQPublic nullDic:dic1];
                        
                        DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                        //精或热
                        articleModel.isJing        = [dic valueForKey:@"isjing"];//1是精,0不是
                        articleModel.articleTitle  = [dic valueForKey:@"title"];
                        articleModel.articleType   = [dic valueForKey:@"type"];
                        articleModel.introString   = [dic valueForKey:@"text"];
                        articleModel.replyNum      = [dic valueForKey:@"pl"];
                        articleModel.thumbNum      = [dic valueForKey:@"zan"];
                        
                        articleModel.groupName     = [dic valueForKey:@"groupname"];
                        articleModel.articleId     = dic[@"id"];
                        articleModel.userid = [dic valueForKey:@"userid"];
                        articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                        articleModel.userName      = [dic valueForKey:@"username"];
                        articleModel.imgArray      = [dic valueForKey:@"imgs"];
                        articleModel.ctime         = [dic valueForKey:@"ctime"];
                        
                        [_postSearchArray addObject: articleModel];
                        
                    }
                    
                    [self.sourceDic setValue:_postSearchArray forKey:@"1"];

                }
                
                [self.hud hide:YES];
                [self creatView];
                
            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];

    }
    
}

- (CGFloat)sectionRowHeightWithSource:(NSArray *)array Path:(NSIndexPath *)path {
 
    CGFloat h;
    if (kScreenHeight <= 568) {
        
        h = 20;
        
    } else if (kScreenHeight == 667) {
        
        h = 30;
        
    } else {
        
        h = 40;
        
    }
    
    if (path.section == 0) {
        
        if (path.row == array.count) {
            
            return 44;
            
        } else if (array != 0) {
            
            return  self.rowHeight + kScreenHeight*0.5-h;
            
        } else {
            
            DDQGroupArticleModel *model;
            
            if (array.count > 0) {
                
                model = array[path.row];
                
            }
            
            if (model.imgArray.count == 0 ){//不传图的情况
                
                if ([model.introString isEqualToString:@""]) {//不传图还不传字
                    
                    return kScreenHeight *0.25 - h;
                    
                } else {//有字，那就是帖子了
                    
                    return kScreenHeight *0.25 + self.rowHeight - h;
                    
                }
                
            } else {//传了图
                
                return self.rowHeight + kScreenHeight *0.5-h;
                
            }
            
        }
        
    } else {
        
        return kScreenHeight*0.2;
        
    }

}

//12-04
- (void)leftBarButtonItemForMainSearchVC {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
