//
//  DDQUserPolicyController.m
//  QuanMei
//
//  Created by Ewonder on 8/15/16.
//  Copyright © 2016 min-fo. All rights reserved.
//

#import "DDQUserPolicyController.h"

@interface DDQUserPolicyController ()

@property(nonatomic,strong) UIWebView *webConent;

@end

@implementation DDQUserPolicyController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	if(self.category_tag==0){
		[self.navigationItem setTitle:@"用户协议"];
	}else{
		[self.navigationItem setTitle:@"隐私条款"];
	}
	
	//设置左按钮
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_return"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackMethod)];
	
	self.navigationItem.leftBarButtonItem = leftItem;
	
	[self initWebContent];
}

- (void)initWebContent{
	
	
	self.webConent = [[UIWebView alloc] init];
	
	self.webConent.scrollView.bounces = false;
	
	[self.view addSubview:self.webConent];
	
	[self.webConent mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.offset(self.view.bounds.size.width);//w
		make.bottom.equalTo(self.view.mas_bottom);//h
		make.left.equalTo(self.view.mas_left);//x
		make.top.equalTo(self.view.mas_top);//y
	}];
	
	
	
	NSURL *url = [NSURL URLWithString:self.category_url];
	
	[self.webConent loadRequest:[NSURLRequest requestWithURL:url]];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goBackMethod {
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

@end
