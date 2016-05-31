//
//  DDQTeacherView.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQTeacherCollectionViewCell.h"

@protocol TeacherViewDelegate;

@interface DDQTeacherView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak,nonatomic) id <TeacherViewDelegate> delegate;

@property (strong,nonatomic) UICollectionView *teacher_collectionview;
@property (strong,nonatomic) NSArray *collectionview_dataSource;

@end



@protocol TeacherViewDelegate <NSObject>

@optional
-(void)teacherView:(UICollectionView *)tacherView didSelectedOfViewIndexPath:(NSIndexPath *)path;

@end