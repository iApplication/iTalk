//
//  MessageTableViewController.h
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController

- (void)showNumber;

@property (strong, nonatomic) NSMutableArray * msgs;
@end
