//
//  SLActivityDetailHeaderImageCell.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailBaseCell.h"

@class SLActivityModel;
//貌似大图
@interface SLActivityDetailHeaderImageCell : SLActivityDetailBaseCell

@property (nonatomic, strong)UIImageView *photo;

-(void)reloadWithActivityModel:(SLActivityModel *)activity;

@end
