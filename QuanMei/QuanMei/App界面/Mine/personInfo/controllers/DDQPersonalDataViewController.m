//
//  DDQPersonalDataViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/2.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQPersonalDataViewController.h"
#import "DDQDataController.h"
#import "DDQCityViewController.h"
#import "DDQLevelViewController.h"

#import "DDQPersonHeadImageCell.h"
#import "DDQuserInfoCell.h"

#import "ZHPickView.h"
#import "SLValue Singleton.h"

#import "DDQMineInfoModel.h"

#import "PostData.h"
#import "SpellParameters.h"

#import "DDQLoginViewController.h"

#import "SGImagePickerController.h"
#import "QRCode.h"
#import "DDQSexSeletView.h"
#import "ProjectNetWork.h"

@interface DDQPersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ZHPickViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray * linshiPhotoArray;
    NSMutableArray * collectionArray;
}
@property (strong,nonatomic) UITableView *mainTableView;
@property (strong,nonatomic) NSArray *cellNameArray;

@property (nonatomic, strong) DDQMineInfoModel *mineInfoModel;

@property ( strong, nonatomic) MBProgressHUD *hud;
@end

typedef NS_ENUM(NSUInteger, kAlertViewType) {
    kAlertViewTypeNone,
    kAlertViewTypeNoLogin,
    kAlertViewTypeChangeNiceName,
    kAlertViewTypeSelectIcon
};

typedef NS_ENUM(NSUInteger, kButtonIndexType) {
    kButtonIndexTypeCancel,
    kButtonIndexTypeCamera,
    kButtonIndexTypePhoto
};

@implementation DDQPersonalDataViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mineInfoModel = [[DDQMineInfoModel alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.navigationItem.title = @"个人资料";
    _cellNameArray = [NSArray arrayWithObjects:@"昵称",@"年龄",@"地区",@"我的等级", nil];
    linshiPhotoArray = [[NSMutableArray alloc]init];
    
    collectionArray = [[NSMutableArray alloc]init];
    [self requestData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifiction) name:@"age" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCityNotification) name:@"city" object:nil];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)requestData {
    self.hud.detailsLabelText = @"请稍候...";
    [self.hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //调用点赞接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kMyCenterMain];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                NSDictionary *data = [DDQPOSTEncryption judgePOSTDic:post_dic];
                //给数据源赋值
                DDQMineInfoModel *model = [[DDQMineInfoModel alloc] init];
                model.age = [NSString stringWithFormat:@"%@",data[@"age"]];
                model.city = data[@"city"];
                model.level = [NSString stringWithFormat:@"%@",data[@"level"]];
                model.sex = data[@"sex"];
                model.star = [NSString stringWithFormat:@"%@",data[@"star"]];
                model.userimg = data[@"userimg"];
                model.userid = [NSString stringWithFormat:@"%@",data[@"userid"]];
                model.username = data[@"username"];
                self.mineInfoModel = model;
                [self.mainTableView reloadData];
            }else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });
}


-(void)initTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

#pragma mark - dataSource And Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 6;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView registerClass:[DDQPersonHeadImageCell class] forCellReuseIdentifier:NSStringFromClass([DDQPersonHeadImageCell class])];
        DDQPersonHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQPersonHeadImageCell class]) forIndexPath:indexPath];
        cell.mineInfoModel = self.mineInfoModel;
        return cell;
    }else {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DDQuserInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DDQuserInfoCell class])];
        DDQuserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DDQuserInfoCell class])];
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"昵称";
            cell.rightLabel.text = self.mineInfoModel.username;
        }else if (indexPath.row == 1) {
            cell.leftLabel.text = @"年龄";
            cell.rightLabel.text = self.mineInfoModel.age;
        }else if (indexPath.row == 2) {
            cell.leftLabel.text = @"地区";
            cell.rightLabel.text = self.mineInfoModel.city;
        }else if (indexPath.row == 3){
            cell.leftLabel.text = @"我的等级";
            cell.rightLabel.text = [NSString stringWithFormat:@"LV%@",self.mineInfoModel.level];
        } else {
            cell.leftLabel.text = @"性别";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.mineInfoModel.sex];
        }
    
        if (indexPath.row == 5) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"temp"];
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            }
            cell.textLabel.text = @"我的二维码";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.view.frame.size.height * 0.15;
        
    } else {
        return self.view.frame.size.height * 0.1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self userImgButtonClicked];
    }else if (indexPath.section == 1&&indexPath.row == 0) {
        [self alertController:@"修改昵称" placeholderString:@"修改昵称"];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        DDQDataController *dataVC = [[DDQDataController alloc] init];
        self.definesPresentationContext = YES;
        dataVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        dataVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:dataVC animated:YES completion:^{
            
        }];
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        DDQCityViewController *cityVC = [[DDQCityViewController alloc] init];
        self.definesPresentationContext = YES;
        cityVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        cityVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:cityVC animated:YES completion:^{
            self.mineInfoModel.city = [SLValue_Singleton shareInstance].pickCityStr;
            [self.mainTableView reloadData];
        }];
    } else if (indexPath.section == 1 && indexPath.row == 3){
        DDQLevelViewController *levelVC = [[DDQLevelViewController alloc] init];
        levelVC.model = self.mineInfoModel;
        [self.navigationController pushViewController:levelVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 4) {
    
//        UINib *nib = [UINib nibWithNibName:@"SexSelectView" bundle:nil];
//        NSArray *array = [nib instantiateWithOwner:self options:nil];
//        DDQSexSeletView *sex_view = array[0];
//        sex_view.frame = self.view.frame;
//        [self.view.window addSubview:sex_view];
//        [sex_view sex_manSelected:^(DDQSexSeletView *view) {
//            
//            [view removeFromSuperview];
//            DDQuserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.rightLabel.text = @"男";
//            
//        }];
//        
//        [sex_view sex_womanSelected:^(DDQSexSeletView *view) {
//            
//            [view removeFromSuperview];
//            DDQuserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.rightLabel.text = @"女";
//            
//        }];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"性别选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        DDQuserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ProjectNetWork *net = [ProjectNetWork sharedWork];
        
        UIAlertAction *actionO = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [net asy_netWithUrlString:kEdit_sexUrl ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"1"] Success:^(id source, NSError *analysis_error) {
                
                if (analysis_error) {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:[NSString stringWithFormat:@"errorcode为%ld",analysis_error.code] andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                } else {
                
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"修改成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    cell.rightLabel.text = @"男";

                }
                
            } Failure:^(NSError *net_error) {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }];

        }];
        
        UIAlertAction *actionT = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [net asy_netWithUrlString:kEdit_sexUrl ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"2"] Success:^(id source, NSError *analysis_error) {
                
                if (analysis_error) {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:[NSString stringWithFormat:@"errorcode为%ld",analysis_error.code] andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                } else {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"修改成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    cell.rightLabel.text = @"女";
                    
                }
                
            } Failure:^(NSError *net_error) {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }];

        }];
        
        [alertC addAction:actionO];
        [alertC addAction:actionT];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
    } else {
       
          QRCode *code = [[QRCode alloc] initWithQRCodeString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] width:kScreenWidth*0.6];
          UIImage *QRCode = code.QRCodeImage;
          
          UIView *QRView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
          [self.view.window addSubview:QRView];
          QRView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
          
          UIImageView *QRImg = [[UIImageView alloc] init];
          [QRView addSubview:QRImg];
          [QRImg mas_makeConstraints:^(MASConstraintMaker *make) {
              
              make.centerX.mas_equalTo(QRView.mas_centerX);
              make.centerY.mas_equalTo(QRView.mas_centerY);
              make.width.and.height.offset(kScreenWidth * 0.6);
              
          }];
          QRImg.userInteractionEnabled = YES;
          QRImg.image = QRCode;
          
          UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
          [QRView addGestureRecognizer:tap1];
          
          UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
          [QRView addGestureRecognizer:tap2];
            
    }
    
}

- (void)removeView:(UITapGestureRecognizer *)tap {
    
    if ([[tap view] isKindOfClass:[UIImageView class]]) {
        
        [[[tap view] superview] removeFromSuperview];
        
    } else {
        
        [[tap view] removeFromSuperview];
        
    }
    
}

#pragma mark - action
- (void)userImgButtonClicked
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改头像" message:@"拍照" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机" ,@"相册" , nil];
    alertView.tag = kAlertViewTypeSelectIcon;
    [alertView show];
}

#pragma mark - ohter method
-(void)alertController:(NSString *)message_title placeholderString:(NSString *)placeholder {
    UIAlertView *alert_view = [[UIAlertView alloc] initWithTitle:message_title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert_view.tag = kAlertViewTypeChangeNiceName;
    alert_view.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [alert_view textFieldAtIndex:0];
    field.placeholder = placeholder;
    [alert_view show];
}

//改变生日后通知执行的方法
- (void)handleNotifiction {
    NSString *data = [SLValue_Singleton shareInstance].pickTimeStr;
    NSString *birthday = [data substringWithRange:NSMakeRange(0, 10)];
    [self postToServiceWithString:birthday url:kEditBrithday];
}
//改变地点之后执行
- (void)handleCityNotification {
//    NSString *city = [SLValue_Singleton shareInstance].pickCityStr;
    
    NSString *provinceID = [SLValue_Singleton shareInstance].provinceID;
    NSString *cityID = [SLValue_Singleton shareInstance].cityID;
    [self postToServiceWithProvince:provinceID cityID:cityID url:kEditCity];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kAlertViewTypeChangeNiceName) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField *nickNameField = [alertView textFieldAtIndex:0];
            NSString *post_spellString = [SpellParameters getBasePostString];//八段字符串
            //将text的内容转换下格式
            NSData *data = [nickNameField.text dataUsingEncoding:NSUTF8StringEncoding];
            Byte *byteArray = (Byte *)[data bytes];
            NSMutableString *appendStr = [[NSMutableString alloc] init];
            for(int i=0;i<[data length];i++) {
                [appendStr appendFormat:@"%d#",byteArray[i]];
            }
            //向服务器post的字符串
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",post_spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],appendStr];
            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
            //加密
            NSString *post_encryption = [postEncryption stringWithPost:post_baseString];
            //服务器返回一个字典
            NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_encryption AndUrl:kEditNickName];
NSString *errorcode = [NSString stringWithFormat:@"%@",post_Dic[@"errorcode"]];
            if ([errorcode isEqualToString:@"0"]) {
                [self requestData];
            }else if ([errorcode isEqualToString:@"12"]) {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"昵称格式不符合要求" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }else if ([errorcode isEqualToString:@"13"]) {
                [self buildAlertView];
            }
        }
    }else if (alertView.tag == kAlertViewTypeNoLogin) {
        DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else if (alertView.tag ==kAlertViewTypeSelectIcon)
    {
        switch (buttonIndex) {
            case kButtonIndexTypeCancel:{
                
                break;
            }case kButtonIndexTypeCamera:{
                [self cameraButtonClickedPersonVC];
                
                break;
            }case kButtonIndexTypePhoto:{
                
                [self pickImageFromAlbumPersonVC];
                break;
            }
            default:
                break;
        }
    }
}
//提示登陆alertView
- (void)buildAlertView {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户未登录，请前去登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    myAlertView.tag = kAlertViewTypeNoLogin;
[myAlertView show];
}

//将一段字符串上传给服务器
- (void)postToServiceWithString:(NSString *)userInfo url:(NSString *)url{
    NSString *post_spellString = [SpellParameters getBasePostString];//八段字符串
    //将text的内容转换下格式
    NSData *data = [userInfo dataUsingEncoding:NSUTF8StringEncoding];
    Byte *byteArray = (Byte *)[data bytes];
    NSMutableString *appendStr = [[NSMutableString alloc] init];
    for(int i=0;i<[data length];i++) {
        [appendStr appendFormat:@"%d#",byteArray[i]];
    }

    NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",post_spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],appendStr];
    if ([url isEqualToString:kEditBrithday]) {
        post_baseString = [NSString stringWithFormat:@"%@*%@*%@",post_spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],userInfo];
    }
    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
    //加密
    NSString *post_encryption = [postEncryption stringWithPost:post_baseString];
    //服务器返回一个字典
    NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_encryption AndUrl:url];
    NSString *errorcode = [NSString stringWithFormat:@"%@",post_Dic[@"errorcode"]];
    if ([url isEqualToString:kEditBrithday]) {
        if ([errorcode isEqualToString:@"0"]) {
            [self requestData];
        }else if ([errorcode isEqualToString:@"12"]) {
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"生日格式不符合要求" andShowDim:NO andSetDelay:YES andCustomView:nil];
        }else if ([errorcode isEqualToString:@"13"]) {
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"生日时间大于或等于服务器当前时间" andShowDim:NO andSetDelay:YES andCustomView:nil];
        }else if ([errorcode isEqualToString:@"14"]) {
            [self buildAlertView];
        }
    }else if ([url isEqualToString:kEditCity]) {
        
    }else if ([url isEqualToString:kEditIcon]) {
        
    }
}
//将 地点 上传服务器
- (void)postToServiceWithProvince:(NSString *)provinceID cityID:(NSString *)cityID url:(NSString*)url {
//    NSMutableString *appendProvinceID = [[NSMutableString alloc] init];
//    NSMutableString *appendCityID = [[NSMutableString alloc] init];
//    [appendProvinceID stringByAppendingString:provinceID];
//    [appendCityID stringByAppendingString:cityID];
    NSString *post_spellString = [SpellParameters getBasePostString];//八段字符串
    NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",post_spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],provinceID,cityID];
    NSString *post_encryption = [self postEncryptionWithPostString:post_baseString];
//    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
//    //加密
//    NSString *post_encryption = [postEncryption stringWithPost:post_baseString];
    //服务器返回一个字典
    NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_encryption AndUrl:url];

    NSString *errorcode = [NSString stringWithFormat:@"%@",post_Dic[@"errorcode"]];
        if ([errorcode isEqualToString:@"0"]) {
            [self requestData];
        }else if ([errorcode isEqualToString:@"14"]) {
            [self buildAlertView];
        }else {
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
}
//字符串转换格式（需要转换时）
- (NSMutableString *)stringChangeDataWithString:(NSString *)string {
    //将text的内容转换下格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *byteArray = (Byte *)[data bytes];
    NSMutableString *appendStr = [[NSMutableString alloc] init];
    for(int i=0;i<[data length];i++) {
        [appendStr appendFormat:@"%d#",byteArray[i]];
    }
    return appendStr;
}
//加密
- (NSString *)postEncryptionWithPostString:(NSString *)postString {
    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
    NSString *post_encryption = [postEncryption stringWithPost:postString];
    return post_encryption;
}

#pragma  mark -相机
-(void)cameraButtonClickedPersonVC
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"取消!" otherButtonTitles:nil];
        [alert show];
    }
    

}
//进相册
- (void)pickImageFromAlbumPersonVC
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//存到本地
- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];

}

//点击完成执行方法,储存图片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //12-02
    //设置image的尺寸
    
    CGSize imagesize = image.size;
    
    imagesize.height =157;
    
    imagesize.width =157;
    
    //对图片大小进行压缩--
    
    image = [self imageWithImage:image scaledToSize:imagesize];
    
    [self saveImage:image withName:@"icon.png"];
    
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"icon.png"];
   //12-02
    
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:fullPath];
    
    collectionArray = [[NSMutableArray alloc]init];
    
    [collectionArray addObject:data];
    
    [self asyncPhotoListForPerson];

    DDQPersonHeadImageCell *cell = (DDQPersonHeadImageCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.headView.image = image;
    
    //    UIImage *savedImage = [[UIImage alloc]initWithContentsOfFile:fullPath];
    //    [_photoButton setBackgroundImage:savedImage forState:(UIControlStateNormal)];
    
    //    [_collectionArray addObject:data];
    
    
}
//12-02
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    // Return the new image.
    
    return newImage;
}
//移除相册页面
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//上传服务器
- (void)asyncPhotoListForPerson
{
    [self.hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //调用touxiang接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc]init];
        
        NSString *post_String = [postEncryption stringWithPost:post_baseString];

        //拼接字符串
        NSString *BOUNDRY = [DDQPersonalDataViewController uuid];
        NSString *PREFIX = @"--";
        NSString *LINEND = @"\r\n";
        NSString *MULTIPART_FROM_DATA = @"multipart/form-data";
        NSString *CHARSET = @"UTF-8";
        
        //图片
        int len=512;
        if (collectionArray !=nil) {
            for (int i =0; i<collectionArray.count; i++) {
                NSData *imageData = [collectionArray objectAtIndex:i];
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
        
        if (collectionArray.count != 0)
        {
            
            for (int i =0 ; i<collectionArray.count; i++)
            {
                NSData *imagedata =  collectionArray[i];
                [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"icon.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img%d",i],LINEND,LINEND,LINEND];
                
                [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postData  appendData:imagedata];
                [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }
        [postData appendData:[[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,PREFIX] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //网络请求
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kEditIcon]];
        
        [urlRequest setTimeoutInterval:5000];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
        [urlRequest setValue:CHARSET forHTTPHeaderField:@"Charsert"];
        [urlRequest setValue:[NSString stringWithFormat:@"%@;boundary=%@", MULTIPART_FROM_DATA,BOUNDRY] forHTTPHeaderField:@"Content-Type"];
        
        urlRequest.HTTPBody = postData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                [self.hud hide:YES];
                if (!connectionError) {
                    
                    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([dic[@"errorcode"] intValue] == 0) {
                        self.hud.detailsLabelText = @"头像上传成功";
                        [self.hud show:YES];
                        [self.hud hide:YES afterDelay:1.0f];
                    } else {
                    
                        UIAlertController *aletC = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器繁忙" preferredStyle:UIAlertControllerStyleAlert];
                        [self presentViewController:aletC animated:YES completion:nil];
                    }

                } else {
                    
                    UIAlertController *aletC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络异常" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:aletC animated:YES completion:nil];
                }
                
            }];
        });
    });
}
//获取设备的UDID，唯一标识符给服务器
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
@end
