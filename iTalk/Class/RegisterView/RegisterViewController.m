//
//  RegisterViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-31.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameText, userpwdText;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //头像
    UIImageView * personImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-98)/2, 40, 98, 98)];
    personImageView.image = [UIImage imageNamed:@"person.png"];
    [self.view addSubview:personImageView];
    
    //账号
    UILabel * usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 158, 80, 40)];
    usernameLabel.text = @"账号:";
    usernameLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:usernameLabel];
    
    usernameText = [[UITextField alloc]initWithFrame:CGRectMake(120, 158, SCREENWIDTH-140, 40)];
    usernameText.placeholder = @"输入您的账号";
    [usernameText addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:usernameText];
    
    //密码
    UILabel * userpwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 218, 80, 40)];
    userpwdLabel.text = @"密码:";
    userpwdLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:userpwdLabel];
    
    userpwdText = [[UITextField alloc]initWithFrame:CGRectMake(120, 218, SCREENWIDTH-140, 40)];
    userpwdText.placeholder = @"输入您的密码";
    userpwdText.secureTextEntry = YES;
    [userpwdText addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:userpwdText];
    
    //注册按钮
    UIButton * registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 278, SCREENWIDTH-40, 40)];
    registerBtn.backgroundColor = [UIColor greenColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:36];
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    //返回按钮
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 338, SCREENWIDTH-40, 40)];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:36];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)registerTap:(UIButton *)sender
{
    //数据验证
    NSString * username = usernameText.text;
    NSString * userpwd = userpwdText.text;
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userpwd = [userpwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([username isEqualToString:@""])
    {
        [LJUtil alert:@"账号不能为空"];
        usernameText.text = @"";
        [usernameText becomeFirstResponder];
        return;
    }
    if([userpwd isEqualToString:@""])
    {
        [LJUtil alert:@"密码不能为空"];
        userpwdText.text = @"";
        [userpwdText becomeFirstResponder];
        return;
    }
    
    //判断一下网络
    Reachability * ipReachable = [Reachability reachabilityWithHostName:DOMAIN_NAME];
    NetworkStatus status = [ipReachable currentReachabilityStatus];
    if(NotReachable == status)
    {
        [LJUtil alert:@"没有有效网络连接"];
        return;
    }
    
    //进行注册
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;//获得当前应用程序的代理，是单例的
    app.isRegister = YES;
    [app connectWithUserName:username andUserPassword:userpwd];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.usernameText.text = self.usernameStr;
    self.userpwdText.text = self.userpwdStr;
}

- (void)closeKeyboard:(id)sender
{
    
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
