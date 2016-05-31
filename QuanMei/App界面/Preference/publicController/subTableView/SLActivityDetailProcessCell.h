//
//  SLActivityDetailProcessCell.h
//  NewDetailDemo
//
//  Created by min-fo013 on 15/10/14.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "SLActivityDetailBaseCell.h"

@interface SLActivityDetailProcessCell : SLActivityDetailBaseCell
@property (nonatomic, strong) UILabel *headerLabel;
//流程介绍
@property (nonatomic, strong)UILabel *processLabel;
//注意
@property (nonatomic, strong)UILabel *attentionLabel;

@end
