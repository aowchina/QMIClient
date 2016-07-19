//
//  DDQCommentFirstCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/27.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQCommentFirstCell.h"

@implementation DDQCommentFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithCommentModel:(DDQCommentModel *)commentModel {
    self.commentModel = commentModel;
    CGRect titleSize    = [commentModel.title boundingRectWithSize:CGSizeMake(kScreenWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:4.0f]} context:nil];

    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, titleSize.size.width, titleSize.size.height)];
    titleLable.text     = commentModel.title;
    titleLable.font     = [UIFont systemFontOfSize:16.0f weight:3.0f];
    [self.contentView addSubview:titleLable];
    
    
    CGRect textSize     = [commentModel.text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    UILabel *textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+titleSize.size.height, textSize.size.width, textSize.size.height)];
    textLabel.text      = commentModel.text;
    textLabel.font      = [UIFont systemFontOfSize:13.0f];
    textLabel.numberOfLines = 0;
    [self.contentView addSubview:textLabel];
  
    CGFloat UImageW = kScreenWidth - 20;
    CGFloat UImageH = UImageW;
    if (commentModel.imgs.count > 0) {

        for (int i = 0; i<commentModel.imgs.count; i++) {

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10, textLabel.frame.origin.y + textLabel.frame.size.height + UImageW*i + 10*i, UImageW, UImageH)];
            [self.contentView addSubview:imageView];

            [imageView sd_setImageWithURL:[NSURL URLWithString:commentModel.imgs[i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];

        }

        self.newHeight = titleSize.size.height + textLabel.frame.size.height + UImageW*commentModel.imgs.count + 10 * commentModel.imgs.count ;

    } else {
    
        self.newHeight = titleSize.size.height + textLabel.frame.size.height;
    }
    
}



@end
