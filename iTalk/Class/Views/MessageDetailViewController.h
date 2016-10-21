//
//  MessageDetailViewController.h
//  iTalk
//
//  Created by locky1218 on 15-4-24.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)backTap:(UIButton *)sender;
- (IBAction)sendTap:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *thatUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)editBegin:(UITextField *)sender;
- (IBAction)editEnd:(UITextField *)sender;
- (IBAction)closeKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelNavigation;

@property (strong, nonatomic) NSMutableArray * msgs;
@property (strong, nonatomic) NSString * strUsername;//与他的对话
@end
