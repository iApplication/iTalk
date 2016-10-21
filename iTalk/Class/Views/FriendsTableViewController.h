//
//  FriendsTableViewController.h
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray * friendNames;

- (void)addFriend:(NSString *)_friendName;

@end
