//
//  RegisterViewController.h
//  iTalk
//
//  Created by locky1218 on 15-3-31.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    UITextField * usernameText;//用户名输入框
    UITextField * userpwdText;//密码输入框
}

@property (strong, nonatomic)UITextField * usernameText;//用户名输入框
@property (strong, nonatomic)UITextField * userpwdText;//密码输入框

@property (strong, nonatomic)NSString * usernameStr;
@property (strong, nonatomic)NSString * userpwdStr;

@end
