//
//  DDQPostingViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//
//12-02
#import "DDQPostingViewController.h"

#import "DDQWriteDiaryViewController.h"

#import "DDQPostingCollectionViewCell.h"
#import "DDQHeaderSingleModel.h"
#import "DDQTagModel.h"
#import "DDQGroupCollectionViewCell.h"

//图片多选
#import "SGImagePickerController.h"

#import "UICKeyChainStore.h"

#import "DDQLoginViewController.h"

#import "ProjectNetWork.h"

@interface DDQPostingViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UISegmentedControl *segmentedControl;

//@property (strong,nonatomic) DDQNewPostViewController *newPostViewController;
//@property (strong,nonatomic) DDQWriteDiaryViewController *writeDiaryViewController;

//12-21活动指示器
@property (nonatomic ,strong)MBProgressHUD *hud;

@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)UITextField *hospitleTextField;
@property (nonatomic ,strong)UITextField *titleTextField;

@property (nonatomic ,strong)UIView *backView;//遮掩
@property (nonatomic ,strong)UIView *showView;

@property (nonatomic ,strong)UIButton *typeButton;//标签

@property (nonatomic ,strong)UIView *aView;

@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,strong)UIButton *photoButton;//添加照片

@property (nonatomic ,strong)NSMutableArray *imageArray;

@property (nonatomic ,strong)UILabel *alabel;

//10-22
@property (nonatomic ,strong)UIScrollView *photoScrollview;//zhaopian

@property (nonatomic ,strong)UICollectionView *photoCollectionView;

@property (nonatomic ,strong)NSMutableArray *collectionArray;//存放数组

@property (nonatomic ,strong)NSMutableArray *linshiPhotoArray;//临时存放保存的图片

@property (nonatomic ,assign)NSInteger pathRow;


@property (nonatomic ,strong)NSString *titleString;//标题
@property (nonatomic ,strong)NSString *contetSTring;//内容

@property (nonatomic ,strong)UIView *tagView;//标签
//11-05
@property (nonatomic ,strong)NSMutableDictionary *tagDic;//选中的标签
//11-06
@property (nonatomic ,assign)BOOL ispopWrite;
/** 网络请求 */
@property (nonatomic, strong) ProjectNetWork *netWork;
@end

@implementation DDQPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"上传中...";
    
    self.netWork = [ProjectNetWork sharedWork];
    
}

-(NSMutableArray *)PstringTagArray
{
    if (!_PstringTagArray) {
        _PstringTagArray = [[NSMutableArray alloc]init];
    }
    return _PstringTagArray;
}

- (NSMutableArray *)linshiPhotoArray
{
    if (!_linshiPhotoArray) {
        _linshiPhotoArray  = [[NSMutableArray alloc]init];
    }
    return  _linshiPhotoArray;
}

#pragma mark - navigationBar
-(void)setNavigationBar {
    NSArray *array = @[@"发新帖",@"写日记"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(postingdidda:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(postingPopBackViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //10-22
    _collectionArray = [[NSMutableArray alloc]init];
    _tagDic = [[NSMutableDictionary alloc]init];
    [self superAView];
}

#pragma - mark 选中的视图
- (void)postingdidda:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    _index = index;
    if (index == 0) {
        
        [_aView removeFromSuperview];
        
        [self superAView];
        
        _aView.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight - 64);
    }
    if(index == 1)
    {
        [_aView removeFromSuperview];
        [self superAView];
    }
}

- (void)superAView
{
    _aView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - 64)];
    
    _aView.backgroundColor = [UIColor backgroundColor];
    
    [self.view addSubview:_aView];
    
    [self creatView];
}

- (void)creatView
{
    if (_index ==0) {
        UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(postingVCReplay)];
        
        self.navigationItem.rightBarButtonItem = bar;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (_index ==0) {
        //11-06
        _collectionArray  = [[NSMutableArray alloc]init];
        
        //输入
        UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0  ,  0, self.view.frame.size.width, self.view.frame.size.height/2-64+30)];
        blackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:blackView];
        
        
        _titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, blackView.frame.size.width-10, 29)];
        
        //10-21
        _titleTextField.delegate = self;
        
        _titleTextField.placeholder  = @"请输入帖子标题";
        
        [blackView addSubview:_titleTextField];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29, blackView.frame.size.width, 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        [blackView addSubview:lineView1];
        
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 30, blackView.frame.size.width, blackView.frame.size.height-80)];
        
        _textView.font = [UIFont systemFontOfSize:14];
        
        _textView.delegate = self;
        
        [blackView addSubview:_textView];
        
        
        _alabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, blackView.frame.size.width-10, 30)];
        
        _alabel.text = @"请输入帖子内容";
        
        _alabel.font = [UIFont systemFontOfSize:14];
        
        _alabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255  blue:147.0/255  alpha:0.4f];
        
        _alabel.enabled = NO;
        
        _alabel.backgroundColor = [UIColor clearColor];
        
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
        
        _photoCollectionView.backgroundColor = [UIColor colorWithRed:147.0/255 green:147.0/255  blue:147.0/255  alpha:0.4f];
        
        //11-05
        _photoCollectionView.tag =101;
        _photoCollectionView.delegate =self;
        
        _photoCollectionView.dataSource = self;
        
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_photoCollectionView registerClass:[DDQPostingCollectionViewCell class] forCellWithReuseIdentifier:@"collcell"];
        
        [_photoScrollview addSubview: _photoCollectionView];
        
        
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
        [photoButton1 addTarget:self action:@selector(blackBttonClickedPostingVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [tubiaoView addSubview:photoButton1];
        
        
        
        _typeButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _typeButton.frame = CGRectMake(tubiaoView.frame.size.height+tubiaoView.frame.size.height*0.1 +5 ,tubiaoView.frame.size.height*0.1, photoButton1.frame.size.height, photoButton1.frame.size.height);
        
        [tubiaoView addSubview:_typeButton];
        
        [_typeButton setBackgroundImage:[UIImage imageNamed:@"btn_insert_tag_nor"] forState:(UIControlStateNormal)];
        [_typeButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_typeButton addTarget:self action:@selector(typeButtonPostingClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0 ,tubiaoView.frame.origin.y +tubiaoView.frame.size.height+1 ,  footView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor backgroundColor];
        
        [footView addSubview:lineView];
    }
    else
        if (_index ==1) {
            //11-06
            _collectionArray  = [[NSMutableArray alloc]init];
            
            UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
            
            blackView.backgroundColor =[UIColor whiteColor];
            
            [self.view addSubview:blackView];
            
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
            
            imageView.image = [UIImage imageNamed:@"topic_upload_pic"];
            
            [blackView addSubview:imageView];
            
            
            
            UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x +imageView.frame.size.width +10, 0,  blackView.frame.size.width -(imageView.frame.origin.x +imageView.frame.size.width +10), blackView.frame.size.height)];
            
            label.text = @"发布新日记";
            
            [blackView addSubview:label];
            
            
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            
            [button addTarget:self action:@selector(writeButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
            
            button.frame = blackView.bounds;
            
            [blackView addSubview:button];
        }
}

//选择标签
- (void)typeButtonPostingClicked:(UIButton *)btn
{
    if (btn.isSelected == NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_insert_tag_sel"] forState:UIControlStateNormal];
        _tagView = [[UIView alloc]initWithFrame:CGRectMake(0,(self.view.frame.size.height/2-64+30)+40 +40 , self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.height/2-64+30)+40)];
        
        [self.view  addSubview:_tagView];
        
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        
        UICollectionView * tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,_tagView.frame.size.width, _tagView.frame.size.height)  collectionViewLayout:flowlayout];
        
        tagCollectionView.delegate =self;
        
        tagCollectionView.dataSource = self;
        
        tagCollectionView.tag = 103;
        
        tagCollectionView.backgroundColor = [UIColor whiteColor];
        
        [tagCollectionView registerClass:[DDQGroupCollectionViewCell class] forCellWithReuseIdentifier:@"groupcollcell"];
        
        [_tagView addSubview: tagCollectionView];
        
        [btn setSelected:YES];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_insert_tag_nor"] forState:UIControlStateNormal];
        
        [_tagView removeFromSuperview];
        [btn setSelected:NO];
    }
}

//10-22
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 103) {
        
        return _PstringTagArray.count;
        
    }
    else
        if (collectionView.tag ==101) {
            _photoScrollview.contentSize = CGSizeMake(_collectionArray.count *60+70, 50);
            _photoCollectionView.frame = CGRectMake(0, 0, _collectionArray.count *60+70, 50);
            
            if (_collectionArray.count<4) {
                if (_collectionArray.count ==0) {
                    return 1;
                }
                else {
                    
                    return  _collectionArray.count+1;
                }
            }
        }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 103) {
        
        DDQGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupcollcell" forIndexPath:indexPath];
        DDQTagModel *model = self.PstringTagArray[indexPath.row];
        cell.title.text = model.name;
        
        //11-06
        cell.layer.borderColor=[UIColor colorWithRed:227.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f].CGColor;
        
        cell.layer.cornerRadius = 5;
        
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
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger weizhi = indexPath.row;
    if (collectionView.tag == 103)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        DDQTagModel *model = self.PstringTagArray[indexPath.row];
        NSString * tag = model.iD ;
        
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
            cell.layer.borderColor=[UIColor backgroundColor].CGColor;
            cell.layer.borderWidth=1;
        }
        
    }
    else
        if (collectionView.tag ==101)
        {
            if (indexPath.row <3)
            {
                if (indexPath.row == _collectionArray.count)
                {
                    
                    [self blackBttonClickedPostingVC];
                }else
                {
                    
                    [_collectionArray removeObjectAtIndex:indexPath.row];
                    [_photoCollectionView reloadData];
                }
            }
            else
                if (indexPath.row ==3)
                {
                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多上传三张图片"preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [userNameAlert addAction:actionOne];
                    [self presentViewController:userNameAlert animated:YES completion:nil];
                    
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

//写日记页面
-(void)writeButtonClick
{
    [self blackBttonClickedPostingVC];
    
    _ispopWrite = YES;
}

//11-05
//12-02
#pragma  mark 发布
- (void)postingVCReplay {
    
    NSString *shangchuanString = [[NSString alloc]init];
    
    NSMutableString *linshiString = [[NSMutableString alloc]init];
    
    DDQHeaderSingleModel *groupHeader_single = [DDQHeaderSingleModel singleModelByValue];

    if (_tagDic.count > 0) {//判断他有没有选标签
        
        for (NSString *key in _tagDic) {
            
            [linshiString appendString:[NSString stringWithFormat:@"%@,",[_tagDic objectForKey:key]]];
            
        }
        shangchuanString = [linshiString substringToIndex:linshiString.length-1];
        
        if ([_titleString length] ==0) {//判断他是否写过标题
            
            [self.hud hide:YES];
            
            UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整标题"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [userNameAlert addAction:actionOne];
            [self presentViewController:userNameAlert animated:YES completion:nil];
            
        } else if ([_contetSTring length] == 0){//判断他是否写过内容
    
            UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整内容"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [userNameAlert addAction:actionOne];
            [self presentViewController:userNameAlert animated:YES completion:nil];
                
        } else if ([DDQPublic isBlankString:shangchuanString]) {//选择的标签内容不为nill，null或空
            
            UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择标签"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [userNameAlert addAction:actionOne];
            [self presentViewController:userNameAlert animated:YES completion:nil];
            
        } else {
            
            [self.hud show:YES];
            
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
            
            [self.netWork asyPOST_url:kTiezi_add Photo:_collectionArray Data:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], groupHeader_single.groupId, shangchuanString, titleString, contetSTring] TagArray:nil Success:^(id objc) {
                
                if (objc) {
                    
                    [self.hud hide:YES];
                    
                    int code = [[objc valueForKey:@"errorcode"] intValue];
                    if (code == 0) {
                        
                        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [userNameAlert addAction:actionOne];
                        [self presentViewController:userNameAlert animated:YES completion:nil];

                    } else {
                        
                        [self.hud hide:YES];

                        if (code == 14 || code == 15 || code == 16 || code == 19) {
                            
                            switch (code) {
                                    
                                case 14:{
                                    
                                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"文章标题格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [userNameAlert addAction:actionOne];
                                    [self presentViewController:userNameAlert animated:YES completion:nil];
                                    
                                }break;
                        
                                case 15:{
                                
                                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"文章内容为空,请重新填写"preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [userNameAlert addAction:actionOne];
                                    [self presentViewController:userNameAlert animated:YES completion:nil];
                
                                }break;
                                    
                                case 16:{
                                
                                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"医院名称格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [userNameAlert addAction:actionOne];
                                    [self presentViewController:userNameAlert animated:YES completion:nil];
                                    
                                }break;
                                    
                                case 19:{
                                
                                    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"医院名称格式不符合要求"preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        DDQLoginViewController *login = [[DDQLoginViewController alloc]init];
                                        
                                        [UIApplication sharedApplication].keyWindow.rootViewController =login;
                                    }];
                                    [userNameAlert addAction:actionOne];
                                    [self presentViewController:userNameAlert animated:YES completion:nil];
                                    
                                }break;
                                    
                                default:
                                    break;
                                    
                            }
                            
                        } else {
                        
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                            
                        }
                        
                    }
                    
                } else {
                
                    [self.hud hide:YES];
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

                }
                
            } andFailure:^(NSError *error) {
                
                [self.hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }];
            
        }

    } else {
        
        UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择标签"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [userNameAlert addAction:actionOne];
        [self presentViewController:userNameAlert animated:YES completion:nil];
        
    }
    
}

//12-17
#pragma mark -遮掩
- (void)blackBttonClickedPostingVC
{
    if (_collectionArray.count <3) {
        
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
        
        _backView.backgroundColor = [UIColor blackColor];
        
        _backView.alpha = 0.5f;
        
        [self.view addSubview:_backView];
        
        
        
        _showView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height/2-100, self.view.frame.size.width-40, 200)];
        
        _showView.backgroundColor=  [UIColor whiteColor];
        _showView.layer.cornerRadius =5;
        [self.view addSubview:_showView];
        
        
        //12-17
        UILabel *xuanzeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _showView.frame.size.width-10, _showView.frame.size.height/4-2)];
        
        xuanzeLabel.text= @"选择照片";
        
        xuanzeLabel.textColor = [UIColor meiHongSe];
        xuanzeLabel.textAlignment = 1 ;
        [_showView addSubview:xuanzeLabel];
        
        
        
        UIView *lineView1 =[[UIView alloc]initWithFrame:CGRectMake(10, xuanzeLabel.frame.size.height, _showView.frame.size.width-20, 2)];
        
        lineView1.backgroundColor= [UIColor backgroundColor];
        
        [_showView addSubview:lineView1];
        
        
        
        UIButton *paiButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        paiButton.frame= CGRectMake(10, _showView.frame.size.height/4, _showView.frame.size.width-20, _showView.frame.size.height/4-2);
        
        [paiButton setTitle:@"拍照" forState:(UIControlStateNormal)];
        
        [paiButton addTarget:self action:@selector(cameraButtonClickedPostingVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview: paiButton];
        
        
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, _showView.frame.size.height/2-2, _showView.frame.size.width-20, 1)];
        
        lineView2.backgroundColor = [UIColor backgroundColor];
        
        [_showView addSubview:lineView2];
        
        
        
        UIButton *xiangceButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        xiangceButton.frame = CGRectMake(0, _showView.frame.size.height/2, _showView.frame.size.width, _showView.frame.size.height/4);
        
        [xiangceButton setTitle:@"相册" forState:(UIControlStateNormal)];
        
        [xiangceButton addTarget:self action:@selector(pickImageFromAlbumPostingVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview:xiangceButton];
        
        
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(10, _showView.frame.size.height/4*3, _showView.frame.size.width-20, 1)];
        
        lineView3.backgroundColor = [UIColor backgroundColor];
        
        [_showView addSubview:lineView3];
        
        
        
        UIButton *cancelbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        cancelbutton.frame = CGRectMake(0   , _showView.frame.size.height/4*3-1, _showView.frame.size.width, _showView.frame.size.height/4-1);
        
        [cancelbutton setTitle:@"取消" forState:(UIControlStateNormal)];
        
        [cancelbutton addTarget:self action:@selector(dismissViewPostingVC) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_showView addSubview:cancelbutton];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:@"最多上传三张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 相机
-(void)cameraButtonClickedPostingVC
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)pickImageFromAlbumPostingVC {
    
    //10-27
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];//WithRootViewController:nil];
    
    //返回选中的原图
    [picker setDidFinishSelectImages:^(NSArray *images) {
        //    "原图%@",images);
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
        
        [self dismissViewPostingVC];
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    //    NSData *imageData = UIImagePNGRepresentation(currentImage);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"avatar.png"];
    
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:fullPath];
    
    [self dismissViewPostingVC];
    
    if (_collectionArray.count <3) {
        
        if (_pathRow == _collectionArray.count) {
            
            [_collectionArray addObject:data];
            
            [_photoCollectionView reloadData];
            
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

//textfield编辑结束
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _titleString = textField.text;
}

//10-21回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
}
//11-06 跳回
- (void)dismissViewPostingVC
{
    [_showView removeFromSuperview];
    [_backView removeFromSuperview];
    //跳到哪?
    if (_ispopWrite) {
        
        DDQWriteDiaryViewController *writeVC = [DDQWriteDiaryViewController new];
        
        writeVC.collectionArray = _collectionArray;
        
        writeVC.writeDTagArray = _PstringTagArray;
        
        [self.navigationController pushViewController:writeVC animated:YES];
        _ispopWrite = NO;
        
    }
}

//textview内容改变时
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        _alabel.text = @"请输入帖子内容";
    }
    else
    {
        _alabel.text = @"";
    }
    _contetSTring = textView.text;
}

#pragma mark - textview回收键盘
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    UIBarButtonItem *done =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(postingVCReplay)];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)leaveEditMode {
    [_textView resignFirstResponder];
}

-(void)postingPopBackViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
