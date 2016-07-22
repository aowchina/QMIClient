//
//  DDQHotProjectViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHotProjectViewCell.h"

@implementation DDQHotProjectViewCell

@synthesize backgroundView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.modelImageView = [[UIImageView alloc] init];
        self.modelImageView.frame = CGRectMake(kScreenWidth*0.02, kScreenHeight *0.01, kScreenWidth*0.3, kScreenHeight*0.18);
        [self addSubview:self.modelImageView];
        
        
        
        self.projectIntro = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.34, kScreenHeight *0.01, kScreenWidth*0.64, kScreenHeight*0.08)];
        [self addSubview:self.projectIntro];
        [self.projectIntro setNumberOfLines:0];
        [self.projectIntro setFont:[UIFont boldSystemFontOfSize:18.0f]];
        self.projectIntro.textColor = [UIColor blackColor];
        
        
        self.projectHospital = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.34, kScreenHeight *0.09, kScreenWidth*0.69, kScreenHeight*0.04)];
        [self addSubview:self.projectHospital];
        [self.projectHospital setFont:[UIFont systemFontOfSize:15.0f]];
        //69
        self.projectPrice = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.34, kScreenHeight *0.15, kScreenWidth*0.2, kScreenHeight*0.04)];
        [self addSubview:self.projectPrice];
        self.projectIntro.font = [UIFont systemFontOfSize:15.0f];
        self.projectIntro.textColor = [UIColor redColor];
        
        self.oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.56, kScreenHeight *0.15, kScreenWidth*0.2, kScreenHeight*0.04)];
        [self addSubview:self.oldPrice];
        self.oldPrice.font = [UIFont boldSystemFontOfSize:10.0];
        
        
        self.sellNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.81, kScreenHeight *0.15, kScreenWidth*0.17, kScreenHeight*0.04)];
        [self addSubview:self.sellNum];
        [self.sellNum setFont:[UIFont systemFontOfSize:10.0f]];
        [self.sellNum setTextAlignment:NSTextAlignmentRight];

    }
    
    return self;
    
}
-(void)setModel:(THModel *)model
{
    [self.modelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.simg]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    self.projectIntro.text = [NSString stringWithFormat:@"【%@】%@",model.fname,model.name];
    self.projectIntro.textColor = [UIColor blackColor];
    
    self.projectHospital.text = [NSString stringWithFormat:@"%@",model.hname];
    self.projectHospital.textColor = kLeftColor;
    
    self.projectPrice.text = [NSString stringWithFormat:@"￥%@",model.newval];
    self.projectPrice.textColor = [UIColor meiHongSe];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.oldval] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:kLeftColor}];

    self.oldPrice.attributedText = string;
    self.sellNum.text = [NSString stringWithFormat:@"已售:%@",model.sellout];
    self.sellNum.textColor = kLeftColor;
}



@end
