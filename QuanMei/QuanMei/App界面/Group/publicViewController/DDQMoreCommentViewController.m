//
//  DDQMoreCommentViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/12.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMoreCommentViewController.h"
#import "DDQReplayViewController.h"
#import "DDQReplyModel.h"
#import "DDQSonModel.h"
#import "ProjectNetWork.h"
#import "DDQCommentSecondCell.h"
@interface DDQMoreCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *mainTableView;

@property (assign,nonatomic) CGFloat new_cellHeight;

@property (strong,nonatomic) NSMutableArray *parent_array;
@property (strong,nonatomic) NSMutableArray *child_array;

@property (strong, nonatomic) ProjectNetWork *netWork;

@property (strong,nonatomic) DDQReplyModel *replyModel;

@end

@implementation DDQMoreCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1
    self.parent_array = [NSMutableArray array];
    self.child_array = [NSMutableArray array];
    self.replyModel = [[DDQReplyModel alloc] init];

    [self initTableView];
    
    [self asyMorePLList];

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                [self.child_array removeAllObjects];
                [self asyMorePLList];
                
            }];
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.footer endRefreshing];
        }
    }];
   
    //2
	self.netWork = [ProjectNetWork sharedWork];
}

-(void)initTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated  {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            [self.mainTableView.footer endRefreshing];
        }
    }];
}

#pragma mark - netWork
-(void)asyMorePLList {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.parentid];
        //加密这个段数
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_string = [postEncryption stringWithPost:post_baseString];
        //post
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:kMorePLList];
        
        NSString *errorcode = [post_dic valueForKey:@"errorcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if ([errorcode intValue] == 0) {
                //解密
                //12-21
                NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                if (get_Dic.count != 0) {
                    
                    NSDictionary *get_jsonDic = [DDQPublic nullDic:get_Dic];
                    
                    _replyModel.iD             = [get_jsonDic valueForKey:@"id"];
                    _replyModel.pubtime        = [get_jsonDic valueForKey:@"pubtime"];
                    _replyModel.status         = [get_jsonDic valueForKey:@"status"];
                    _replyModel.text           = [get_jsonDic valueForKey:@"text"];
                    _replyModel.userid         = [get_jsonDic valueForKey:@"userid"];
                    _replyModel.userimg        = [get_jsonDic valueForKey:@"userimg"];
                    _replyModel.username       = [get_jsonDic valueForKey:@"username"];
                    
                    //12-21
                    for (NSDictionary *dic in get_jsonDic[@"son"]) {
                        NSDictionary *sonDic = [DDQPublic nullDic:dic];
                        
                        DDQSonModel *sonModel = [[DDQSonModel alloc] init];
                        sonModel.iD           = [sonDic valueForKey:@"id"];
                        sonModel.pubtime      = [sonDic valueForKey:@"pubtime"];
                        sonModel.text         = [sonDic valueForKey:@"text"];
                        sonModel.userid       = [sonDic valueForKey:@"userid"];
                        sonModel.userid2      = [sonDic valueForKey:@"userid2"];
                        sonModel.username     = [sonDic valueForKey:@"username"];
                        sonModel.wid          = [sonDic valueForKey:@"wid"];
                        sonModel.username2    = [sonDic valueForKey:@"username2"];
                        [self.child_array addObject:sonModel];
                    }
                    
                    self.mainTableView.tableHeaderView = [self setTableViewHeader:_replyModel];
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                    
                } else {
                    
                }
                
            } else {
                [self alertController:@"系统繁忙"];
            }
            
            
        });
        
    });
}

#pragma mark - headerView
-(UIView *)setTableViewHeader:(DDQReplyModel *)replyModel {

    UIView *backgroundView;
    //图片高度
    CGFloat imageH;
    if (kScreenHeight == 480) {
        _imageW = 30;
        imageH = 30;
    } else if (kScreenHeight == 568) {
        _imageW = 40;
        imageH = 40;
    } else {
        _imageW = 50;
        imageH = 50;
    }
    
    //详情
    CGRect introSize    = [replyModel.text boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    
    //回复二字
    NSString *replyStr  = @"回复";
    CGRect replySize    = [replyStr boundingRectWithSize:CGSizeMake(kScreenWidth, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    //背景view的frame
    CGFloat viewtop_H = 25+imageH+introSize.size.height+replySize.size.height;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewtop_H)];
    backgroundView.backgroundColor = [UIColor whiteColor];

    
    
    //控件布局
    UIImageView *imageView        = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, _imageW, imageH)];
    imageView.layer.cornerRadius  = imageH/2;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor     = [UIColor greenColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:replyModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [backgroundView addSubview:imageView];
    
    
    CGRect nicknameSize    = [replyModel.username boundingRectWithSize:CGSizeMake(kScreenWidth, imageH/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:3.0f]} context:nil];
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [backgroundView addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_centerY);
        make.width.offset(nicknameSize.size.width);
        make.height.offset(nicknameSize.size.height);
        make.left.equalTo(imageView.mas_right).offset(5);
    }];
    nicknameLabel.text     = replyModel.username;
    nicknameLabel.font     = [UIFont systemFontOfSize:14.0f weight:2.0f];
    
    
    CGRect pubtimeSize    = [replyModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, imageH/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    UILabel *pubtimeLabel = [[UILabel alloc] init];
    [backgroundView addSubview:pubtimeLabel];
    [pubtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_centerY);
        make.width.offset(pubtimeSize.size.width);
        make.height.offset(pubtimeSize.size.height);
        make.left.equalTo(nicknameLabel.mas_left);
    }];
    pubtimeLabel.text     = replyModel.pubtime;
    pubtimeLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    
    UILabel *introLabel  = [[UILabel alloc] initWithFrame:CGRectMake(5+imageH, 15+imageH, introSize.size.width, introSize.size.height)];
    [backgroundView addSubview:introLabel];
    introLabel.text      = replyModel.text;
    introLabel.font      = [UIFont systemFontOfSize:16.0f];
    
    UIImageView *replyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    replyImage.image        = [UIImage imageNamed:@"reply"];
    
   
    UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, replySize.size.width, replySize.size.height)];
    replyLabel.text     = replyStr;
    replyLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    //评论view
    UIView *replyView   = [[UIView alloc] init];
    [backgroundView addSubview:replyView];
    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(replyImage.frame.size.width + replyLabel.frame.size.height);
        make.height.offset(replyLabel.frame.size.height);
        make.right.equalTo(backgroundView.mas_right).offset(-20);
        make.top.equalTo(introLabel.mas_bottom).offset(5);
    }];
    
    [replyView addSubview:replyLabel];
    [replyView addSubview:replyImage];
    
    UITapGestureRecognizer *reply_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClickMethod:)];
    [replyView addGestureRecognizer:reply_tap];
    
    
    UIImageView *thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    
    if ([self.replyModel.status intValue]!= 0) {
        
        thumbImage.image = [UIImage imageNamed:@"is_praised_item"];
        
    } else {
        
        thumbImage.image = [UIImage imageNamed:@"praise"];

    }
    
    NSString *thumbStr  = @"点赞";
    CGRect thumbRect    = [thumbStr boundingRectWithSize:CGSizeMake(kScreenWidth, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    UILabel *thumbLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, thumbRect.size.width, thumbRect.size.height)];
    thumbLabel.text     = thumbStr;
    thumbLabel.font     = [UIFont systemFontOfSize:12.0f];
    
    UITapGestureRecognizer *thumb_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    
    //点赞view
    UIView *thumbView   = [[UIView alloc] init];
    [backgroundView addSubview:thumbView];
    [thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(thumbImage.frame.size.width + thumbLabel.frame.size.height);
        make.height.offset(thumbLabel.frame.size.height);
        make.right.equalTo(replyView.mas_left).offset(-20);
        make.centerY.equalTo(replyView.mas_centerY);
    }];
    [thumbView addGestureRecognizer:thumb_tap];
    [thumbView addSubview:thumbImage];
    [thumbView addSubview:thumbLabel];
    
    return backgroundView;
}

-(void)viewDidAppear:(BOOL)animated  {

    [super viewDidAppear:YES];
    [self.mainTableView reloadData];
}

-(void)replyClickMethod:(UITapGestureRecognizer *)tap {

	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] intValue] > 0) {
		
		DDQReplayViewController *replayVC = [[DDQReplayViewController alloc] init];
		replayVC.wenzhangId  = self.wid;
		replayVC.beiPLUserId = _replyModel.userid;
		replayVC.fathPLId    = _replyModel.iD;
		[self.navigationController pushViewController:replayVC animated:YES];
		
	} else {
	
		DDQLoginViewController *loginC = [[DDQLoginViewController alloc] init];
		loginC.hidesBottomBarWhenPushed = YES;
		
		[self.navigationController pushViewController:loginC animated:YES];
	}
	
	
}


-(void)changeImage:(UITapGestureRecognizer *)tap {

	UIImageView *imageView = (UIImageView *)[tap view];
	if ([self.replyModel.status intValue] == 0) {
		
		[self.netWork asyPOSTWithAFN_url:kAddZan andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @"2", self.replyModel.iD] andSuccess:^(id responseObjc, NSError *code_error) {
			
			if (!code_error) {
				
				imageView.image = [UIImage imageNamed:@"is_praised_item"];
				self.replyModel.status = @"1";
				[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"点赞成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
				
			} else {
				
				NSInteger code = code_error.code;
				if (code == 10 || code == 14) {
					
					DDQLoginViewController *loginC = [[DDQLoginViewController alloc] init];
					loginC.hidesBottomBarWhenPushed = YES;
					
					[self.navigationController pushViewController:loginC animated:YES];
					
				} else if (code == 15 || code == 16){
					
					if (code == 15) {
						
						[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"该评论不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
						
					} else {
						
						[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"你已赞过该评论" andShowDim:NO andSetDelay:YES andCustomView:nil];
						
					}
					
				} else {
					
					[MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
					
				}
				
			}
			
		} andFailure:^(NSError *error) {
			
			[MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
			
		}];
		
		
	} else {
		
		[self.netWork asyPOSTWithAFN_url:kDelZan andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @"2", self.replyModel.iD] andSuccess:^(id responseObjc, NSError *code_error) {
			
			if (!code_error) {
				
				imageView.image = [UIImage imageNamed:@"praise"];
				self.replyModel.status = @"0";
				[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"取消点赞" andShowDim:NO andSetDelay:YES andCustomView:nil];
				
			} else {
				
				NSInteger code = code_error.code;
				if (code == 10 || code == 14) {
					
					DDQLoginViewController *loginC = [[DDQLoginViewController alloc] init];
					loginC.hidesBottomBarWhenPushed = YES;
					
					[self.navigationController pushViewController:loginC animated:YES];
					
				} else if (code == 15 || code == 16){
					
					if (code == 15) {
						
						[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"该评论不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
						
					} else {
						
						[MBProgressHUD myCustomHudWithView:self.view andCustomText:@"你已赞过该评论" andShowDim:NO andSetDelay:YES andCustomView:nil];
						
					}
					
				} else {
					
					[MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
					
				}
				
			}
			
		} andFailure:^(NSError *error) {
			
			[MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
			
		}];
		
	}

	
//    if ([self.replyModel.status intValue] == 0) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            //调用点赞接口
//            //八段
//            NSString *spellString = [SpellParameters getBasePostString];
//            
//            //拼参数
//            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"2",self.replyModel.iD];
//            
//            //加密
//            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
//            NSString *post_encryption = [post stringWithPost:post_baseString];
//            
//            //传
//            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kAddZan];
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                //判断errorcode
//                NSString *errorcode = post_dic[@"errorcode"];
//                int num = [errorcode intValue];
//                if (num == 0) {
//                    
//                    UIView *tap_view = [tap view];
//                    for (UIView *view in tap_view.subviews) {
//                        
//                        if ([view isKindOfClass:[UIImageView class]]) {
//                            
//                            [(UIImageView *)view setImage:[UIImage imageNamed:@"is_praised_item"]];
//                        }
//                    }
//                    [self alertController:@"点赞成功"];
//                    self.replyModel.status = @"1";
//                    
//                } else if (num == 14) {
//                    
//                    [self alertController:@"您还未登录，无法评价"];
//                    
//                } else if (num == 16) {
//                    
//                    [self alertController:@"您已经赞过了！"];
//                    
//                } else {
//                    
//                    [self alertController:@"系统繁忙"];
//                }
//            });
//        });
//    } else {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            //调用点赞接口
//            //八段
//            NSString *spellString = [SpellParameters getBasePostString];
//            
//            //拼参数
//            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"2",self.replyModel.iD];
//            
//            //加密
//            DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
//            NSString *post_encryption = [post stringWithPost:post_baseString];
//            
//            //传
//            NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kDelZan];
//			
//            dispatch_async(dispatch_get_main_queue(), ^{
//				
//                //判断errorcode
//                NSString *errorcode = post_dic[@"errorcode"];
//                int num = [errorcode intValue];
//                if (num == 0) {
//                    
//                    UIView *tap_view = [tap view];
//                    for (UIView *view in tap_view.subviews) {
//                        
//                        if ([view isKindOfClass:[UIImageView class]]) {
//                            
//                            [(UIImageView *)view setImage:[UIImage imageNamed:@"praise"]];
//                        }
//                    }
//                    [self alertController:@"取消点赞"];
//                    
//                    self.replyModel.status = @"0";
//                } else if (num == 14) {
//                    
//                    [self alertController:@"您还未登录，无法评价"];
//                    
//                } else if (num == 16) {
//                    
//                    [self alertController:@"文章/评论不存在或已被删除"];
//                    
//                } else {
//                    
//                    [self alertController:@"系统繁忙"];
//                }
//            });
//        });
//        
//        
//    }

}

#pragma mark - delegate and datasource
static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQSonModel *sonModel;
    if (self.child_array.count != 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

       sonModel = self.child_array[indexPath.row];
        //首先全拼到一起去
        NSAttributedString *firstname  = [[NSAttributedString alloc] initWithString:sonModel.username attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        NSAttributedString *secondname = [[NSAttributedString alloc] initWithString:sonModel.username2 attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        
        NSString *totalString                    = [NSString stringWithFormat:@"%@ 回复 %@ :%@",sonModel.username,sonModel.username2,sonModel.text];
        NSMutableAttributedString * total_String = [[NSMutableAttributedString alloc] initWithString:totalString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        [total_String replaceCharactersInRange:NSMakeRange(0, sonModel.username.length) withAttributedString:firstname];
        [total_String replaceCharactersInRange:NSMakeRange(sonModel.username.length + 4, sonModel.username2.length) withAttributedString:secondname];
        //然后计算
        CGRect totalRect = [totalString boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width - _imageW,kScreenHeight)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
        
        CGRect pubtimeRect = [sonModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
        
        //计算新的cell高度
        self.new_cellHeight = 25+totalRect.size.height+pubtimeRect.size.height;
        
//        if (!cell) {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UILabel *intro_label = [[UILabel alloc] init];
            
            //        intro_label.frame    = CGRectMake(0, 0, totalRect.size.width, totalRect.size.height);
            intro_label.tag      = 1;
            [cell.contentView addSubview:intro_label];
            [intro_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(_imageW);
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
                make.height.offset(totalRect.size.height);
                make.top.equalTo(cell.contentView.mas_top).offset(5);
            }];
            
            UIView *line_view = [[UIView alloc] init];
            [cell.contentView addSubview:line_view];
            [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(intro_label.mas_left);
                make.right.equalTo(cell.contentView.mas_right);
                make.height.offset(1);
            }];
            line_view.backgroundColor = [UIColor backgroundColor];
            
            UILabel *pubTimeLabel = [[UILabel alloc] init];
            //        pubTimeLabel.frame    = CGRectMake(0, 50-intro_label.frame.size.height-5, pubtimeRect.size.width, pubtimeRect.size.height);
            pubTimeLabel.tag      = 2;
            [cell.contentView addSubview:pubTimeLabel];
            [pubTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(intro_label.mas_left);
                make.width.offset(pubtimeRect.size.width);
                make.top.equalTo(intro_label.mas_bottom).offset(10);
                make.height.offset(pubtimeRect.size.height);
            }];
//        }
//        UILabel *intro_label1       = (UILabel *)[cell viewWithTag:1];
        intro_label.attributedText = total_String;
        intro_label.font           = [UIFont systemFontOfSize:12.0f];
        intro_label.numberOfLines  = 0;
        
//        UILabel *pubTimeLabel1      = (UILabel *)[cell viewWithTag:2];
        pubTimeLabel.text           = sonModel.pubtime;
        pubTimeLabel.font           = [UIFont systemFontOfSize:12.0f];
        //    DDQCommentSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        //
        //
        //    DDQReplyModel *replyModel = [self.cell_sourceArray objectAtIndex:indexPath.row];
        //    secondCell = [[DDQCommentSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //    [secondCell cellWithReplyModel:replyModel];
        //    
        //    secondCell.backgroundColor       = [UIColor whiteColor];
        //    secondCell.selectionStyle        = UITableViewCellSelectionStyleNone;
        return cell;


    }else {
    //计算评论的长度
    
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.child_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.new_cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQSonModel *sonModel;
    if (self.child_array.count != 0) {
        
        sonModel = self.child_array[indexPath.row];
        DDQReplayViewController *replayVC = [[DDQReplayViewController alloc] init];
        replayVC.wenzhangId  = self.wid;
        replayVC.beiPLUserId = sonModel.userid;
        replayVC.fathPLId    = sonModel.iD;
        [self.navigationController pushViewController:replayVC animated:YES];
    }
}


-(void)alertController:(NSString *)message {
    
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}
@end
