//
//  MessageDetailTableViewCell.h
//  iTalk
//
//  Created by locky1218 on 15-4-24.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIImageView *photo;

-(void)setContent:(LJMessages *)msg;

@end
