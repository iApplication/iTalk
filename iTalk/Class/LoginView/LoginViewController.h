//
//  LoginViewController.h
//  iTalk
//
//  Created by locky1218 on 15-3-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"

@class LoginSettingViewController;

@interface LoginViewController : UIViewController
{
    BOOL isRememberPwd;//是否记住账号
    UIButton * rememberBtn;//记住按钮
    UITextField * usernameText;//用户名输入框
    UITextField * userpwdText;//密码输入框
}

@property (strong, nonatomic)RegisterViewController * registerViewController;

@property (strong, nonatomic)LoginSettingViewController * loginSettingViewController;

@property (strong, nonatomic)UITextField * usernameText;//用户名输入框

@property (strong, nonatomic)UITextField * userpwdText;//密码输入框

- (void)showMainView;

@end
