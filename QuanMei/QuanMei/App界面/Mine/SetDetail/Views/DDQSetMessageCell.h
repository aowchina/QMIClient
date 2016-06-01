//
//  DDQSetMessageCell.h
//  QuanMei
//
//  Created by min-fo013 on 15/10/15.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DDQSetMessageCellDelegate;

@interface DDQSetMessageCell : UITableViewCell

@property (nonatomic, weak) id<DDQSetMessageCellDelegate>delegate;
@property (nonatomic, copy) NSString *title;

@end

@protocol  DDQSetMessageCellDelegate<NSObject>

@optional

- (void)DDQSettingCell:(DDQSetMessageCell *)cell DidChangeSwitchState:(BOOL)switchState;

@end