//
//  DDQLoopView.m
//  我的轮播图
//
//  Created by Min-Fo_003 on 16/2/2.
//  Copyright © 2016年 ddq. All rights reserved.
//

#import "DDQLoopView.h"

@interface DDQLoopView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property ( strong, nonatomic) NSIndexPath *temp_path;

@end

@implementation DDQLoopView

-(void)layoutSubviews {

    UICollectionViewFlowLayout *flow_layout = [UICollectionViewFlowLayout new];
    flow_layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滑动
    
    self.loop_collection = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flow_layout];
    [self addSubview:self.loop_collection];
    [self.loop_collection setBackgroundColor:[UIColor clearColor]];
    self.loop_collection.delegate = self;
    self.loop_collection.dataSource = self;
    [self.loop_collection registerClass:[LoopCollectionViewCell class] forCellWithReuseIdentifier:@"loop"];
    
    self.loop_collection.pagingEnabled = YES;//整页翻
    self.loop_collection.bounces = NO;//不能弹
    self.loop_collection.showsHorizontalScrollIndicator = NO;
    
    self.page_control = [[UIPageControl alloc] initWithFrame:CGRectMake(self.loop_collection.center.x-50, self.loop_collection.frame.size.height-30, 100, 20)];
    [self addSubview:self.page_control];
    self.page_control.currentPage = 0;
    self.page_control.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.page_control.pageIndicatorTintColor = [UIColor lightTextColor];

}

//定时器实现方法
-(void)changeCollectionViewCell {

    NSIndexPath *current_path = [[self.loop_collection indexPathsForVisibleItems] lastObject];//从可见cell的集合里拿出cell。
    
    NSInteger net_row = current_path.item + 1;//这是计算下一个cell的row
    NSInteger net_section = current_path.section;//这是计算下一个cell的section
    
    if (net_row == self.source_array.count) {//这样是让他回到第0分区的第0个cell
        
        net_row = 0;
        net_section = 0;
//        net_section++;

    }
    
    //改变pagecontrol
    self.page_control.currentPage = net_row;

    NSIndexPath *new_path = [NSIndexPath indexPathForItem:net_row inSection:net_section];
    
    [self.loop_collection scrollToItemAtIndexPath:new_path atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

#pragma collectionview delegte datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
//    return 10000;//如果不想要图片回退的效果，可以多设几个分区,让分区逐步提升
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.source_array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LoopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loop" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.loop_img sd_setImageWithURL:[NSURL URLWithString:self.source_array[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default_big_pic"]];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loopview_selectedMethod:)]) {
        
        [self.delegate loopview_selectedMethod:indexPath.row];
        
    }
    
}

#pragma scrollview delegate datasource
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    [self stop];
    //改变pagecontrol
    NSIndexPath *index_path = [[self.loop_collection indexPathsForVisibleItems] firstObject];
    NSInteger page;
    if (index_path.row == self.temp_path.row ) {
        
        NSIndexPath *index_path = [[self.loop_collection indexPathsForVisibleItems] lastObject];
        page = index_path.row;
        self.temp_path = index_path;

    } else {
        
        page = index_path.row;
        self.temp_path = index_path;
        
    }
    
    self.page_control.currentPage = page;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self star];
    
}


-(void)star {

    self.loop_timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeCollectionViewCell) userInfo:nil repeats:YES];
    
}

-(void)stop {

    [self.loop_timer invalidate];
    self.loop_timer = nil;
    
}

@end
