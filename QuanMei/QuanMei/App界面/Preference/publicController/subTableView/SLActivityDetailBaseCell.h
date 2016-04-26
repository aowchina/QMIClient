//
//  SLActivityDetailBaseCell.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat SLGetScreenWidth();

@class SLActivityModel;
@protocol SLActivityDetailCellDelegate;
@interface SLActivityDetailBaseCell : UITableViewCell

@property (nonatomic, weak) id<SLActivityDetailCellDelegate>delegate;
@property (nonatomic, strong, readonly) SLActivityModel *activity;

//重载数据源
- (void)reloadWithActivityModel:(SLActivityModel *)activity;
//cell高度
+ (CGFloat)heightWithActivityModel:(SLActivityModel *)activity;

@end

@protocol SLActivityDetailCellDelegate <NSObject>

@optional
- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell webDidFinshWithError:(NSError *)error;
- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedID:(NSString *)priceID;
- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedFriendID:(NSString *)friendID;
- (void)activityDetailBaseCell:(SLActivityDetailBaseCell *)cell didSelectedHospitalID:(NSString *)hospitalID;

@end
