//
//  LoginViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LoginViewController.h"
#import "MessageTableViewController.h"
#import "FriendsTableViewController.h"
#import "NewsTableViewController.h"
#import "SettingTableViewController.h"
#import "RegisterViewController.h"
#import "LoginSettingViewController.h"
#import "LoginSettingTableViewController.h"

#import "LJTabBarController.h"

@interface LoginViewController ()

@end

#define IMAGEVIEWNAMEPWD_LEFT (SCREENWIDTH-imageNameAndPwd.size.width*2)/2  //用户名密码view左坐标
#define IMAGEVIEWNAMEPWD_TOP SCREENHEIGHT/3                                 //用户名密码view上坐标



#define LABELUSERNAME_LEFT 45
#define LABELUSERNAME_TOP 15
#define LABELUSERPWD_LEFT 45
#define LABELUSERPWD_TOP  63
#define LABELNAMEPWD_WIDTH 177 //输入框宽度
#define LABELNAMEPWD_HEIGHT 35  //输入框高度

#define BTNREMEMBER_WIDTH 16  //记住密码按钮宽度
#define BTNREMEMBER_HEIGHT 16 //记住密码按钮高度


#define COLORBLACKWHITE [UIColor colorWithRed:62.0/255.0 green:40.0/255.0 blue:4.0/255.0 alpha:1]


@implementation LoginViewController

@synthesize usernameText, userpwdText;
@synthesize registerViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self initviews];
    
}

//初始化界面上的控件
- (void)initviews
{
    //背景图片
    UIImage * mainbgImage = [UIImage imageWithName:@"mainbg"];
    [mainbgImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView * mainbgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    mainbgView.image = mainbgImage;
    [self.view addSubview:mainbgView];
    [self.view sendSubviewToBack:mainbgView];
    
    
    //商标
    /*UIImage * italkImage = [UIImage imageNamed:@"italkIcon"];
     UIImageView * italkImageView = [[UIImageView alloc]initWithImage:italkImage];
     italkImageView.frame = CGRectMake((SCREENWIDTH-italkImage.size.width*2)/2, IMAGEVIEWNAMEPWD_TOP-italkImage.size.height*2-20, italkImage.size.width*2, italkImage.size.height*2);
     [self.view addSubview:italkImageView];*/
    
    
    //账号密码输入框
    UIImage * imageNameAndPwd = [UIImage imageWithName:@"viewNameAndPwd"];
    imageNameAndPwd = [imageNameAndPwd stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView * imageViewNameAndPwd = [[UIImageView alloc]initWithFrame:CGRectMake(IMAGEVIEWNAMEPWD_LEFT, IMAGEVIEWNAMEPWD_TOP, imageNameAndPwd.size.width*2, imageNameAndPwd.size.height*2)];
    imageViewNameAndPwd.image = imageNameAndPwd;
    [self.view addSubview:imageViewNameAndPwd];
    
    //账号
    usernameText = [[UITextField alloc]initWithFrame:CGRectMake(IMAGEVIEWNAMEPWD_LEFT+LABELUSERNAME_LEFT, IMAGEVIEWNAMEPWD_TOP+LABELUSERNAME_TOP, LABELNAMEPWD_WIDTH, LABELNAMEPWD_HEIGHT)];
    usernameText.placeholder = @"输入您的账号";
    usernameText.font = [UIFont systemFontOfSize:LABELNAMEPWD_HEIGHT-17];
    usernameText.textColor = [UIColor blackColor];
    [usernameText addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:usernameText];
    
    //密码
    userpwdText = [[UITextField alloc]initWithFrame:CGRectMake(IMAGEVIEWNAMEPWD_LEFT+LABELUSERPWD_LEFT, IMAGEVIEWNAMEPWD_TOP+LABELUSERPWD_TOP, LABELNAMEPWD_WIDTH, LABELNAMEPWD_HEIGHT)];
    userpwdText.placeholder = @"输入您的密码";
    userpwdText.secureTextEntry = YES;
    userpwdText.font = [UIFont systemFontOfSize:LABELNAMEPWD_HEIGHT-17];
    userpwdText.textColor = [UIColor blackColor];
    [userpwdText addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:userpwdText];
    
    //登录按钮
    UIImage * imageBtnLogin = [UIImage imageWithName:@"btnlogin"];
    imageBtnLogin = [imageBtnLogin stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    CGFloat fbtnlogin_left = SCREENWIDTH-IMAGEVIEWNAMEPWD_LEFT-imageBtnLogin.size.width*2-10;
    CGFloat fbtnlogin_top = IMAGEVIEWNAMEPWD_TOP+imageNameAndPwd.size.height*2+10;
    CGFloat fbtnlogin_width = imageBtnLogin.size.width*2;
    CGFloat fbtnlogin_height = imageBtnLogin.size.height*2;
    UIButton * loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(fbtnlogin_left, fbtnlogin_top, fbtnlogin_width, fbtnlogin_height)];
    [loginBtn setBackgroundImage:imageBtnLogin forState:UIControlStateNormal];
    //loginBtn.titleLabel.textColor = COLORBLACK;
    //[loginBtn.titleLabel setFrame:CGRectMake(0, 17, fbtnlogin_width, fbtnlogin_height)];
    //loginBtn.titleLabel.font = [UIFont systemFontOfSize:fbtnlogin_height-10];
    //[loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    //[loginBtn setTitleColor:COLORBLACK forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //记住密码
    CGFloat fbtnremember_left = IMAGEVIEWNAMEPWD_LEFT;
    CGFloat fbtnremember_top = fbtnlogin_top+fbtnlogin_height+20;
    rememberBtn = [[UIButton alloc]initWithFrame:CGRectMake(fbtnremember_left, fbtnremember_top, BTNREMEMBER_WIDTH, BTNREMEMBER_HEIGHT)];
    [rememberBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [rememberBtn addTarget:self action:@selector(rememberTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberBtn];
    
    UILabel * rememberLabel = [[UILabel alloc]initWithFrame:CGRectMake(fbtnremember_left+BTNREMEMBER_WIDTH+5, fbtnremember_top, 180, BTNREMEMBER_HEIGHT)];
    rememberLabel.text = @"记住密码";
    rememberLabel.font = [UIFont systemFontOfSize:18];
    rememberLabel.textColor = COLORBLACKWHITE;
    [self.view addSubview:rememberLabel];
    
    //注册按钮
    CGFloat fbtnregister_left = IMAGEVIEWNAMEPWD_LEFT;
    CGFloat fbtnregister_top = fbtnremember_top+50;
    CGFloat fbtnregister_width = SCREENWIDTH-fbtnremember_left*2;
    CGFloat fbtnregister_height = 20;
    UIButton * registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(fbtnregister_left, fbtnregister_top, fbtnregister_width, fbtnregister_height)];
    [registerBtn setTitle:@"还没加入我们？点这里注册吧！" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:fbtnregister_height-4];
    [registerBtn setTitleColor:COLORBLACKWHITE forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //设置按钮
    UIImage * imageBtnSetting = [UIImage imageWithName:@"btnsetting"];
    //imageBtnSetting = [imageBtnSetting stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    CGFloat fbtnsetting_width = imageBtnSetting.size.width*2;
    CGFloat fbtnsetting_height = imageBtnSetting.size.height*2;
    CGFloat fbtnsetting_left = SCREENWIDTH-fbtnsetting_width-30;
    CGFloat fbtnsetting_top = SCREENHEIGHT-fbtnsetting_height-30;
    UIButton * btnSetting = [[UIButton alloc]initWithFrame:CGRectMake(fbtnsetting_left, fbtnsetting_top, fbtnsetting_width, fbtnsetting_height)];
    //NSLog(@"%d, %d, %d, %d", fbtnsetting_left, fbtnsetting_top, fbtnsetting_width, fbtnsetting_height);
    [btnSetting setBackgroundImage:imageBtnSetting forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(settingTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSetting];
}

#pragma mark -- button tap
//设置界面
- (void)settingTap:(UIButton *)sender
{
    //self.loginSettingViewController = [[LoginSettingViewController alloc]init];
    //[self presentViewController:self.loginSettingViewController animated:NO completion:nil];
    
    LoginSettingTableViewController * root = [[LoginSettingTableViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:root];
    [self presentViewController:nav animated:NO completion:nil];


}

- (void)rememberTap:(UIButton *)sender
{
    if(NO == isRememberPwd)
    {
        [rememberBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        isRememberPwd = YES;
    }
    else
    {
        [rememberBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        isRememberPwd = NO;
    }
}

- (void)loginTap:(UIButton* )sender
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
    
    //连接登录
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;//获得当前应用程序的代理，是单例的
    app.isRegister = NO;
    [app connectWithUserName:username andUserPassword:userpwd];
    
}

- (void)registerTap:(UIButton* )sender
{
    self.registerViewController = [[RegisterViewController alloc]init];
    //self.registerViewController.usernameText.text = self.usernameText.text;
    //self.registerViewController.userpwdText.text = self.userpwdText.text;
    self.registerViewController.usernameStr = self.usernameText.text;
    self.registerViewController.userpwdStr = self.userpwdText.text;
    [self presentViewController:self.registerViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeKeyboard:(id)sender
{
    
}

- (void)showMainView
{
    LJTabBarController * mainTabBarView = [[LJTabBarController alloc]init];
    [self presentViewController:mainTabBarView animated:NO completion:nil];
    /*
    //微信-消息
    MessageTableViewController * messageViewController = [[MessageTableViewController alloc]initWithStyle:UITableViewStylePlain];
    messageViewController.title = @"消息";
    messageViewController.tabBarItem.image = [UIImage imageNamed:@"tab1.png"];
    //messageViewController.tabBarItem.badgeValue = @"100";
    [LJUtil setMessageView:messageViewController];
    UINavigationController * messageNav = [[UINavigationController alloc]initWithRootViewController:messageViewController];
    
    //通讯录-好友
    FriendsTableViewController * firendsViewController = [[FriendsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    firendsViewController.title = @"好友";
    //firendsViewController.tabBarItem.image = [UIImage imageNamed:@"tab1.png"];
    [firendsViewController.tabBarItem setImage:[UIImage imageNamed:@"tab1.png"]];
    UINavigationController * friendsNav = [[UINavigationController alloc]initWithRootViewController:firendsViewController];
    
    //发现
    NewsTableViewController * newsViewController = [[NewsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    newsViewController.title = @"发现";
    newsViewController.tabBarItem.image = [UIImage imageNamed:@"tab1.png"];
    UINavigationController * newsNav = [[UINavigationController alloc]initWithRootViewController:newsViewController];
    
    //我-设置
    SettingTableViewController * settingViewController = [[SettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    settingViewController.title = @"设置";
    settingViewController.tabBarItem.image = [UIImage imageNamed:@"tab4.png"];
    UINavigationController * settingNav = [[UINavigationController alloc]initWithRootViewController:settingViewController];
    
    UITabBarController * tab = [[UITabBarController alloc]init];
    [tab setViewControllers:[NSArray arrayWithObjects:messageNav, friendsNav, newsNav, settingNav, nil]];
    [self presentViewController:tab animated:NO completion:nil];
     */
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
