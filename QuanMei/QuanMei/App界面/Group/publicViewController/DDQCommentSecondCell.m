//
//  DDQCommentSecondCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/27.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQCommentSecondCell.h"

@implementation DDQCommentSecondCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


-(NSMutableArray *)son_sourceArray {
    if (!_son_sourceArray) {
        _son_sourceArray = [NSMutableArray array];
    }
    return _son_sourceArray;
}


-(void)cellWithReplyModel:(DDQReplyModel *)replyModel {
    self.replyModel = replyModel;
#warning 楼主
    
    if (kScreenHeight == 480) {
        _imageW = 30;
        _imageH = 30;
    } else if (kScreenHeight == 568) {
        _imageW = 40;
        _imageH = 40;
    } else {
        _imageW = 50;
        _imageH = 50;
    }
    
    UIImageView *imageView        = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, _imageW, _imageH)];
    imageView.layer.cornerRadius  = _imageH/2;
    imageView.layer.masksToBounds = YES;
    imageView.tag = 1;
    [imageView sd_setImageWithURL:[NSURL URLWithString:replyModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [self.contentView addSubview:imageView];
    
    
    CGRect nicknameSize    = [replyModel.username boundingRectWithSize:CGSizeMake(kScreenWidth, _imageW/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:3.0f]} context:nil];
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_centerY);
        make.width.offset(nicknameSize.size.width);
        make.height.offset(nicknameSize.size.height);
        make.left.equalTo(imageView.mas_right).offset(5);
    }];
    nicknameLabel.text     = replyModel.username;
    nicknameLabel.tag = 2;
    nicknameLabel.font     = [UIFont systemFontOfSize:14.0f weight:2.0f];
    
    
    CGRect pubtimeSize    = [replyModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, _imageW/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    UILabel *pubtimeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:pubtimeLabel];
    [pubtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_centerY);
        make.width.offset(pubtimeSize.size.width);
        make.height.offset(pubtimeSize.size.height);
        make.left.equalTo(nicknameLabel.mas_left);
    }];
    pubtimeLabel.text     = replyModel.pubtime;
    pubtimeLabel.tag = 3;
    pubtimeLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    
    CGRect introSize    = [replyModel.text boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    
    UILabel *introLabel  = [[UILabel alloc] initWithFrame:CGRectMake(5+_imageW, 15+_imageW, kScreenWidth - _imageW, introSize.size.height)];
    [self.contentView addSubview:introLabel];
    introLabel.text      = replyModel.text;
    introLabel.tag       = 4;
    introLabel.numberOfLines = 0;
    introLabel.font      = [UIFont systemFontOfSize:16.0f];
    
    UIImageView *replyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    replyImage.image        = [UIImage imageNamed:@"reply"];
    
    NSString *replyStr  = @"回复";
    CGRect replySize    = [replyStr boundingRectWithSize:CGSizeMake(kScreenWidth, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, replySize.size.width, replySize.size.height)];
    replyLabel.text     = replyStr;
    replyLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    //评论view
    UIView *replyView   = [[UIView alloc] init];
    [self.contentView addSubview:replyView];
    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(replyImage.frame.size.width + replyLabel.frame.size.height);
        make.height.offset(replyLabel.frame.size.height);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(introLabel.mas_bottom).offset(5);
    }];
    replyView.tag = 5;

    [replyView addSubview:replyLabel];
    [replyView addSubview:replyImage];
    
    UITapGestureRecognizer *reply_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyComment:)];
    [replyView addGestureRecognizer:reply_tap];
    
    UIImageView *thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];

    if ([self.replyModel.status intValue] == 0) {
        thumbImage.image = [UIImage imageNamed:@"praise"];
    } else {
        thumbImage.image = [UIImage imageNamed:@"is_praised_item"];

    }
    
    NSString *thumbStr  = @"点赞";
    CGRect thumbRect    = [thumbStr boundingRectWithSize:CGSizeMake(kScreenWidth, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    UILabel *thumbLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, thumbRect.size.width, thumbRect.size.height)];
    thumbLabel.text     = thumbStr;
    thumbLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    UITapGestureRecognizer *thumb_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    
    //点赞view
    UIView *thumbView   = [[UIView alloc] init];
    [self.contentView addSubview:thumbView];
    [thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(thumbImage.frame.size.width + thumbLabel.frame.size.height);
        make.height.offset(thumbLabel.frame.size.height);
        make.right.equalTo(replyView.mas_left).offset(-20);
        make.centerY.equalTo(replyView.mas_centerY);
    }];
    [thumbView addGestureRecognizer:thumb_tap];
    [thumbView addSubview:thumbImage];
    [thumbView addSubview:thumbLabel];
    thumbView.tag = 6;

    
    self.viewtop_H               = 25+_imageH+introSize.size.height+replySize.size.height;
   
    for (NSDictionary *son_dic in replyModel.son) {
        
        DDQSonModel *sonModel = [[DDQSonModel alloc] init];
        sonModel.iD           = [son_dic valueForKey:@"id"];
        sonModel.pubtime      = [son_dic valueForKey:@"pubtime"];
        sonModel.text         = [son_dic valueForKey:@"text"];
        sonModel.userid       = [son_dic valueForKey:@"userid"];
        sonModel.userid2      = [son_dic valueForKey:@"userid2"];
        sonModel.username     = [son_dic valueForKey:@"username"];
        sonModel.wid          = [son_dic valueForKey:@"wid"];
        sonModel.username2    = [son_dic valueForKey:@"username2"];
        sonModel.isShow       = NO;
        [self.son_sourceArray addObject:sonModel];
    }
    
    
    if (self.son_sourceArray.count >= 5 ) {
        
        
        UITableView *reply_tableView = [[UITableView alloc] initWithFrame:CGRectMake(_imageW, self.viewtop_H, kScreenWidth - _imageW, 250) style:UITableViewStylePlain];
        reply_tableView.delegate   = self;
        reply_tableView.dataSource = self;
        reply_tableView.scrollEnabled   = NO;
        reply_tableView.backgroundColor = [UIColor clearColor];
        reply_tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        reply_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        reply_tableView.tag = 7;
        [self.contentView addSubview:reply_tableView];
        
       
        UITapGestureRecognizer *label_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelTarget:)];
        
        if ([replyModel.more_hf intValue] != 0) {
            UILabel *lable = [[UILabel alloc] init];
            [self.contentView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(reply_tableView.mas_right);
                make.top.equalTo(reply_tableView.mas_bottom).offset(20);
                make.height.offset(25);
            }];
            NSString *str = [NSString stringWithFormat:@"更多(%d)回帖",[replyModel.more_hf intValue]];
            lable.attributedText = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor meiHongSe]}];
            lable.tag = 9;
            lable.userInteractionEnabled = YES;
            
            [lable addGestureRecognizer:label_tap];
            
            UIView *bottom_view = [[UIView alloc] init];
            [self.contentView addSubview:bottom_view];
            [bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right);
                make.height.offset(10);
                make.left.equalTo(self.contentView.mas_left);
                make.top.equalTo(lable.mas_bottom);
            }];
            bottom_view.tag = 8;
            bottom_view.backgroundColor = [UIColor backgroundColor];
            
            self.viewBottom_H = reply_tableView.frame.size.height + 45;

        } else {
        
            UIView *bottom_view = [[UIView alloc] init];
            [self.contentView addSubview:bottom_view];
            [bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right);
                make.height.offset(10);
                make.left.equalTo(self.contentView.mas_left);
                make.top.equalTo(self.contentView.mas_bottom);
            }];
            bottom_view.tag = 8;
            bottom_view.backgroundColor = [UIColor backgroundColor];
            self.viewBottom_H = reply_tableView.frame.size.height + 10 ;
        }
        
    } else {
    
        
//        if (self.son_sourceArray.count != 0) {
        
            UITableView *reply_tableView = [[UITableView alloc] initWithFrame:CGRectMake(_imageW, self.viewtop_H, kScreenWidth - _imageW, self.son_sourceArray.count*50) style:UITableViewStylePlain];
            
            reply_tableView.delegate        = self;
            reply_tableView.dataSource      = self;
            reply_tableView.scrollEnabled   = NO;
            reply_tableView.backgroundColor = [UIColor clearColor];
            reply_tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
            reply_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            reply_tableView.tag             = 7;
            [self.contentView addSubview:reply_tableView];
            
            UIView *bottom_view = [[UIView alloc] init];
            [self.contentView addSubview:bottom_view];
            [bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right);
                make.height.offset(10);
                make.left.equalTo(self.contentView.mas_left);
                make.top.equalTo(reply_tableView.mas_bottom);
            }];
            bottom_view.tag = 8;
            bottom_view.backgroundColor = [UIColor backgroundColor];
            
            self.viewBottom_H = reply_tableView.frame.size.height;

    }

}

#pragma mark - delegate
static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //取出model类
    DDQSonModel *sonModel = [self.son_sourceArray objectAtIndex:indexPath.row];
    
    //计算评论的长度

    //首先全拼到一起去
    NSAttributedString *firstname  = [[NSAttributedString alloc] initWithString:sonModel.username attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    NSAttributedString *secondname = [[NSAttributedString alloc] initWithString:sonModel.username2 attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];

    NSString *totalString                    = [NSString stringWithFormat:@"%@ 回复 %@ :%@",sonModel.username,sonModel.username2,sonModel.text];
    
    NSMutableAttributedString * total_String = [[NSMutableAttributedString alloc] initWithString:totalString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    [total_String replaceCharactersInRange:NSMakeRange(0, sonModel.username.length) withAttributedString:firstname];
    
    [total_String replaceCharactersInRange:NSMakeRange(sonModel.username.length + 4, sonModel.username2.length) withAttributedString:secondname];
    
    //然后计算
    CGRect totalRect = [totalString boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - _imageW,30)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    CGRect pubtimeRect = [sonModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
//    if (!cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    UILabel *intro_label = [[UILabel alloc] init];
    
    intro_label.frame    = CGRectMake(0, 0, kScreenWidth - _imageW, totalRect.size.height);
    intro_label.tag      = 1;
    intro_label.attributedText = total_String;
    intro_label.numberOfLines  = 0;
    intro_label.font           = [UIFont systemFontOfSize:12.0f];
    [cell.contentView addSubview:intro_label];
    
    UIView *line_view = [[UIView alloc] init];
    [cell.contentView addSubview:line_view];
    [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.left.equalTo(cell.contentView.mas_left);
        make.width.equalTo(cell.contentView.mas_width);
        make.height.offset(1);
    }];
    line_view.backgroundColor = [UIColor backgroundColor];
    
    UILabel *pubTimeLabel = [[UILabel alloc] init];
    
    pubTimeLabel.frame    = CGRectMake(0, 50-intro_label.frame.size.height-5, pubtimeRect.size.width, pubtimeRect.size.height);
    pubTimeLabel.tag      = 2;
    [cell.contentView addSubview:pubTimeLabel];
//    }
//    UILabel *intro_label       = (UILabel *)[cell viewWithTag:1];
   
    
//    UILabel *pubTimeLabel       = (UILabel *)[cell viewWithTag:2];
    pubTimeLabel.text           = sonModel.pubtime;
    pubTimeLabel.font           = [UIFont systemFontOfSize:12.0f];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.son_sourceArray.count > 5) {
        return 5;
    } else {
        return self.son_sourceArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQSonModel *sonModel = self.son_sourceArray[indexPath.row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(secondCommentCellPushToReplyVCWithSonModel:)]) {
        [self.delegate secondCommentCellPushToReplyVCWithSonModel:sonModel];
    }
}

#pragma mark - 手势事件
-(void)changeImage:(UITapGestureRecognizer *)tap {
    
    UIView *tap_view = [tap view];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(secondCommentCellThumbClickWithView:Model:)]) {
		
		[self.delegate secondCommentCellThumbClickWithView:(UIImageView *)tap_view Model:self.replyModel];
		
	}
//
//    if ([self.replyModel.status intValue] == 0) {
//        /**
//         *  选出是imageView的子视图
//         */
//        for (UIView *sub_view in [tap_view subviews]) {
//            
//            if ([sub_view isKindOfClass:[UIImageView class]]) {
//                
//                UIImageView *image = (UIImageView *)sub_view;
//                image.image = [UIImage imageNamed:@"is_praised_item"];
//                [self.temp_array removeAllObjects];
//                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
//                     //拿出userid
//                     //拿出评论类型
//                     //拿出点赞目标的id
//                     NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",[SpellParameters getBasePostString],[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"2",self.replyModel.iD];
//                     
//                     DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
//                     NSString *post_string             = [postEncryption stringWithPost:post_baseString];
//                     
//                     NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kAddZan];
//                     NSString *errorcode_string        = [post_dic valueForKey:@"errorcode"];
//                     
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         
//                         if ([errorcode_string intValue] == 0) {
//                             
//                             self.replyModel.status = @"1";
//                         } else {
//                             
//                             
//                         }
//                     });
//                     
//                 });
//                
//                
//            } else {
//                return;
//            }
//        }
//        
//    } else {
//        /**
//         *  选出是imageView的子视图
//         */
//        for (UIView *sub_view in [tap_view subviews]) {
//            
//            if ([sub_view isKindOfClass:[UIImageView class]]) {
//                
//                UIImageView *image = (UIImageView *)sub_view;
//                image.image = [UIImage imageNamed:@"praise"];
//                [self.temp_array addObject:@"1"];
//
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
//                    //拿出userid
//                    //拿出评论类型
//                    //拿出点赞目标的id
//                    NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",[SpellParameters getBasePostString],[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"2",self.replyModel.iD];
//                    
//                    DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
//                    NSString *post_string             = [postEncryption stringWithPost:post_baseString];
//                    
//                    NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kDelZan];
//                    NSString *errorcode_string        = [post_dic valueForKey:@"errorcode"];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        if ([errorcode_string intValue] == 0) {
//                            
//                            self.replyModel.status = @"0";
//                        } else {
//                            
//                        }
//                    });
//                    
//                });
//            } else {
//                return;
//            }
//        }
//    }
}

-(void)clickLabelTarget:(UITapGestureRecognizer *)tap {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(secondCommentShowMoreLabelWithReplyModel:)]) {
        [self.delegate secondCommentShowMoreLabelWithReplyModel:self.replyModel];
    }
}


-(void)getViewTag:(UITapGestureRecognizer *)tap {
    
    UIView *view = [tap view];
    DDQSonModel *sonModel = [self.son_sourceArray objectAtIndex:[view tag]];
    
}

-(void)replyComment:(UITapGestureRecognizer *)tap {


    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(secondCommentReplyViewPushToReplyVCWithSonModel:)]) {
        [self.delegate secondCommentReplyViewPushToReplyVCWithSonModel:self.replyModel];
    }
}


-(void)cellWithCallBack:(SecondCommentBlock)secondBlock {

    self.secondBlock = secondBlock;
}


-(NSMutableArray *)temp_array {
    if (!_temp_array) {
        _temp_array = [NSMutableArray arrayWithObjects:@"1", nil];
    }
    return _temp_array;
}








//#warning 楼众
//    if (self.replyModel.son.count != 0) {//son数组不等于0的时候
//
//#warning 判断count是否大于4，大于4就只显示4个
//        if (self.replyModel.son.count > 4) {
//
//            for (int i = 0; i<4; i++) {
//                NSDictionary *dic = [self.replyModel.son objectAtIndex:i];
//                DDQSonModel *sonModel = [[DDQSonModel alloc] init];
//                sonModel.iD               = [dic valueForKey:@"id"];
//                sonModel.pubtime          = [dic valueForKey:@"pubtime"];
//                sonModel.text             = [dic valueForKey:@"text"];
//                sonModel.userid           = [dic valueForKey:@"userid"];
//                sonModel.userid2          = [dic valueForKey:@"userid2"];
//                sonModel.username         = [dic valueForKey:@"username"];
//                sonModel.wid              = [dic valueForKey:@"wid"];
//                sonModel.username2        = [dic valueForKey:@"username2"];
//                [self.son_sourceArray addObject:sonModel];
//            }
//            /**
//             *  计算一下全部加载一起到底多长
//             */
//            CGRect totalSize;
//            CGRect pubtimeRect;
//            UILabel *test_label    = [[UILabel alloc] init];
//            UILabel *pubtime_label = [[UILabel alloc] init];
//            for (int i = 0; i<4; i++) {
//                DDQSonModel *son_model = [self.son_sourceArray objectAtIndex:i];
//
//                NSAttributedString *firstname  = [[NSAttributedString alloc] initWithString:son_model.username attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//                NSAttributedString *secondname = [[NSAttributedString alloc] initWithString:son_model.username2 attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//
//                NSString *totalString                    = [NSString stringWithFormat:@"%@ 回复 %@ :%@",son_model.username,son_model.username2,son_model.text];
//                NSMutableAttributedString * total_String = [[NSMutableAttributedString alloc] initWithString:totalString];
//                [total_String replaceCharactersInRange:NSMakeRange(0, son_model.username.length) withAttributedString:firstname];
//                [total_String replaceCharactersInRange:NSMakeRange(son_model.username.length + 4, son_model.username2.length) withAttributedString:secondname];
//
//                totalSize                 = [totalString boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//                test_label.attributedText = total_String;
//
//
//                pubtimeRect = [replyModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//
//            }
//
//            //intro文本
//            test_label.frame         = CGRectMake(0, 10, totalSize.size.width, totalSize.size.height);
//            test_label.font          = [UIFont systemFontOfSize:13.0f];
//            test_label.numberOfLines = 0;
//
//
//            //这是算view的y在哪里
//            CGFloat viewY = imageH + totalSize.size.height + 10 + replyLabel.frame.size.height*2;
//
//            pubtime_label.frame = CGRectMake(0, 10 + test_label.frame.size.height, pubtimeRect.size.width, pubtimeRect.size.height);
//            pubtime_label.text  = replyModel.pubtime;
//            pubtime_label.font  = [UIFont systemFontOfSize:12.0f];
//
//            //这是算view的h多少
//            CGFloat viewH;
//            if (kScreenHeight == 480) {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            } else if (kScreenHeight == 568) {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            } else {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            }
//
//            for (int i = 0; i<4; i++) {
//                UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(imageW, viewY + viewH*i , kScreenWidth - imageW - 10, viewH)];
//                self.viewHeight = view.frame.size.height;
//                [self.contentView addSubview:view];
//                [view addSubview:pubtime_label];
//                [view addSubview:test_label];
//
//                UIView *lineView         = [[UIView alloc] init];
//                [view addSubview:lineView];
//                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(view.mas_left);
//                    make.right.equalTo(view.mas_right);
//                    make.bottom.equalTo(view.mas_bottom);
//                    make.height.offset(1);
//                }];
//                lineView.backgroundColor = [UIColor backgroundColor];
//            }
//#warning 这里是说数组个数小于等于4
//        } else {
//            for (int i = 0; i<self.replyModel.son.count; i++) {
//                NSDictionary *dic = [self.replyModel.son objectAtIndex:i];
//                DDQSonModel *sonModel = [[DDQSonModel alloc] init];
//                sonModel.iD               = [dic valueForKey:@"id"];
//                sonModel.pubtime          = [dic valueForKey:@"pubtime"];
//                sonModel.text             = [dic valueForKey:@"text"];
//                sonModel.userid           = [dic valueForKey:@"userid"];
//                sonModel.userid2          = [dic valueForKey:@"userid2"];
//                sonModel.username         = [dic valueForKey:@"username"];
//                sonModel.wid              = [dic valueForKey:@"wid"];
//                sonModel.username2        = [dic valueForKey:@"username2"];
//                [self.son_sourceArray addObject:sonModel];
//            }
//            /**
//             *  计算一下全部加载一起到底多长
//             */
//            CGRect totalSize;
//            CGRect pubtimeRect;
//            UILabel *test_label    = [[UILabel alloc] init];
//            UILabel *pubtime_label = [[UILabel alloc] init];
//            for (int i = 0; i<self.son_sourceArray.count; i++) {
//                DDQSonModel *son_model = [self.son_sourceArray objectAtIndex:i];
//
//                NSAttributedString *firstname  = [[NSAttributedString alloc] initWithString:son_model.username attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//                NSAttributedString *secondname = [[NSAttributedString alloc] initWithString:son_model.username2 attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//
//                NSString *totalString                    = [NSString stringWithFormat:@"%@ 回复 %@ :%@",son_model.username,son_model.username2,son_model.text];
//                NSMutableAttributedString * total_String = [[NSMutableAttributedString alloc] initWithString:totalString];
//                [total_String replaceCharactersInRange:NSMakeRange(0, son_model.username.length) withAttributedString:firstname];
//                [total_String replaceCharactersInRange:NSMakeRange(son_model.username.length + 4, son_model.username2.length) withAttributedString:secondname];
//
//                totalSize                 = [totalString boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//                test_label.attributedText = total_String;
//
//                pubtimeRect               = [son_model.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//
//            }
//
//            //intro文本
//            test_label.frame         = CGRectMake(0, 10, totalSize.size.width, totalSize.size.height);
//            test_label.font          = [UIFont systemFontOfSize:13.0f];
//            test_label.numberOfLines = 0;
//
//
//            //这是算view的y在哪里
//            CGFloat viewY = imageH + totalSize.size.height + 10 + replyLabel.frame.size.height*2;
//
//            pubtime_label.frame = CGRectMake(0, 10 + test_label.frame.size.height, pubtimeRect.size.width, pubtimeRect.size.height);
//            pubtime_label.text  = replyModel.pubtime;
//            pubtime_label.font  = [UIFont systemFontOfSize:12.0f];
//
//            //这是算view的h多少
//            CGFloat viewH;
//            if (kScreenHeight == 480) {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            } else if (kScreenHeight == 568) {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            } else {
//
//                viewH = test_label.frame.size.height + pubtime_label.frame.size.height + 15;
//
//            }
//
//            for (int i = 0; i<self.replyModel.son.count; i++) {
//
//                UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(imageW, viewY + viewH*i - 15, kScreenWidth - imageW - 10, viewH)];
//                view.tag        = i;
//                self.viewHeight = view.frame.size.height;
//
//                UITapGestureRecognizer *view_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getViewTag:)];
//
//                [self.contentView addSubview:view];
//                [view addSubview:pubtime_label];
//                [view addSubview:test_label];
//                [view addGestureRecognizer:view_tap];
//
//                UIView *lineView         = [[UIView alloc] init];
//                [view addSubview:lineView];
//                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(view.mas_left);
//                    make.right.equalTo(view.mas_right);
//                    make.bottom.equalTo(view.mas_bottom);
//                    make.height.offset(2);
//                }];
//                lineView.backgroundColor = [UIColor backgroundColor];
//            }
//
//        }
//#warning son数组等于0的时候
//    } else {
//        return;
//    }

@end
