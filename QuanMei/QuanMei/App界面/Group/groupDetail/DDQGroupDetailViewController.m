//
//  DDQGroupDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQGroupDetailViewController.h"
#import "DDQNewestCommentViewController.h"
#import "DDQEssenceCommentViewController.h"

#import "DDQDiaryViewCell.h"
#import "DDQHotProjectViewCell.h"

#import "DDQHeaderSingleModel.h"
#import "DDQGroupArticleModel.h"

@interface DDQGroupDetailViewController ()
/**
 *  titleView
 */
@property (strong,nonatomic) UISegmentedControl *segmentedControl;

@property (strong,nonatomic) DDQNewestCommentViewController *newestCommentController;
@property (strong,nonatomic) DDQEssenceCommentViewController *essenceCommentController;
////12-03
@property (nonatomic ,strong)UIViewController *currentController;

@property (strong,nonatomic) UITableView *mainTableView;
@property (strong,nonatomic) UITableView *childTableView;

@property (strong,nonatomic) NSMutableArray *newestModelArray;
@property (strong,nonatomic) NSMutableArray *essenceModelArray;
@end

@implementation DDQGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self childViewController];
    [self setNavigationBar];
    
}

#pragma mark - childViewController
-(void)childViewController {
    [self.newestCommentController.view setFrame:self.view.frame];
    [self addChildViewController:self.newestCommentController];
    
    [self.essenceCommentController.view setFrame:self.view.frame];
    [self addChildViewController:self.essenceCommentController];
    
//    [self.view addSubview:self.newestCommentController.view];
    [self.view addSubview:self.essenceCommentController.view];

    [self.view insertSubview:self.newestCommentController.view aboveSubview:self.essenceCommentController.view];
//    [self.view insertSubview:self.essenceCommentController.view aboveSubview:self.newestCommentController.view];
}

#pragma mark - navigationBar
-(void)setNavigationBar {
    NSArray *array = @[@"最新",@"精华"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlTouchEvent:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(popBackViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
}




#pragma mark - segment and item target action
-(void)segmentedControlTouchEvent:(UISegmentedControl *)seg {

    if (seg.selectedSegmentIndex == 0) {

        [self.view bringSubviewToFront:self.newestCommentController.view];
    }
    
    if (seg.selectedSegmentIndex == 1) {

        [self.view addSubview:self.essenceCommentController.view];

        [self.view bringSubviewToFront:self.essenceCommentController.view];

    }

}

-(void)popBackViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - lazy load

-(DDQNewestCommentViewController *)newestCommentController
{
    if (!_newestCommentController) {
        _newestCommentController = [[DDQNewestCommentViewController alloc] init];
    }
    return _newestCommentController;
}
-(DDQEssenceCommentViewController *)essenceCommentController
{
    if (!_essenceCommentController) {
        _essenceCommentController = [[DDQEssenceCommentViewController alloc] init];
    }
    return _essenceCommentController;
}

@end
