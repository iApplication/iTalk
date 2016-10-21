//
//  LoginSettingServerViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LoginSettingServerViewController.h"

@interface LoginSettingServerViewController ()

@end

@implementation LoginSettingServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initviews];
}

- (void)initviews
{
    //导航栏标题
    self.title = @"服务器设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
        @{NSFontAttributeName:[UIFont systemFontOfSize:20],
          NSForegroundColorAttributeName:COLOR_NAVIGATION_TITLE}];

    
    //导航栏左侧按钮
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navigationbar_back-1"] forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    [btnCancel addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = bbi;
    
    //导航栏右侧按钮
    UIButton * btnSave = [UIButton buttonWithType:UIButtonTypeSystem];
    btnSave.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * bbi2 = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveTap:)];
    bbi2.tintColor = COLOR_NAVIGATION_TITLE;
    self.navigationItem.rightBarButtonItem = bbi2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)saveTap:(UIButton *)sender
{
    //设置服务器地址
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setHostName:self.textfieldServer.text];
    
    //页面pop
    [self.navigationController popViewControllerAnimated:NO];
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
