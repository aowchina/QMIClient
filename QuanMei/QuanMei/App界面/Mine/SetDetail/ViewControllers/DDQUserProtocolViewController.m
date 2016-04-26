//
//  DDQUserProtocolViewController.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/16.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQUserProtocolViewController.h"

@interface DDQUserProtocolViewController ()

@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation DDQUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)buildLabel {
    self.protocolLabel = [[UILabel alloc] init];
    [self.view addSubview:self.protocolLabel];
}
@end
