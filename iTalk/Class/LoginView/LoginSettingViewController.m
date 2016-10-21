//
//  LoginSettingViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LoginSettingViewController.h"

@interface LoginSettingViewController ()

@end

@implementation LoginSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initviews];
}

- (void)initviews
{
    //导航栏背景
    UIImageView * viewTitleBarBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationbarbackground"]];
    viewTitleBarBg.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    [self.titleBar addSubview:viewTitleBarBg];
    [self.titleBar sendSubviewToBack:viewTitleBarBg];
    
    self.labelTitle.text = @"登录设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
