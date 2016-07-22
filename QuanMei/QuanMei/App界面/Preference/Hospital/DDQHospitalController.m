//
//  DDQHospitalController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/22.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalController.h"

#import "DDQHospitalCell.h"
#import "DDQHospitalImageCell.h"
#import "DDQHospitalIntroCell.h"
#import "SDWebImageManager.h"
#import "DDQHospitalModel.h"

#import "ProjectNetWork.h"

@interface DDQHospitalController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  主的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) DDQHospitalModel *hospitalModel;

@property (nonatomic, strong) ProjectNetWork *netWork;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation DDQHospitalController

- (MBProgressHUD *)hud {
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.detailsLabelText = @"请稍等...";
        
    }
    
    return _hud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self asyHospitalDetailNetWork];
   
    //注册一个通知你懂得
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageBig:) name:@"show" object:nil];
    
}


-(void)showImageBig:(NSNotification *)notifiction {
    
    UIView *temp_view         = [[UIView alloc] initWithFrame:self.view.frame];
    temp_view.backgroundColor = [UIColor backgroundColor];
    
    UIScrollView *temp_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    
    CGFloat imageW = kScreenWidth;
    for (int i = 0; i< self.hospitalModel.xcimg.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW*i, 0, imageW, self.view.frame.size.height*0.5)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.xcimg[i]]];
        [temp_scroll addSubview:imageView];
    }
    
    temp_scroll.contentSize   = CGSizeMake(imageW*self.hospitalModel.xcimg.count, 0);
    temp_scroll.showsHorizontalScrollIndicator = NO;
    temp_scroll.pagingEnabled = YES;
    
    UITapGestureRecognizer *scroll_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    
    [self.view addSubview:temp_view];
    [temp_view addSubview:temp_scroll];
    [temp_view addGestureRecognizer:scroll_tap];
}

-(void)hiddenView:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    [view removeFromSuperview];
}

-(void)asyHospitalDetailNetWork {
    
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:kHospital_DetailUrl andData:@[self.hospital_id] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            NSInteger code = code_error.code;
            
            if (code == 11) {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"医院信息不存在或已被删除" andShowDim:NO andSetDelay:YES andCustomView:nil];

            } else {
            
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];

            }
            
        } else {
            
            NSDictionary *get_jsonDic = [DDQPublic nullDic:responseObjc];
            
            self.hospitalModel = [[DDQHospitalModel alloc] init];
            self.hospitalModel.alimg             = [get_jsonDic valueForKey:@"alimg"];
            self.hospitalModel.ID                = [NSString stringWithFormat:@"%@",[get_jsonDic valueForKey:@"id"]];
            self.hospitalModel.intro             = [get_jsonDic valueForKey:@"intro"];
            self.hospitalModel.logo              = [get_jsonDic valueForKey:@"logo"];
            self.hospitalModel.name              = [get_jsonDic valueForKey:@"name"];
            self.hospitalModel.xcimg             = [get_jsonDic valueForKey:@"xcimg"];
            
            [self.hud hide:YES];
            
            [self.mainTableView reloadData];
            
            [self setTableViewFootView];
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];

}

-(void)setTableViewFootView {
    //先初始化
    self.footerView = [[UIView alloc] init];
    self.footerView.backgroundColor = [UIColor backgroundColor];
//    CGFloat imageW = self.view.frame.size.width;
//    CGFloat splitH = 10;
//    CGFloat imageH = self.view.frame.size.height*0.2;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    for (int i = 0; i<self.hospitalModel.alimg.count; i++) {
//        [imageView sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.alimg[i]]];
         __block CGFloat tempImgH = 0.0;

        [manager downloadImageWithURL:[NSURL URLWithString:self.hospitalModel.alimg[i]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            CGFloat w = image.size.width;
            CGFloat h = image.size.height;
            
            //计算X起点与图片宽
            CGFloat imgMostW = kScreenWidth - 20;//图片最大宽
            
            CGFloat originX;//X的起点
            CGFloat tempW;//w和imgMostW之间的比较
            if (w > imgMostW) {
                
                tempW = imgMostW;
                
                originX = 10;
                
            } else {
                
                tempW = w;
                
                originX = kScreenWidth * 0.5 - w*0.5;
                
            }
            
            //计算图片高
            CGFloat imgH = tempW * h / w;

            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(originX, tempImgH, tempW, imgH)];
            img.image = image;
            [self.footerView addSubview:img];
            
            tempImgH += imgH;
            
            self.footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, tempImgH);
            
            self.mainTableView.tableFooterView = self.footerView;

        }];
        
    }
    

}

#pragma mark - tableView
-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
}

#pragma mark - delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1+1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            DDQHospitalCell *hospitalCell  = [[DDQHospitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hospital"];
            hospitalCell.selectionStyle    = UITableViewCellSelectionStyleNone;
            [hospitalCell.hospitalImage sd_setImageWithURL:[NSURL URLWithString:self.hospitalModel.logo]];
            hospitalCell.hospitalName.text = self.hospitalModel.name;
            return hospitalCell;
            
        } else {
            
            DDQHospitalImageCell *imageCell = [[DDQHospitalImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image"];
            imageCell.hospitalModel  = self.hospitalModel;
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;

        }
        
    } else  {
        
        DDQHospitalIntroCell *introCell = [[DDQHospitalIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"intro"];
        [introCell introLabelText:self.hospitalModel.intro];
        
        self.rowHeight           = introCell.newRect.size.height;
        introCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return introCell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    } else {
        
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 30;
        
    } else {
        
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return kScreenHeight*0.1 + 5;
            
        } else {
            return kScreenHeight*0.15 + 10;
            
        }
        
    } else if (indexPath.section == 1) {
        
        return  _rowHeight;
        
    } else {
        
        return 10;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1 ) {
        
        return @"医院介绍";
        
    }  else {
        
        return nil;
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
         return @"医院案例";
        
    } else {
        
         return @"";
    }
}
@end
