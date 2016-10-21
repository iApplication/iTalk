//
//  MessageCollectionViewCell.h
//  iTalk
//
//  Created by locky1218 on 15-4-14.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * userImageView;
@property (nonatomic, strong) UILabel * labelUserName;
@property (nonatomic, strong) UILabel * labelLastMsg;
@property (nonatomic, strong) UILabel * labelLastMsgTime;

- (void)reAlignLayout;//重新调整控件位置

@end
