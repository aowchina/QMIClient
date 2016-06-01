//
//  DDQTeacherView.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQTeacherView.h"

#import "DDQTeacherlistModel.h"
@interface DDQTeacherView ()


@end

@implementation DDQTeacherView

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews {
    
    UICollectionViewFlowLayout *view_layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.teacher_collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-64) collectionViewLayout:view_layout];
    self.teacher_collectionview.showsVerticalScrollIndicator = NO;
    self.teacher_collectionview.delegate = self;
    self.teacher_collectionview.dataSource = self;
    self.teacher_collectionview.backgroundColor = [UIColor whiteColor];
    
    [self.teacher_collectionview registerClass:[DDQTeacherCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [self addSubview:self.teacher_collectionview];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.collectionview_dataSource.count;
}

static NSString *identifier = @"item";
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    DDQTeacherCollectionViewCell *teacheritem = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    DDQTeacherlistModel *teacher_model = self.collectionview_dataSource[indexPath.row];
    teacheritem.teacher_name.text = [NSString stringWithFormat:@"%@",teacher_model.name];
    
    [teacheritem.teacher_img sd_setImageWithURL:[NSURL URLWithString:teacher_model.logo] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    teacheritem.backgroundColor = [UIColor whiteColor];
    return teacheritem;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.frame.size.width*0.33333333, self.frame.size.height*0.3);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(teacherView:didSelectedOfViewIndexPath:)]) {
        [self.delegate teacherView:collectionView didSelectedOfViewIndexPath:indexPath];
    }
}

@end
