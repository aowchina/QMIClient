//
//  DDQTeacherIntroView.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQRowOneTableViewCell.h"
#import "DDQRowTwoTableViewCell.h"
#import "DDQRowThreeTableViewCell.h"
#import "DDQTeacherIntroModel.h"

@protocol IntroViewDelegate <NSObject>
//@required
//-(void)intro_viewWithOrder:(NSInteger)num;
@optional
-(void)intro_selectedType;
@end
@interface DDQTeacherIntroView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) id <IntroViewDelegate> delegate;
@property (strong,nonatomic) UITableView *intro_tableview;
@property (strong,nonatomic) DDQTeacherIntroModel *intro_model;
@property (assign,nonatomic) CGFloat row_h;
@property ( strong, nonatomic) UIImageView *header_img;
@end
