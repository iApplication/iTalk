//
//  AddFriendViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-4.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "AddFriendViewController.h"
#import "FriendsAddressBookViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initviews];
}

- (void)initviews
{
    //背景颜色
    self.view.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    
    //导航栏左侧按钮
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navigationbar_back-1"] forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    [btnCancel addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = bbi;
    
    //导航栏标题
    self.title = @"添加好友";
    
    //导航栏字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:COLOR_NAVIGATION_TITLE}];
    
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

- (void)cancelTap:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)addTap:(UIButton *)sender {
    NSString * strUsername = self.usernameText.text;
    strUsername = [LJUtil trim:strUsername];
    if([strUsername isEqualToString:@""])
    {
        [LJUtil alert:@"账号不能为空"];
        self.usernameText.text = @"";
        [self.usernameText becomeFirstResponder];
        return;
    }
    //判定是否是服务器端有效的用户名
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/italk/users/findusers?id=%@", strUsername]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(nil == data)
    {
        [LJUtil alert:@"无法验证账号有效性，请稍后再试"];
        return;
    }
    else
    {
        NSString * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(array)//存在用户，则添加用户
        {
            [self.friendAddressBookViewController addFriend:strUsername];
            [LJUtil alert:@"好友添加成功"];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            [LJUtil alert:@"无此用户"];
        }
    }
}
@end
