//
//  DDQWriteDiaryViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

//12-02
#import "DDQWriteDiaryViewController.h"

#import "DDQPostingCollectionViewCell.h"

#import "DDQGroupDetailViewController.h"

#import "DDQHeaderSingleModel.h"

#import "DDQGroupCollectionViewCell.h"
//图片多选
#import "SGImagePickerController.h"

#import "UICKeyChainStore.h"

#import "DDQLoginViewController.h"
#import "DDQTagModel.h"
@interface DDQWriteDiaryViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

//12-21活动指示器
@property (nonatomic ,strong)MBProgressHUD *hud;

@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)UITextField *hospitleTextField;
@property (nonatomic ,strong)UITextField *titleTextField;

@property (nonatomic ,strong)UIView *backView;//遮掩
@property (nonatomic ,strong)UIView *showView;

@property (nonatomic ,strong)UIButton *typeButton;//标签
@property (nonatomic ,strong)UILabel *alabel;

//10-22
@property (nonatomic ,strong)UIScrollView *photoScrollview;//zhaopian

@property (nonatomic ,strong)UICollectionView *photoCollectionView;

@property (nonatomic ,strong)NSMutableArray *linshiPhotoArray;//临时存放保存的图片

@property (nonatomic ,assign)NSInteger pathRow;

@property (nonatomic ,strong)UIButton *moneyButton;//花费

@property (nonatomic ,strong)NSArray *moneyArray;//金额

@property (nonatomic ,strong)UIView *priceView;//价格视图
@property (nonatomic ,strong)NSString *moneyString;//钱
@property (nonatomic ,strong)NSString *hospitleString;//医院
@property (nonatomic ,strong)NSString *titleString;//标题
@property (nonatomic ,strong)NSString *contetSTring;//内容


@property (nonatomic ,strong)UIView *writeTagView;//标签视图

//11-05
@property (nonatomic ,strong)NSMutableDictionary *tagDic;//选中的标签
@property (nonatomic ,strong)NSMutableString *writeString;//存放标签

@end

@implementation DDQWriteDiaryViewController
- (NSMutableArray *)collectionArray
{
    if (!_collectionArray) {
        _collectionArray = [[NSMutableArray alloc]init];
    }
    
    return _collectionArray;
}
- (NSMutableArray *)writeDTagArray
{
    if (!_writeDTagArray) {
        _writeDTagArray = [[NSMutableArray alloc]init];
    }
    return _writeDTagArray;
}
- (NSArray *)moneyArray
{
    if (!_moneyArray) {
        _moneyArray = [[NSMutableArray alloc]init];
    }
    return _moneyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _moneyArray = @[@"3000元以下",@"3000-6000元",@"6000-1万元",@"1万元-2万元",@"2万元-5万元",@"5万元以上"];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"写新日记";
    
    [self creatView];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(writeVCReplay)];
    
    self.navigationItem.rightBarButtonItem = bar;
    
    //11-05
    _tagDic = [[NSMutableDictionary alloc]init];
}

- (void)creatView
{
    //输入
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0 ,  0 , self.view.frame.size.width, self.view.frame.size.height/2+30)];
    
    blackView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:blackView];
    
    
    _titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, blackView.frame.size.width-10, 29)];
    _titleTextField.placeholder  = @"请输入帖子标题";
    
    _titleTextField.tag = 101;
    
    _titleTextField.delegate = self;
    
    [blackView addSubview:_titleTextField];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29, blackView.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    
    [blackView addSubview:lineView1];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 30, blackView.frame.size.width, blackView.frame.size.height-110)];
    
    _textView.font = [UIFont systemFontOfSize:14];
    
    _textView.delegate = self;
    
    [blackView addSubview:_textView];
    
    _alabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, blackView.frame.size.width-10, 30)];
    
    _alabel.text = @"请输入帖子内容";
    
    _alabel.font = [UIFont systemFontOfSize:14];
    
    _alabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255  blue:147.0/255  alpha:0.4f];
    
    _alabel.enabled = NO;
    
    _alabel.backgroundColor = [UIColor clearColor];
    _alabel.textColor = [UIColor redColor];
    
    [blackView addSubview:_alabel];
    
    //10-22
    //照片
    UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(0, _textView.frame.origin.y + _textView.frame.size.height, _textView.frame.size.width, 50)];
    photoView.backgroundColor = [UIColor whiteColor];
    
    [blackView addSubview:photoView];
    
    _photoScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, photoView.frame.size.width, 50)];
    
    _photoScrollview.contentSize = CGSizeMake(_collectionArray.count *80+50, 50);
    
    _photoScrollview.bounces = NO;
    
    [photoView addSubview:_photoScrollview];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _photoScrollview.frame.size.width, 70)  collectionViewLayout:flowlayout];
    
    _photoCollectionView.delegate =self;
    
    //11-05
    _photoCollectionView.tag =101;
    
    _photoCollectionView.dataSource = self;
    
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_photoCollectionView registerClass:[DDQPostingCollectionViewCell class] forCellWithReuseIdentifier:@"collcell"];
    
    [_photoScrollview addSubview: _photoCollectionView];
    
    
    //分割线
    UIView *hoslineView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.frame.size.height - 30, blackView.frame.size.width, 1)];
    
    hoslineView.backgroundColor = [UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.5f];
    [blackView addSubview: hoslineView];
    
    UIView *hospitleView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.frame.size.height-29, blackView.frame.size.width, 29)];
    
    hospitleView.backgroundColor = [UIColor whiteColor];
    
    [blackView addSubview:hospitleView];
    
    
    _hospitleTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, hospitleView.frame.size.width/3*2, hospitleView.frame.size.height)];
    
    _hospitleTextField.placeholder = @"医院(可不填)";
    
    _hospitleTextField.tag = 102;
    _hospitleTextField.delegate = self;
    
    [hospitleView addSubview:_hospitleTextField];
    
    
    UIView *shuLineView = [[UIView alloc]initWithFrame:CGRectMake(_hospitleTextField.frame.size.width, hospitleView.frame.size.height *0.1, 1, hospitleView.frame.size.height*0.8)];
    
    shuLineView.backgroundColor =[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:0.5f];
    
    [hospitleView addSubview:shuLineView];
    
    
    _moneyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _moneyButton.frame = CGRectMake(_hospitleTextField.frame.size.width + shuLineView.frame.size.width, 0, hospitleView.frame.size.width/3-1, hospitleView.frame.size.height);
    
    [_moneyButton setTitle:@"花费" forState:(UIControlStateNormal)];
    
    [_moneyButton setTitleColor:kTextColor forState:(UIControlStateNormal)];
    
    [_moneyButton addTarget:self action:@selector(moneyButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    [hospitleView addSubview:_moneyButton];
    
    
    //10-22
    //底部
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.frame.origin.y + blackView.frame.size.height +10, blackView.frame.size.width, self.view.frame.size.height - blackView.frame.size.height-10)];
    
    footView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footView];
    
    
    UIView *tubiaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footView.frame.size.width, 30)];
    
    [footView addSubview:tubiaoView];
    
    
    
    UIButton *photoButton1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    photoButton1.frame = CGRectMake(tubiaoView.frame.size.height*0.1, tubiaoView.frame.size.height*0.1,tubiaoView.frame.size.height*0.8 , tubiaoView.frame.size.height*0.8);
    
    [photoButton1 setBackgroundImage:[UIImage imageNamed:@"btn_insert_pic_nor"] forState:(UIControlStateNormal)];
    //10-21
    [photoButton1 addTarget:self action:@selector(blackBttonClickedWriteVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [tubiaoView addSubview:photoButton1];
    
    
    
    _typeButton  = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _typeButton.frame = CGRectMake(tubiaoView.frame.size.height+tubiaoView.frame.size.height*0.1  ,tubiaoView.frame.size.height*0.1, photoButton1.frame.size.height, photoButton1.frame.size.height);
    
    [_typeButton setBackgroundImage:[UIImage imageNamed:@"btn_insert_tag_nor"] forState:(UIControlStateNormal)];
    
    [_typeButton addTarget:self action:@selector(typeButtonClickedWriteD) forControlEvents:(UIControlEventTouchUpInside)];
    
    [tubiaoView addSubview:_typeButton];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0 ,tubiaoView.frame.origin.y +tubiaoView.frame.size.height+1 ,  footView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor backgroundColor];
    
    [footView addSubview:lineView];
}

#pragma  选择标签
- (void)typeButtonClickedWriteD
{
    static NSInteger butt = 1;
    if (butt ==1) {
        
        _writeTagView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2+30+40+40 , self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.height/2-64+30)+40-40)];
        
        [self.view  addSubview:_writeTagView];
        
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        
        UICollectionView * tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,_writeTagView.frame.size.width, _writeTagView.frame.size.height)  collectionViewLayout:flowlayout];
        
        tagCollectionView.delegate =self;
        
        tagCollectionView.dataSource = self;
        
        tagCollectionView.tag = 103;
        
        tagCollectionView.backgroundColor = [UIColor whiteColor];
        
        [tagCollectionView registerClass:[DDQGroupCollectionViewCell class] forCellWithReuseIdentifier:@"groupcollcell"];
        [_writeTagView addSubview: tagCollectionView];
        
        butt --;
    }
    else
        if (butt == 0) {
            
            [_writeTagView removeFromSuperview];
            butt++;
        }
    
}
//12-02
#pragma mark 花费
- (void)moneyButtonClicked
{
    [_priceView removeFromSuperview];
    
    _priceView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2+60, self.view.frame.size.width, self.view.frame.size.height/2-30-20)];
    
    [self.view addSubview:_priceView];
    
    UITableView *priceTableView = [[UITableView alloc]initWithFrame:_priceView.bounds style:(UITableViewStylePlain)];
    
    priceTableView.delegate = self;
    
    priceTableView.dataSource = self;
    
    priceTableView.bounces = NO;
    
    [_priceView addSubview:priceTableView];
}

//12-02
#pragma mark - delegate for tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
    if (!tableCell) {
        
        tableCell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
        tableCell.textLabel.text =_moneyArray[indexPath.row];
        tableCell.textLabel.textColor = kTextColor;
    }
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _moneyArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    _moneyString = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [_moneyButton setTitle:cell.textLabel.text forState:(UIControlStateNormal)];
    
    [_priceView removeFromSuperview];
}

//10-22
//11-05
#pragma mark dele for collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag ==103) {
        return _writeDTagArray.count;
    }
    else{
        if (collectionView.tag ==101) {
            _photoScrollview.contentSize = CGSizeMake(_collectionArray.count *60+70, 50);
            _photoCollectionView.frame = CGRectMake(0, 0, _collectionArray.count *60+70, 50);
            
            if (_collectionArray.count<4)
            {
                if (_collectionArray.count ==0)
                {
                    return 1;
                }
                else
                {
                    
                    return  _collectionArray.count+1;
                }
            }
        }
    }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 103) {
        DDQGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupcollcell" forIndexPath:indexPath];
        DDQTagModel *model = _writeDTagArray[indexPath.row];
        cell.title.text = model.name;
        
        //11-06
        cell.layer.borderColor=[UIColor colorWithRed:227.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f].CGColor;
        
        cell.layer.cornerRadius = 10;
        
        cell.layer.borderWidth=1;
        
        return cell;
    }
    else
    {
        if (collectionView.tag ==101) {
            
            _pathRow = indexPath.row;
            
            DDQPostingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
            
            cell.backgroundColor = [UIColor whiteColor];
            
            if (_collectionArray.count == indexPath.row && _collectionArray.count <=3) {
                
                //10-21
                cell.postingImageView.image = [UIImage imageNamed:@"topic_upload_pic"];
                [cell.postingCancelButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
            }
            else
            {
                //10-26
                [cell.postingCancelButton setBackgroundImage:[UIImage imageNamed:@"treands_photo_del"] forState:(UIControlStateNormal)];
                
                cell.postingImageView.image = [UIImage imageWithData: _collectionArray[indexPath.row]];
            }
            return cell;
        }
        return nil;
        
    }
}
//11-05
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger weizhi = indexPath.row;
    
    if (collectionView.tag == 103)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        DDQTagModel *model = _writeDTagArray[indexPath.row];
        NSString *tag = model.iD;
        
        if ([_tagDic objectForKey:[NSString stringWithFormat:@"%ld",weizhi]] == nil) {
            [_tagDic setObject:[NSString stringWithFormat:@"%@",tag] forKey:[NSString stringWithFormat:@"%ld",weizhi]];
            
            //10-06
            //12-14
            cell.layer.borderColor=[UIColor meiHongSe].CGColor;
            cell.layer.borderWidth=1;
        }
        else
        {
            [_tagDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)weizhi]];
            //10-06
            cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
            cell.layer.borderWidth=1;
        }
    }
    
    //101 标签
    //11-06
    else
        if (collectionView.tag == 101)
        {
            if (indexPath.row <3)
            {
                if (indexPath.row == _collectionArray.count)
                {
                    [self blackBttonClickedWriteVC];
                }
                else
                {
                    [_collectionArray removeObjectAtIndex:indexPath.row];
                    [_photoCollectionView reloadData];
                }
            }
            else
                if (indexPath.row ==3)
                {
                    //12-22
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"最多上传三张图片" preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction *enalbleAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                    
                    [alertController addAction:enalbleAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
        }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 103) {
        
        return UIEdgeInsetsMake(1, 10, 1, 10);
        
    } else {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0.0f;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0.0f;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //11-06
    if (collectionView.tag ==103) {//103是小的collectionview
        
        if (kScreenWidth >= 375) {
            
            return CGSizeMake(kScreenWidth*0.25-20, 30);
            
        } else {
            
            return CGSizeMake(kScreenWidth*0.25-10, 30);
            
        }
        
    }
    
    return CGSizeMake(50,50);
}


//12-17
#pragma mark -遮掩
- (void)blackBttonClickedWriteVC
{
    if (_collectionArray.count <3) {
        
        //遮掩背景
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
        
        _backView.backgroundColor = [UIColor blackColor];
        
        _backView.alpha = 0.5f;
        
        [self.view addSubview:_backView];
        
        
        //白色底图
        _showView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height/2-100, self.view.frame.size.width-40, 200)];
        
        _showView.backgroundColor=  [UIColor whiteColor];
        _showView.layer.cornerRadius = 5;
        [self.view addSubview:_showView];
        
        
        //头
        //12-17
        UILabel *xuanzeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _showView.frame.size.width-10, _showView.frame.size.height/4-2)];
        
        xuanzeLabel.text= @"选择照片";
        
        xuanzeLabel.textColor = [UIColor meiHongSe];
        xuanzeLabel.textAlignment = 1;
        [_showView addSubview:xuanzeLabel];
        
        
        
        UIView *lineView1 =[[UIView alloc]initWithFrame:CGRectMake(10, xuanzeLabel.frame.size.height, _showView.frame.size.width-20, 2)];
        
        lineView1.backgroundColor= [UIColor backgroundColor];
        
        [_showView addSubview:lineView1];
        
        
        
        UIButton *paiButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        paiButton.frame= CGRectMake(10, _showView.frame.size.height/4, _showView.frame.size.width-20, _showView.frame.size.height/4-2);
        
        [paiButton setTitle:@"拍照" forState:(UIControlStateNormal)];
        
        [paiButton addTarget:self action:@selector(cameraButtonClickedWriteVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview: paiButton];
        
        
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, _showView.frame.size.height/2-2, _showView.frame.size.width-20, 1)];
        
        lineView2.backgroundColor = [UIColor backgroundColor];
        
        [_showView addSubview:lineView2];
        
        
        
        UIButton *xiangceButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        xiangceButton.frame = CGRectMake(10, _showView.frame.size.height/2, _showView.frame.size.width-20, _showView.frame.size.height/4);
        
        [xiangceButton setTitle:@"相册" forState:(UIControlStateNormal)];
        
        [xiangceButton addTarget:self action:@selector(pickImageFromAlbumWriteVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview:xiangceButton];
        
        
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(10, _showView.frame.size.height/4*3, _showView.frame.size.width-20, 1)];
        
        lineView3.backgroundColor = [UIColor backgroundColor];
        
        [_showView addSubview:lineView3];
        
        
        
        UIButton *cancelbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        cancelbutton.frame = CGRectMake(10   , _showView.frame.size.height/4*3-1, _showView.frame.size.width-20, _showView.frame.size.height/4-1);
        
        [cancelbutton setTitle:@"取消" forState:(UIControlStateNormal)];
        
        [cancelbutton addTarget:self action:@selector(dismissViewWriteVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview:cancelbutton];
        
    }
    else
    {
        //12-22
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"最多上传三张图片" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *enalbleAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        
        [alertController addAction:enalbleAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

#pragma mark - 相机
-(void)cameraButtonClickedWriteVC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备未安装摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *enalbleAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        
        [alertController addAction:enalbleAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)pickImageFromAlbumWriteVC
{
    
    //10-27
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];//WithRootViewController:nil];
  
    //返回选中的原图
    [picker setDidFinishSelectImages:^(NSArray *images) {
        //      @"原图%@",images);
        _linshiPhotoArray = _collectionArray;
        
        NSArray *arr = [[NSArray alloc]init];
        
        for (UIImage *image in images) {
            
            //存到本地,存为nsdata类型
            [self saveImage:image withName:@"avatar.png"];
            
            NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
            
            NSData *data = [[NSData alloc] initWithContentsOfFile:fullPath];
            
            
            [_linshiPhotoArray addObject:data];
        }
        
        if (_linshiPhotoArray.count >3) {
            
            arr = [_linshiPhotoArray subarrayWithRange:NSMakeRange(0, 3)];
            [_collectionArray removeAllObjects];
            for (NSData *data in arr) {
                [_collectionArray addObject:data];
            }
        }
        
        else
        {
            _collectionArray = _linshiPhotoArray;
        }
        
        
        [_photoCollectionView reloadData];
        
        [self dismissViewWriteVC];

    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
}
//10-22
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //12-02
    //设置image的尺寸
    
//    CGSize imagesize = image.size;
    
//    imagesize.height = 157;
//    
//    imagesize.width = 157;
    
    //对图片大小进行压缩--
    
//    image = [self imageWithImage:image scaledToSize:imagesize];
    
    [self saveImage:image withName:@"avatar.png"];
    
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    
    //12-02
    
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:fullPath];
    
    //    UIImage *savedImage = [[UIImage alloc]initWithContentsOfFile:fullPath];
    //    [_photoButton setBackgroundImage:savedImage forState:(UIControlStateNormal)];
    
    //    [_collectionArray addObject:data];
    
    [self dismissViewWriteVC];
    
    if (_collectionArray.count <3) {
        
        if (_pathRow == _collectionArray.count) {
            
            [_collectionArray addObject:data];
            
            [_photoCollectionView reloadData];
            
        }
    }
}
//12-02
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//10-21
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        _alabel.text = @"请输入帖子内容";
    }
    else
    {
        _alabel.text = @"";
    }
    
    //10-23
    _contetSTring = textView.text;
}

static NSString *uuidKey = @"ModelCenter uuid key";
+(NSString*)uuid
{
    NSString *string = [UICKeyChainStore stringForKey:uuidKey];
    if (string) {
        
    }else{
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSUUID* identifierForVendor = currentDevice.identifierForVendor;
        string = [identifierForVendor UUIDString];
        [UICKeyChainStore setString:string forKey:uuidKey];
    }
    
    return string;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag ==101) {
        _titleString = textField.text;
    }
    else
        if (textField.tag ==102) {
            _hospitleString = _hospitleTextField.text;
        }
}

#pragma mark - 回收键盘
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *done =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(writeVCReplay)];
    
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)leaveEditMode {
    [_textView resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

- (void)dismissViewWriteVC
{
    [_showView removeFromSuperview];
    [_backView removeFromSuperview];
}
//11-05
//12-02
#pragma mark - 解析上传
- (void)writeVCReplay
{
    //12-21活动指示器
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"上传中...";
    
    //10-23
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DDQHeaderSingleModel *groupHeader_single = [DDQHeaderSingleModel singleModelByValue];
        
        //标签
        _writeString = [[NSMutableString alloc]init];
        NSString *string = [[NSString alloc]init];
        if (_tagDic.count!=0) {
            for (NSString *key in _tagDic) {
                [_writeString appendString:[NSString stringWithFormat:@"%@,",[_tagDic objectForKey:key]]];
                
            }
            string = [_writeString substringToIndex:_writeString.length-1];
            if ([_titleString length] ==0 )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整标题"preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [userNameAlert addAction:actionOne];
                    [self presentViewController:userNameAlert animated:YES completion:nil];
                });
            }
            else
                if ([_moneyString length] == 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.hud hide:YES];
                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择花费"preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [userNameAlert addAction:actionOne];
                        [self presentViewController:userNameAlert animated:YES completion:nil];
                    });
                    
                }
                else
                    if ([_contetSTring length] == 0)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.hud hide:YES];
                            
                            UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整内容"preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                            [userNameAlert addAction:actionOne];
                            [self presentViewController:userNameAlert animated:YES completion:nil];
                            
                        });
                    }
                    else
                        if ([DDQPublic isBlankString:string])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.hud hide:YES];
                                UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择标签"preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                [userNameAlert addAction:actionOne];
                                [self presentViewController:userNameAlert animated:YES completion:nil];
                            });
                        }
                        else
                        {
                            
                            
                            NSString *spellString = [SpellParameters getBasePostString];
                            //医院
                            NSData *data1 = [_hospitleString dataUsingEncoding:NSUTF8StringEncoding];
                            Byte *byteArray1 = (Byte *)[data1 bytes];
                            NSMutableString *hospitleString = [[NSMutableString alloc] init];
                            
                            for(int i=0;i<[data1 length];i++) {
                                [hospitleString appendFormat:@"%d#",byteArray1[i]];
                            }
                            //标题
                            NSData *data2 = [_titleString dataUsingEncoding:NSUTF8StringEncoding];
                            Byte *byteArray2 = (Byte *)[data2 bytes];
                            NSMutableString *titleString = [[NSMutableString alloc] init];
                            
                            for(int i=0;i<[data2 length];i++) {
                                [titleString appendFormat:@"%d#",byteArray2[i]];
                            }
                            //内容
                            NSData *data4 = [_contetSTring dataUsingEncoding:NSUTF8StringEncoding];
                            Byte *byteArray4 = (Byte *)[data4 bytes];
                            NSMutableString *contetSTring = [[NSMutableString alloc] init];
                            
                            for(int i=0;i<[data4 length];i++) {
                                [contetSTring appendFormat:@"%d#",byteArray4[i]];
                            }
                            
                            
                            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc]init];
                            
                            NSString *post_String = [postEncryption stringWithPost:[NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],groupHeader_single.groupId,string,titleString,contetSTring,hospitleString,_moneyString]];
                            
                            
                            //拼接字符串
                            NSString *BOUNDRY = [DDQWriteDiaryViewController uuid];
                            NSString *PREFIX = @"--";
                            NSString *LINEND = @"\r\n";
                            NSString *MULTIPART_FROM_DATA = @"multipart/form-data";
                            NSString *CHARSET = @"UTF-8";
                            
                            //图片
                            int len=512;
                            if (_collectionArray !=nil) {
                                for (int i =0; i<_collectionArray.count; i++) {
                                    NSData *imageData = [_collectionArray objectAtIndex:i];
                                    //字节大小
                                    if(imageData !=nil){
                                        len = (int)imageData.length + len;
                                    }
                                }
                            }
                            
                            //文本类型
                            NSMutableData  * postData =[NSMutableData dataWithCapacity:len];
                            
                            //p0
                            NSArray *postArray = [post_String componentsSeparatedByString:@"&"];
                            
                            NSMutableString *text = [[NSMutableString alloc]init];
                            for (int i = 0; i<postArray.count; i++) {
                                [text appendString:[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND]];
                                
                                NSString *key = [postArray objectAtIndex:i];
                                
                                NSArray * smallArray = [key componentsSeparatedByString:@"="];
                                
                                [text appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@",[smallArray objectAtIndex:0],LINEND];
                                
                                [text appendFormat:@"Content-Type: text/plain; charset=UTF-8%@",LINEND];
                                [text appendString:LINEND];
                                
                                NSString *str =[[smallArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                [text appendFormat:@"%@",str];
                                
                                [text appendString:LINEND];
                            }
                            [postData appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
                            
                            //文件数据
                            
                            if (_collectionArray.count != 0)
                            {
                                
                                for (int i =0 ; i<_collectionArray.count; i++)
                                {
                                    NSData *imagedata =  _collectionArray[i];
                                    [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
                                    
                                    NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"avatar.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img%d",i],LINEND,LINEND,LINEND];
                                    
                                    [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
                                    
                                    [postData  appendData:imagedata];
                                    [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
                                    
                                }
                            }
                            [postData appendData:[[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,PREFIX] dataUsingEncoding:NSUTF8StringEncoding]];
                            
                            //网络请求
                            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRiji_add]];
                            
                            [urlRequest setTimeoutInterval:20];
                            [urlRequest setHTTPMethod:@"POST"];
                            [urlRequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
                            [urlRequest setValue:CHARSET forHTTPHeaderField:@"Charsert"];
                            [urlRequest setValue:[NSString stringWithFormat:@"%@;boundary=%@", MULTIPART_FROM_DATA,BOUNDRY] forHTTPHeaderField:@"Content-Type"];
                            
                            urlRequest.HTTPBody = postData;
                            
                            NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
                            
                            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
                            
                            //10-29
                            //11-2
                            switch ([[dic objectForKey:@"errorcode"]intValue]) {
                                case 0:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                    });
                                    
                                    break;
                                }
                                case 15:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"文章内容为空,请重新填写"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                        
                                        
                                    });
                                    break;
                                }
                                case 14:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"文章标题格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                        
                                        
                                    });
                                    
                                    break;
                                }
                                case 16:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"医院名称格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                        
                                        
                                    });
                                    break;
                                }
                                case 19:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"医院名称格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            
                                            DDQLoginViewController *login = [[DDQLoginViewController alloc]init];
                                            
                                            [UIApplication sharedApplication].keyWindow.rootViewController =login;
                                        }];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                        
                                        
                                    });
                                    break;
                                }
                                default:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hide:YES];
                                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器繁忙,请稍后重试"preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                        [userNameAlert addAction:actionOne];
                                        [self presentViewController:userNameAlert animated:YES completion:nil];
                                    });
                                    break;
                                }
                            }
                        }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择标签"preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [userNameAlert addAction:actionOne];
                [self presentViewController:userNameAlert animated:YES completion:nil];
                
            });
        }
    });
    
}
@end