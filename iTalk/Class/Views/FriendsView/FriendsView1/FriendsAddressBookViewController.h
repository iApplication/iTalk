//
//  FriendsAddressBookViewController.h
//  iTalk
//
//  Created by locky1218 on 15-5-1.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsAddressBookViewController : UIViewController

@property (strong, nonatomic) NSMutableArray * friendNames;

- (void)addFriend:(NSString *)_friendName;

@end
