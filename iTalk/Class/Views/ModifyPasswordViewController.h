//
//  ModifyPasswordViewController.h
//  iTalk
//
//  Created by locky1218 on 15-4-4.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController
- (IBAction)backTap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *changePwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
- (IBAction)modifyTap:(UIButton *)sender;
- (IBAction)closeKeyboard:(id)sender;

@end
