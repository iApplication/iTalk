//
//  AddFriendViewController.h
//  iTalk
//
//  Created by locky1218 on 15-4-4.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsAddressBookViewController;

@interface AddFriendViewController : UIViewController
- (IBAction)cancelTap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
- (IBAction)addTap:(UIButton *)sender;

@property (strong, nonatomic) FriendsAddressBookViewController * friendAddressBookViewController;

@end
