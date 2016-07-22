//
//  DDQScreenProjectViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/8.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectViewController.h"
#import "DDQPreferenceDetailViewController.h"

#import "DDQHotProjectViewCell.h"

#import "DDQScreenProjectDetailViewController.h"

#import "Header.h"

#import "DDQThemeActivityViewController.h"

@interface DDQScreenProjectViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate>

@property (strong,nonatomic) UITableView *mainTableView;



@property (nonatomic ,strong)UIPickerView *pickerView;

@property (nonatomic ,strong)UIToolbar *pickerToolBar;

@property (nonatomic ,strong)UIBarButtonItem *leftItem;

@property (nonatomic ,strong)UIBarButtonItem*rightItem;

@property (nonatomic ,strong)UIView *aView;

@property (strong,nonatomic) NSDictionary *CSDic;
@property (strong,nonatomic) NSDictionary *SFDic;
@property (strong,nonatomic)NSMutableArray *shengArray;
@property (strong,nonatomic)NSMutableArray *shiArray;

@property (assign,nonatomic)NSInteger btn_tag;

@property (nonatomic,strong)UIButton *cityButton;

@property (nonatomic,strong)UIButton *selectButton;

@property (nonatomic,strong)NSMutableArray *screeningArray;

@property (nonatomic,copy)NSString *didSelect;
@property (nonatomic,strong)NSMutableArray *TH_Array;
@property (nonatomic,strong)NSMutableArray *array;
//获取城市的ID
@property (nonatomic,copy)NSString *chengshi_id;
@property (nonatomic,strong)UIButton *typeButton;

@property (nonatomic ,strong)MBProgressHUD *hud;

@end

@implementation DDQScreenProjectViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    Singleton *model = [Singleton sharedDataTool];
    NSString *str;
    if ([model.CellName isEqualToString:@"更多"]) {
        str = @"全部项目";
    }else
    {
        str = model.CellName;
    }
    
    [_typeButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",str] forState:(UIControlStateNormal)];
    
    NSString *idStr;
    if ([model.CellID intValue]==0) {
        idStr = @"0";
    }else{
        idStr = model.CellID;
    }
    NSString *idsheng;
    if (model.shengID == nil || [model.shengID isEqualToString:@""]) {
        idsheng = @"0";
    }else{
        idsheng = model.shengID;
    }
    
    //省
    _sheng_id = idsheng;
    //类型
    _type_id = idStr;
    //排序
    _px_id = @"0";
    //页码
    _page_id = @"1";
    [_TH_Array removeAllObjects];
    [self list];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self changeTxtOfPlist];
    [self initTableView];
    
    _TH_Array = [[NSMutableArray alloc]init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 50)];
    self.navigationItem.titleView = label;
    label.text = self.Name;
    label.textColor = [UIColor meiHongSe];
    label.textAlignment = NSTextAlignmentCenter;
    
}

-(NSString *)didSelect
{
    if (_didSelect ==nil) {
        _didSelect = [[NSString alloc]init];
    }
    return _didSelect;
}

-(NSMutableArray *)_TH_Arrayy
{
    if (!_TH_Array) {
        _TH_Array = [NSMutableArray array];
    }
    return _TH_Array;
}
-(void) myProgressTask{
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        _hud.progress = progress;
        usleep(1000000000);
        
    }
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    
    hud = nil;
}
//接口
-(void)list
{
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    
    [self.view addSubview:_hud];
    
    _hud.mode = MBProgressHUDAnimationFade;
    _hud.delegate = self;
    [_hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    
    
    
    if ([CheckNetWork connectedToNetwork]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //postString
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",[SpellParameters getBasePostString],_sheng_id,_type_id,_px_id,_page_id];
            //加密
            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
            NSString *post_String = [postEncryption stringWithPost:post_baseString];
            //加密字典
            NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kTeHuiTypeUrl];
            //            //解密字典
            //            NSString *json_String = [postEncryption stringWithDic:post_Dic];
            //            NSMutableArray *json_Dic = [[[SBJsonParser alloc] init] objectWithString:json_String];
            NSDictionary *json_Dic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
            //            _TH_Array = [NSMutableArray new];
            
            //            NSMutableArray *dataArray = [json_Dic objectForKey:@"data"];
            for (NSDictionary *dic in json_Dic) {
                THModel *model = [[THModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_TH_Array addObject:model];
            }
            //            [self initTableView];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
                
                [self hudWasHidden:_hud];
                
            });
        });
    }else{
        UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"您的设备当前没有连接网络,请检测网络设置!"  message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [show show];
    }
}

-(void)changeTxtOfPlist {
    _shengArray = [NSMutableArray new];
    _shiArray = [NSMutableArray new];
    
    NSString *SFFilePath = [[NSBundle mainBundle] pathForResource:@"p" ofType:@"txt"];//这是省份的字典
    NSFileHandle *SFFileHandle = [NSFileHandle fileHandleForReadingAtPath:SFFilePath];
    NSData *SFData = [SFFileHandle readDataToEndOfFile];
    NSString *SFJsonString = [[NSString alloc] initWithData:SFData encoding:NSUTF8StringEncoding];
    //    _SFDic = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    _array = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    for (NSDictionary *str in _array) {
        NSString *string = [str objectForKey:@"name"];
        [_shengArray addObject:string];
    }
    
}

-(void)initTableView {
    //    Singleton *model = [Singleton sharedDataTool];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight * 0.1)];
    [view setBackgroundColor:[UIColor backgroundColor]];
    [self.view addSubview:view];
    
    _cityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_cityButton setTitle:@"全国 \u25BE" forState:(UIControlStateNormal)];
    _cityButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _cityButton.tag = 0;
    
    _cityButton.frame = CGRectMake(0, 0, view.frame.size.width/3-1, view.frame.size.height);
    
    [_cityButton addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_cityButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [view addSubview:_cityButton];
    
    
    
    //xxxx
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width/3, view.frame.size.height/4,  1, view.frame.size.height/2)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView1];
    
    _typeButton = [ UIButton buttonWithType:(UIButtonTypeSystem)];
    
    
    
    
    //    [_typeButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",str] forState:UIControlStateNormal];
    
    _typeButton.tag = 1;
    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _typeButton.frame = CGRectMake(view.frame.size.width/3-1, 0, view.frame.size.width/3-1, view.frame.size.height);
    
    [_typeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:_typeButton];
    
    
    //xxxxxx
    UIView *lineView2 =[[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width/3*2, view.frame.size.height/4  , 1 ,   view.frame.size.height/2)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:lineView2];
    
    //筛选
    _selectButton = [ UIButton buttonWithType:(UIButtonTypeSystem)];
    
    [_selectButton setTitle:@"筛选 \u25BE" forState:(UIControlStateNormal)];
    _selectButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];

    _selectButton.tag = 2;
    
    [_selectButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    _selectButton.frame = CGRectMake(view.frame.size.width/3*2-1, 0, view.frame.size.width/3-1, view.frame.size.height);
    
    [_selectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:_selectButton];
    
    _screeningArray = [NSMutableArray arrayWithObjects:@"最新上架",@"价格最低", nil];
    
    
    ////////////////////////////////////////
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kScreenHeight*0.1, self.view.frame.size.width,kScreenHeight-kScreenHeight*0.1-64) style:UITableViewStylePlain];
    self.mainTableView.tableFooterView=[[UIView alloc]init];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    [self refresh];
    [self loading];
}

#pragma mark - tableView Delegate And DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _TH_Array.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (tableView.tag ==100) {
    static NSString *identifier = @"cell";
    
    DDQHotProjectViewCell *hotCell = [[DDQHotProjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    THModel *model = [_TH_Array objectAtIndex:indexPath.row];
    hotCell.model = model;

    return hotCell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //10-30
    THModel *model = [_TH_Array objectAtIndex:indexPath.row];
    DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:model.ID];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
////        return self.view.bounds.size.height * 0.1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.bounds.size.height * 0.225;
}

//按钮点击事件
- (void)buttonClicked:(UIButton *)btn
{
    _didSelect = @"";
    _btn_tag = btn.tag;
    if (btn.tag ==0) {
        [self popUpView];
        
    }
    else
        //筛选类型
        if (btn.tag ==1) {
            DDQScreenProjectDetailViewController *screenProjectDVC = [DDQScreenProjectDetailViewController new];
            
            //
            //        screenProjectDVC.cellName = _TypesName;
            screenProjectDVC.cellID = _types_id;
            screenProjectDVC.chengshi_name = _didSelect;
            
            screenProjectDVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:screenProjectDVC animated:YES];
        }
        else
            if (btn.tag ==2) {
                [self popUpView];
                
            }
}

- (void)popUpView
{
    
    _aView = [[UIView alloc]initWithFrame:CGRectMake(0   ,  0  , kScreenWidth  ,  kScreenHeight)];
    
    [self.view.superview addSubview: _aView];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.7+64, kScreenWidth, self.view.frame.size.height*0.3)];
    
    self.pickerView.delegate =self;
    self.pickerView.dataSource = self;
    
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    [_aView addSubview:self.pickerView];
    
    
    self.pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0   ,   _pickerView.frame.origin.y - _pickerView.frame.size.height/4   ,   _pickerView.bounds.size.width  ,  _pickerView.frame.size.height/4)];
    
    self.pickerToolBar.backgroundColor = [UIColor redColor];
    
    [_aView addSubview:self.pickerToolBar];
    
    _leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelItemTouchEvent)];
    
    _leftItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *middleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    middleItem.title = @"hwhwhwhw";
    
    _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(sureItemTouchEvent)];
    
    _rightItem.tintColor = [UIColor whiteColor];
    
    self.pickerToolBar.items = @[self.leftItem,middleItem,self.rightItem];
    
}
//返回有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}
//返回绑定的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_btn_tag == 0) {
        return _shengArray.count;
    }else if (_btn_tag == 2)
    {
        return _screeningArray.count;
    }
    return 0;
    
}
//返回指定列,行的高度,自定义高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kScreenHeight*0.06;
}
//返回指定列,行的宽度,自定义宽
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width/2;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_btn_tag ==0)
    {
        
        
        _didSelect = [_shengArray objectAtIndex:row];
        [_cityButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",_didSelect] forState:UIControlStateNormal];
        
        
    }
    else if (_btn_tag ==2)
    {
        
        _didSelect = [_screeningArray objectAtIndex:row];
        
        [_selectButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",_didSelect] forState:UIControlStateNormal];
    }
}
//定义列的每行的视图，指定列每行的视图为一致
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (_btn_tag == 0) {
        if (!view) {
            view = [[UIView alloc]init];
        }
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, kScreenHeight*0.06)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [NSString stringWithFormat:@"%@",[_shengArray objectAtIndex:row]];
        [view addSubview:text];
        return view;
        
    }else if (_btn_tag ==2)
    {
        if (!view) {
            view = [[UIView alloc]init];
        }
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, kScreenHeight*0.06)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [NSString stringWithFormat:@"%@",[_screeningArray objectAtIndex:row]];
        [view addSubview:text];
        return view;
        
    }
    return nil;
}

-(void)cancelItemTouchEvent
{
    
    _pickerToolBar.hidden = YES;
    
    _pickerView.hidden = YES;
    [_aView removeFromSuperview];
}
-(void)sureItemTouchEvent
{
    Singleton *model = [Singleton sharedDataTool];
    
    NSInteger row_num = [self.pickerView selectedRowInComponent:0];
    if (row_num == 0) {
        _didSelect = @"北京市";
    }
    
    if ([_didSelect isEqualToString:@""] || _didSelect == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还尚未选择!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        _pickerToolBar.hidden = YES;
        _pickerView.hidden = YES;
        [_aView removeFromSuperview];
        
        return;
    }
    if (_btn_tag ==0) {
        //        [_cityButton setTitle:_didSelect forState:UIControlStateNormal];
        
        
        if (_didSelect == nil) {
            [_cityButton setTitle:@"全国 \u25BE" forState:UIControlStateNormal];
        }else{
            [_cityButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",_didSelect] forState:UIControlStateNormal];
            
            for (int i = 0; i<_array.count; i++) {
                if ([_didSelect isEqualToString:[_array[i] objectForKey:@"name"]]) {
                    _sheng_id = [_array[i] objectForKey:@"id"];
                    model.shengID = [NSString stringWithFormat:@"%@",[_array[i] objectForKey:@"id"]];
                    [_TH_Array removeAllObjects];
                    [self list];
                    
                    
                }
                
                
            }
            
        }
    }
    else if (_btn_tag ==2)
    {
        
        if (_didSelect == nil) {
            [_selectButton setTitle:@"筛选 \u25BE" forState:UIControlStateNormal];
        }else{
            [_selectButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",_didSelect] forState:UIControlStateNormal];
            
            if ([_didSelect isEqualToString:@"最新上架"]) {
                [_TH_Array removeAllObjects];
                
                //                [_typeButton setTitle:[NSString stringWithFormat:@"%@ \u25BE",str] forState:(UIControlStateNormal)];
                _px_id = @"1";
                [self list];
                
            }else if ([_didSelect isEqualToString:@"价格最低"])
            {
                [_TH_Array removeAllObjects];
                _px_id = @"2";
                [self list];
            }
        }
    }
    _pickerToolBar.hidden = YES;
    _pickerView.hidden = YES;
    [_aView removeFromSuperview];
}

//下拉刷新
- (void)refresh
{
    
    // 下拉刷新
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //再次请求接口先判断数组是否为nil
        //        if (_TH_Array.count!=0) {
        [_TH_Array removeAllObjects];
        //        }
        //页码
        _page_id = @"1";
        [self list];
        // 结束刷新
        [self.mainTableView.header endRefreshing];
    }];
    
}
//加载
-(void)loading
{
    
    //    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    self.mainTableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.mainTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        int count = 1;
        count++;
        _page_id = [NSString stringWithFormat:@"%d",count];
        [self list];
        
        // 结束刷新
        [self.mainTableView.footer endRefreshing];
        self.mainTableView.footer.state = MJRefreshStateNoMoreData; 
    }];
    
    //▼
    
}
@end
