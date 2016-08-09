

//
//  DDQMineViewController.m
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMineViewController.h"

#import "DDQPersonalDataViewController.h"
#import "DDQOthersViewController.h"
#import "DDQMyDiaryViewController.h"
#import "DDQMyCommentViewController.h"
#import "DDQMyCollectViewController.h"
#import "DDQMyWalletViewController.h"
#import "DDQLoginViewController.h"
#import "DDQMyLessonViewController.h"
#import "DDQUserInfoModel.h"
#import "DDQMineInfoModel.h"
#import "DDQNewOrderListController.h"
#import "DDQBaseTabBarController.h"
#import "DDQMineTableViewCell.h"

#import "MJExtension.h"
#import "ProjectNetWork.h"

@interface DDQMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
/**
 *  个人资料界面实例
 */
@property (strong,nonatomic) DDQPersonalDataViewController *dataViewController;

/**
 *  我的主表视图
 */
@property (strong,nonatomic) UITableView *mainTabelView;
/**
 *  接下来都是头视图所需的控件
 */
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *userImageView;
@property (strong,nonatomic) UILabel *userName;
@property (strong,nonatomic) UIView *userMessage;
@property (strong,nonatomic) UILabel *userLV;

@property (strong,nonatomic) NSArray *cellTitleArray;
@property (strong,nonatomic) NSArray *cellImageArray;
/**
 *  正常登录后的model
 */
@property (strong,nonatomic) DDQUserInfoModel *infoModel;

@property (nonatomic, strong) DDQMineInfoModel *mineInfoModel;
//12-31背景图
@property (nonatomic,strong)NSData *imageData;
//活动指示器
@property (nonatomic ,strong)MBProgressHUD *hud;
/** 网络请求 */
@property (nonatomic, strong) ProjectNetWork *netWork;

@end


@implementation DDQMineViewController

//11-30-15
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
	[self requestDataOne];

	

}

//-(void)viewDidDisappear:(BOOL)animated {
//
//    [super viewDidDisappear:YES];
//    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];
//    infoModel.userimg = self.mineInfoModel.userimg;
//    infoModel.isLogin = YES;
//    
//}

//11-30-15
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.35)];
	
//	if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] == 0) {
//		
//		DDQLoginViewController *login = [[DDQLoginViewController alloc] init];
//		login.hidesBottomBarWhenPushed = YES;
//		
//		[self.navigationController pushViewController:login animated:YES];
//		
//	} else {
//		
//		[self requestDataOne];
//		
//	}
	
}

-(void)setNavigationBar {
    
    [self.navigationItem setTitle:@"我的"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"个人资料" style:UIBarButtonItemStyleDone target:self action:@selector(showPersonalDataController)];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    self.navigationController.navigationBar.tintColor           = [UIColor meiHongSe];
    self.navigationItem.rightBarButtonItem                      = rightItem;
    
}

-(void)layOutNavigationBar {
    
    NSString *str_userLevel = [NSString stringWithFormat:@"LV%@",self.mineInfoModel.level];
    CGSize level_size = [str_userLevel sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.5]}];
    UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, level_size.width, level_size.height)];
    
    levelImageView.image = [UIImage imageNamed:@"levelImg"];
    self.userLV = [[UILabel alloc] initWithFrame:levelImageView.frame];
    self.userLV.backgroundColor = [UIColor clearColor];
    [levelImageView addSubview:self.userLV];
    [self.userLV setText:str_userLevel];
    self.userLV.textColor = [UIColor whiteColor];
    _userLV.font = [UIFont systemFontOfSize:15.0f];
    _userLV.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:levelImageView];
    
    NSString *str = @"啊啊啊啊啊啊啊";
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.5]}];
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.backgroundImageView addSubview:self.userName];
    self.userName.textColor = [UIColor meiHongSe];
    [self.userName setText:self.mineInfoModel.username];
    _userName.font = [UIFont systemFontOfSize:15.0f];
    [self.userName setTextAlignment:NSTextAlignmentLeft];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:self.userName];

    self.navigationItem.leftBarButtonItems = @[item1,item2];
    
}
#pragma mark - navigationBar item target aciton
-(void)pushToLoginViewController {
    DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)pushToMineViewController {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minechange" object:nil userInfo:@{@"mine":@"mine"}];
    
}

#pragma mark - initTabelView
/** 退出 */
-(void)popMainViewController {
    
    [self requestData];
    
}

- (void)requestData {
    
    [self.hud show:YES];
	
    [self.netWork asyPOSTWithAFN_url:kGetOut_Url andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (!code_error) {
            
            [self.hud hide:YES];
            
            //首先移除掉保存的userid
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
            
            //然后改变model类的登陆属性
            DDQUserInfoModel *userInfo = [DDQUserInfoModel singleModelByValue];
            userInfo.isLogin = NO;
            
            //最后退回到首页
//            DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
			self.tabBarController.selectedIndex = 0;
			DDQBaseTabBarController *baseBarC = (DDQBaseTabBarController *)self.tabBarController;
			[baseBarC.tabBar addSubview:[baseBarC defaultMineView]];
			
        } else {
        
            [self.hud hide:YES];
            NSInteger code = code_error.code;
            if (code == 13) {
                
                DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                
            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];

    }];
    
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


//设置头视图
-(UIView *)setHeaderView {
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    
    //创建一个文件管理者
    if (self.mineInfoModel.bgimg != nil && ![self.mineInfoModel.bgimg isEqualToString:@""]) {

        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.mineInfoModel.bgimg] placeholderImage:[UIImage imageNamed:@"ad_doctor_3"]];
        
    } else {
        
        self.backgroundImageView.image = [UIImage imageNamed:@"ad_doctor_3"];
        
    }
    
//布局
    CGSize city_size;
    if (self.mineInfoModel.city) {
        
        city_size = [self.mineInfoModel.city sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]}];
        
    }else {
        self.mineInfoModel.city = @"暂未设置";
        city_size = [self.mineInfoModel.city sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]}];

    }
    CGSize sex_size;
    if (self.mineInfoModel.sex) {
        
        sex_size = [self.mineInfoModel.sex sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]}];
        
    }else {
        
        self.mineInfoModel.sex = @"暂未设置";
        city_size = [self.mineInfoModel.city sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]}];
        
    }
    CGFloat temp_w = city_size.width + sex_size.width + 35;
    if (temp_w > kScreenWidth * 0.6) {
        
        temp_w = kScreenWidth * 0.6;
        
    }
    CGFloat temp_h = 0.0;
    if (sex_size.height > 15 || city_size.height > 15) {
        
        if (sex_size.height > city_size.height) {
            
            temp_h = sex_size.height + 15;
            
        } else {
            
            temp_h = city_size.height + 15;
        }
        
    } else {
        
        temp_h = 30;
        
    }
    self.userMessage = [[UIView alloc] init];
    [self.backgroundImageView addSubview:self.userMessage];
    [self.userMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundImageView.mas_left).offset(5);
        make.top.equalTo(self.backgroundImageView.mas_top).offset(10);
        
        make.width.offset(temp_w);
        make.height.offset(temp_h);
        
    }];
    [self.userMessage.layer setCornerRadius:temp_h/2];
    [self.userMessage.layer setMasksToBounds:YES];
    [self.userMessage setBackgroundColor:[UIColor whiteColor]];
    [self.userMessage.layer setShadowRadius:15.0f];
    [self.userMessage.layer setShadowColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor];
    [self.userMessage.layer setBorderColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor];
    
    UIImageView *imageView_1 = [[UIImageView alloc] init];
    UILabel *label_1 = [[UILabel alloc] init];
    UIImageView *imageView_2 = [[UIImageView alloc] init];
    UILabel *label_2 = [[UILabel alloc] init];
    label_1.font = [UIFont systemFontOfSize:12.f];
    label_2.font = [UIFont systemFontOfSize:12.f];
    [self.userMessage addSubview:imageView_1];
    [self.userMessage addSubview:imageView_2];
    [self.userMessage addSubview:label_1];
    [self.userMessage addSubview:label_2];
    [label_1 setTextAlignment:NSTextAlignmentCenter];
    [label_2 setTextAlignment:NSTextAlignmentCenter];
    
    [imageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.equalTo(self.userMessage.mas_centerY);
        make.left.equalTo(self.userMessage.mas_left).offset(5);
        make.width.offset(8);
        make.height.offset(10);
        
    }];
    if ([self.mineInfoModel.sex isEqualToString:@"男"]) {
        
        imageView_1.image = [UIImage imageNamed:@"boy"];
        
    } else {
    
        imageView_1.image = [UIImage imageNamed:@"god_icon_sex"];
        
    }

    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(imageView_1.mas_right);
        make.centerY.equalTo(imageView_1.mas_centerY);
        
    }];
    label_1.text = self.mineInfoModel.sex;
    
    [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label_1.mas_right).offset(5);
        make.centerY.equalTo(imageView_1.mas_centerY);
        make.width.offset(8);
        make.height.offset(10);
        
    }];
    imageView_2.image = [UIImage imageNamed:@"god_icon_location"];
    
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView_2.mas_right);
        make.centerY.equalTo(imageView_2.mas_centerY);
        make.right.equalTo(self.userMessage.mas_right).offset(-4);
        make.height.equalTo(label_1.mas_height);
        
    }];
    label_2.text = self.mineInfoModel.city;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImgButtonClicked)];
    [_backgroundImageView setUserInteractionEnabled:YES];
    [_backgroundImageView addGestureRecognizer:gesture];
    
    [self layOutNavigationBar];

    return self.backgroundImageView;
    
}
- (void)userImgButtonClicked
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改背景图" message:@"拍照" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机" ,@"相册" , nil];
    
    [alertView show];
    
}

- (void)userIconHandle {
    
    DDQOthersViewController *mineVC = [[DDQOthersViewController alloc] init];
    mineVC.hidesBottomBarWhenPushed = YES;
    mineVC.others_userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    [self.navigationController pushViewController:mineVC animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1213) {
        if (buttonIndex == 0) {
            return;
        }else {
            DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
    }
    if (buttonIndex ==1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        } else {
        
            [self alertController:@"你没有摄像头"];
            return;
        }
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    else if (buttonIndex ==2)
    {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    else if (buttonIndex ==0)
    {
        
    }
}

- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"avatar.png"];
    
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    
    NSData * Image = [NSData dataWithContentsOfFile:fullPath];
    
    //存图片
    _imageData = [[NSData alloc]init];
    _imageData = Image;
    
    [self asyncPhoto];
}

//修改背景图
- (void) asyncPhoto {
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    [self.hud show:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *spellString = [SpellParameters getBasePostString];
        
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc]init];
        
        NSString *post_String = [postEncryption stringWithPost:[NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]]];
        
        //拼接字符串
        NSString *BOUNDRY = [DDQMineViewController uuid];
        NSString *PREFIX = @"--";
        NSString *LINEND = @"\r\n";
        NSString *MULTIPART_FROM_DATA = @"multipart/form-data";
        NSString *CHARSET = @"UTF-8";
        
        //图片
        int len=512;
        //字节大小
        if(_imageData !=nil){
            len = (int)_imageData.length + len;
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
        
        NSData *imagedata =  _imageData;
        [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"avatar.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img0"],LINEND,LINEND,LINEND];
        
        [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postData  appendData:imagedata];
        [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postData appendData:[[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,PREFIX] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //网络请求
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kEditBgImgUrl]];
        
        [urlRequest setTimeoutInterval:20.0];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
        [urlRequest setValue:CHARSET forHTTPHeaderField:@"Charsert"];
        [urlRequest setValue:[NSString stringWithFormat:@"%@;boundary=%@", MULTIPART_FROM_DATA,BOUNDRY] forHTTPHeaderField:@"Content-Type"];
        
        urlRequest.HTTPBody = postData;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dic objectForKey:@"errorcode"] intValue]==0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功"preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    self.backgroundImageView.image = [UIImage imageWithData:_imageData];
                }];
                [userNameAlert addAction:actionOne];
                [self presentViewController:userNameAlert animated:YES completion:nil];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传失败"preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [userNameAlert addAction:actionOne];
                [self presentViewController:userNameAlert animated:YES completion:nil];
            });
            
        }
        
    });
    
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

-(NSString *)getImageSavePath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"PhotoFile"];
    return imageDocPath;
}


-(void)initData{
    //指定新建文件夹路径
    NSString *imageTmpPath = [self getImageSavePath];
    
    //创建ImageFile文件夹
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageTmpPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:imageTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
	
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - item Target
-(void)showPersonalDataController {
    
    self.dataViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.dataViewController animated:YES];
    
}

/** 网络请求 */
- (void)requestDataOne {
    
    [self.hud show:YES];
	
	
		[self.netWork asyPOSTWithAFN_url:kMyCenterMain andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]] andSuccess:^(id responseObjc, NSError *code_error) {
			
			if (!code_error) {
				
				[self.hud hide:YES];
				
				DDQMineInfoModel *tempModel = [DDQMineInfoModel mj_objectWithKeyValues:responseObjc];
				self.mineInfoModel = tempModel;
				
				//设置头
				self.mainTabelView.tableHeaderView = [self setHeaderView];
				
			} else {
				
				[self.hud hide:YES];
				
				NSInteger code = code_error.code;
				
				if (code == 13) {
					
					[UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DDQLoginViewController alloc] init]];
					
				} else {
					
					[MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
					
				}
				
			}
			
		} andFailure:^(NSError *error) {
			
			[self.hud hide:YES];
			[MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
			
		}];
	
	
}

#pragma mark - lazy load
-(DDQPersonalDataViewController *)dataViewController{
    if (!_dataViewController) {
        _dataViewController = [[DDQPersonalDataViewController alloc] init];
    }
    return _dataViewController;
}

-(NSArray *)cellTitleArray {
    if (!_cellTitleArray) {
        _cellTitleArray = [NSArray arrayWithObjects:@"我的帖子",@"我的订单", nil];
    }
    return _cellTitleArray;
}

-(NSArray *)cellImageArray {
    if (!_cellImageArray) {
        _cellImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"posticon"],[UIImage imageNamed:@"favoriteicon"],[UIImage imageNamed:@"redicon"],[UIImage imageNamed:@"bookicon"],[UIImage imageNamed:@"red_packets_icon_remaining_sum"], nil];
    }
    return _cellImageArray;
}
- (UITableView *)mainTabelView {
    if (!_mainTabelView) {
        _mainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        [_mainTabelView setDelegate:self];
        [_mainTabelView setDataSource:self];
        _mainTabelView.backgroundColor = [UIColor backgroundColor];
        [self.view addSubview:_mainTabelView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.25 )];
        
        UIButton *button = [[UIButton alloc] init];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(10);
            make.height.mas_equalTo(30);
            make.left.equalTo(view.mas_left).offset(10);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        [button setBackgroundColor:[UIColor meiHongSe]];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(popMainViewController) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        _mainTabelView.tableFooterView = view;
    }
    return _mainTabelView;
}
#pragma mark - tableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [UIImage imageNamed:@"dayicon"];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:@"我的日记"];
        return cell;
        
    }else if (indexPath.section == 1) {
        
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [self.cellImageArray objectAtIndex:0];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:[self.cellTitleArray objectAtIndex:0]];
        return cell;

        
    } else if (indexPath.section == 2) {
        
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [self.cellImageArray objectAtIndex:3];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:[self.cellTitleArray objectAtIndex:1]];
        return cell;
        
    } else if (indexPath.section == 3) {
        
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [UIImage imageNamed:@"我的课程"];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:@"我的课程"];
        return cell;
    } else if (indexPath.section == 4){
    
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [self.cellImageArray objectAtIndex:1];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:@"我的收藏"];
        return cell;
    } else {
    
        DDQMineTableViewCell  *cell = [[DDQMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.cellImageView.image = [self.cellImageArray lastObject];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell.cellLabel setText:@"我的钱包"];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kScreenWidth > 414) {
        return self.view.bounds.size.height*0.1;
        
    } else {
        return self.view.bounds.size.height*0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return 10;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *foot_view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    foot_view.backgroundColor = [UIColor backgroundColor];
    return foot_view;
}

//重点
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //我的日记
    DDQMyDiaryViewController *myDiaryVC = [[DDQMyDiaryViewController alloc] init];
    //我的评论
    DDQMyCommentViewController *myCommentVC = [[DDQMyCommentViewController alloc] init];

    DDQNewOrderListController *orderC = [[DDQNewOrderListController alloc] init];

    DDQMyCollectViewController *collectVC = [[DDQMyCollectViewController alloc] init];
    
    DDQMyLessonViewController *lesson_vc = [DDQMyLessonViewController new];
    //钱包
    DDQMyWalletViewController *walletVC = [[DDQMyWalletViewController alloc] init];
    if (indexPath.section == 0) {
        
        myDiaryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myDiaryVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        myCommentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCommentVC animated:YES];
        
    } else if (indexPath.section == 2){
        
        orderC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderC animated:YES];

    } else if (indexPath.section == 3) {
    
        lesson_vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lesson_vc animated:YES];
    } else if (indexPath.section == 4){
    
        collectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectVC animated:YES];
    } else {
    
        walletVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:walletVC animated:YES];
    }
}

/**
 * @ author SuperLian
 *
 * @ date   12.7
 *
 * @ func   alertView代理方法
 */
#pragma mark - other methods
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}
@end
