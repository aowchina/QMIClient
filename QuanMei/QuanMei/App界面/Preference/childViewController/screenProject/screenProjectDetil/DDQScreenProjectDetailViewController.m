//
//  DDQScreenProjectDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectDetailViewController.h"


#import "DDQScreenProjectDetailCollectionViewCell.h"

#import "DDQScreenProjectDetailTableViewCell.h"
#import "DDQScreenProjectViewController.h"
#import "DDQScreenProjectSubTableViewController.h"
#import "Header.h"
//#import "ProjectTableViewController.h"

@interface DDQScreenProjectDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSMutableArray *collectionCellDataArray;

@property (nonatomic ,strong)NSMutableArray *tableViewCellDataArray;
//用于显示的数组
@property (nonatomic,strong)NSMutableArray *nameArray;
//存放所有数据的数组
@property (nonatomic,strong)NSMutableArray *AllArray;
//前九个
@property (nonatomic,strong)NSMutableArray *QArray;
//后面所以
@property (nonatomic,strong)NSMutableArray *HArray;
@property (nonatomic,copy)NSString *str;

@end

@implementation DDQScreenProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.title = @"筛选";
    
    _QArray = [NSMutableArray new];
    _HArray = [NSMutableArray new];
    
    _nameArray = [NSMutableArray new];
    _AllArray = [NSMutableArray new];
    Singleton *model = [Singleton sharedDataTool];
    
    for (NSMutableArray *str in model.TH_TypesNameArray) {
        for (NSString *strr in str) {
            [_nameArray addObject:strr];
        }
        
    }
//    取前九个
    if (_nameArray.count>=8) {
        for (int i = 0; i < _nameArray.count; i++) {
            if(i < 9){
                [_QArray addObject:_nameArray[i]];
            }else{
                [_HArray addObject:_nameArray[i]];
            }
        }
    }else{
        for (int i = 0; i < _nameArray.count; i++) {
            [_QArray addObject:_nameArray[i]];
            [_HArray addObject:_nameArray[i]];
        }
    }

    
    
//    _collectionCellDataArray = [NSMutableArray arrayWithObjects:@"fa",@"das",@"fa",@"das",@"fa",@"das",@"fa",@"das", nil];
//    
//    _tableViewCellDataArray =[NSMutableArray arrayWithObjects:@"眼部",@"脸型",@"嘴巴",@"眼部",@"脸型",@"嘴巴",@"眼部",@"脸型",@"嘴巴", nil];
    
    [self creatView ];
    
}
- (void)creatView
{
    //
    
    int geshu = 0;
    if(_nameArray.count % 3 == 0){
        geshu = (int)_nameArray.count / 3;
    }else{
        geshu = (int)(_nameArray.count + 1) / 3;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.backgroundColor = [UIColor backgroundColor];
    
//    scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
    
    [self.view addSubview:scrollView];
    
    //*****/*
    UIView *headerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight/10)];
    
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.02, 0, headerView.frame.size.width/5, headerView.frame.size.height)];
    selectLabel.text = @"已筛选";
    [headerView addSubview:selectLabel];
    
    
    Singleton *model = [Singleton sharedDataTool];
    
    
    if (_chengshi_name == nil) {
        _str = [NSString stringWithFormat:@"%@",model.CellName];
    }else
    {
        _str = [NSString stringWithFormat:@"%@,%@",_chengshi_name,model.CellName];
    }
    
//    _str = [NSString stringWithFormat:@"%@,%@",_chengshi_name,model.CellName];
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectLabel.frame.origin.x +selectLabel.frame.size.width    ,   0, kScreenWidth*0.6, headerView.frame.size.height)];
    textLabel.text = [NSString stringWithFormat:@"%@",_str];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.font = [UIFont boldSystemFontOfSize:12];
    [headerView addSubview: textLabel];
    
    
    UIView *aView = [[UIView alloc]initWithFrame: CGRectMake(kScreenWidth*0.7   ,   0, kScreenWidth*0.3, headerView.frame.size.height)];
        [headerView addSubview:aView];
    
    
    
    UIButton * cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    cancelButton.frame = CGRectMake(0, aView.frame.size.height/5, headerView.frame.size.width/5, aView.frame.size.height/5*3);
    [cancelButton setTitle:@"取消筛选" forState:(UIControlStateNormal)];
    
    [cancelButton setTintColor:[UIColor blackColor]];
    
    cancelButton.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    cancelButton.layer.borderWidth = 1;
    
    cancelButton.layer.cornerRadius = 2;
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [aView addSubview:cancelButton];
    
    
    
    headerView.backgroundColor = [UIColor whiteColor];
 
    [scrollView addSubview: headerView];
    //
    
    
    //******/*
    UIView *minView  =[[ UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y +headerView.frame.size.height +10, kScreenWidth, kScreenHeight*0.2)];
    minView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:minView.bounds];
    
    tableView.delegate =self;
    
    tableView.dataSource = self;
    tableView.scrollEnabled= NO;
    [minView addSubview:tableView];
    
    [scrollView addSubview:minView];
    //
    
    
    
    //******/*
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,minView.frame.origin.y + minView.frame.size.height  + 10  ,  kScreenWidth, scrollView.frame.size.height - (minView.frame.origin.y + minView.frame.size.height  + 10 ))];
    
    footView.backgroundColor = [UIColor whiteColor];
    
//    CGFloat d = (minView.frame.origin.y + minView.frame.size.height  + 10)   + scrollView.frame.size.height - (minView.frame.origin.y + minView.frame.size.height  + 10);
    
    UILabel *fastLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.02, 0, kScreenWidth, 30)];
    
    fastLabel.text = @"快速筛选";
    
    fastLabel.textColor = [UIColor blackColor];
    
    [footView addSubview:fastLabel];
    
    UIView *coll = [[UIView alloc]initWithFrame:CGRectMake(0, fastLabel.frame.origin.y + fastLabel.frame.size.height, kScreenWidth, geshu*kScreenHeight*0.1)];
    
    [footView addSubview:coll];
    //重新定义高
    scrollView.contentSize = CGSizeMake(kScreenWidth, tableView.frame.origin.y +tableView.frame.size.height+  tableView.frame.size.height + geshu*kScreenHeight*0.1);
    
    
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing =0;
    flowLayout.minimumLineSpacing = 2;
    
    flowLayout.itemSize = CGSizeMake(kScreenWidth*0.33,kScreenHeight*0.1);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, coll.frame.size.width, geshu*kScreenHeight*0.1+10) collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor  = [UIColor whiteColor];
    
    collectionView.scrollEnabled= NO;
    
    [collectionView registerClass:[DDQScreenProjectDetailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [coll addSubview:collectionView];
    
    [scrollView addSubview: footView];
    
    
    
    
}
/////
- (void)cancelButtonClicked
{    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma nark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQScreenProjectDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[DDQScreenProjectDetailTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Singleton *model = [Singleton sharedDataTool];
    if (indexPath.row == 0) {
        //这个判断是区别所选择的类型应该显示在哪一个 row 上
        if ([model.CellID intValue]<= 9) {
            if ([model.CellName isEqualToString:@""]) {
                cell.rightLabel.text = @"";
            }else{
                cell.rightLabel.text = model.CellName;
            }
        }
        cell.leftLabel.text = @"部位";
    }else if(indexPath.row == 1){
        //这个判断是区别所选择的类型应该显示在哪一个 row 上
        if ([model.CellID intValue] > 9) {
            if ([model.CellName isEqualToString:@""]) {
                cell.rightLabel.text = @"";
            }else{
                cell.rightLabel.text = model.CellName;
            }
        }
        cell.leftLabel.text = @"项目";
    }
    
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight*0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDQScreenProjectSubTableViewController *tab = [[DDQScreenProjectSubTableViewController alloc]init];
//    ProjectTableViewController *pro = [[ProjectTableViewController alloc]init];
    if (tab.ListArray.count!=0) {
        [tab.ListArray removeAllObjects];
    }
    
    if (indexPath.row == 0) {
         
        tab.titleStr = @"部位";
        
        tab.ListArray = _QArray;
        
//        tab.allArray = _AllArray;

    }else
    {
        tab.titleStr = @"项目";
        
        tab.ListArray = _HArray;
//        //数据全面
//        tab.allArray = _AllArray;
//        [self.navigationController pushViewController:pro animated:YES];

    }
    [self.navigationController pushViewController:tab animated:YES];

}




#pragma mark - collectionView Delegate And DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _nameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDQScreenProjectDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.typeLabel.text =[NSString stringWithFormat:@"%@", _nameArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    DDQScreenProjectViewController *ddqVC = [[DDQScreenProjectViewController alloc]init];
    
    Singleton *model = [Singleton sharedDataTool];
    NSString *str = [NSString stringWithFormat:@"%@", _nameArray[indexPath.row]];
    for (NSMutableArray *array in model.TH_TypesArray) {
        for (NSDictionary *dic in array) {
            if ([str isEqualToString:[dic objectForKey:@"name"]]) {
                
                if (model.CellName ==nil) {
                    model.CellName = [dic objectForKey:@"name"];
                }else{
                    model.CellName = @"";
                    model.CellName = [dic objectForKey:@"name"];
                }
                
                if (model.CellID ==nil) {
                    model.CellID = [dic objectForKey:@"id"];
                }else{
                    model.CellID = @"";
                    model.CellID = [dic objectForKey:@"id"];
                }
//                ddqVC.types_id = [dic objectForKey:@"id"];
            }
        }
    }
//    DDQScreenProjectViewController
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
