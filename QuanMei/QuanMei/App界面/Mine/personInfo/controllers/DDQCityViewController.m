//
//  DDQCityViewController.m
//  QuanMei
//
//  Created by superlian on 15/12/1.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQCityViewController.h"
#import "ZHPickView.h"
#import "SLValue Singleton.h"

@interface DDQCityViewController ()<ZHPickViewDelegate>

@property (nonatomic, strong) ZHPickView *cityPickView;

@end

@implementation DDQCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildBackgroundView];
}

- (void)buildBackgroundView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.alpha = 0.1;
//    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
//    self.dataPickView=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    self.cityPickView = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    [self.cityPickView setToolbarTintColor:[UIColor whiteColor]];
    [self.cityPickView setTintColor:[UIColor blackColor]];
    self.cityPickView.center = self.view.center;
    self.cityPickView.delegate = self;
    self.cityPickView.backgroundColor = [UIColor whiteColor];
    [self.cityPickView show];
    [self.view addSubview:backgroundView];
    
    [self.view addSubview:self.cityPickView];

}
-(void)getProvinceID{
    
    NSString *SFFilePath = [[NSBundle mainBundle] pathForResource:@"p" ofType:@"txt"];//这是省份的字典
    NSFileHandle *SFFileHandle = [NSFileHandle fileHandleForReadingAtPath:SFFilePath];
    NSData *SFData = [SFFileHandle readDataToEndOfFile];
    NSString *SFJsonString = [[NSString alloc] initWithData:SFData encoding:NSUTF8StringEncoding];
    //    _SFDic = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    NSMutableArray *array = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    for (NSDictionary *province in array) {
        NSString *selectProvince = [SLValue_Singleton shareInstance].province;
        NSUInteger count = selectProvince.length;
        NSString *provincePlist = province[@"name"];
        NSString *finalProvince = [provincePlist substringToIndex:count];
        if ([finalProvince isEqualToString:[SLValue_Singleton shareInstance].province]) {
            [SLValue_Singleton shareInstance].provinceID = province[@"id"];
        }
    }
}
- (void)getCityID {
    NSString *SFFilePath = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"txt"];//这是城市的字典
    NSFileHandle *SFFileHandle = [NSFileHandle fileHandleForReadingAtPath:SFFilePath];
    NSData *SFData = [SFFileHandle readDataToEndOfFile];
    NSString *SFJsonString = [[NSString alloc] initWithData:SFData encoding:NSUTF8StringEncoding];
    //    _SFDic = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    NSMutableDictionary *dic = [[[SBJsonParser alloc] init] objectWithString:SFJsonString];
    NSString *provinceID = [SLValue_Singleton shareInstance].provinceID;
    NSArray *cityAry = dic[provinceID];
    for (NSDictionary *city in cityAry) {
        NSString *selectCity = [SLValue_Singleton shareInstance].city;
        NSUInteger count = selectCity.length;
        NSString *cityPlist = city[@"name"];
        NSUInteger count1 = cityPlist.length;
        if ((int)count1 < (int)count) {
            continue;
        }
        NSString *finalCity = [cityPlist substringToIndex:count];
        if ([finalCity isEqualToString:[SLValue_Singleton shareInstance].city]) {
            [SLValue_Singleton shareInstance].cityID = city[@"id"];
        }
    }
}
#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    [SLValue_Singleton shareInstance].pickCityStr = resultString;
    [self getProvinceID];
    [self getCityID];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:nil];
    }];
}

-(void)ZHPickView:(ZHPickView *)pickView cancelBtnDidClick:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
