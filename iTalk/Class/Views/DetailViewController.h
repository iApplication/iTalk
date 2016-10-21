//
//  DetailViewController.h
//  iTalk
//
//  Created by locky1218 on 15-4-2.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController: UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backTap:(UIButton *)sender;

- (IBAction)closeKeyboard:(UITextField *)sender;
@property (strong, nonatomic) NSMutableArray * msgs;
@property (strong, nonatomic) NSString * usernameStr;//与他的对话
@property (weak, nonatomic) IBOutlet UILabel *thatUsernameLabel;
- (IBAction)editBegin:(UITextField *)sender;
- (IBAction)editEnd:(UITextField *)sender;
- (IBAction)sendTap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *msgText;
@end
