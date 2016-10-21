//
//  LoginSettingTableViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LoginSettingTableViewController.h"
#import "LoginSettingServerViewController.h"
#import "LJTabBarController.h"

@interface LoginSettingTableViewController ()

@end

@implementation LoginSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initviews];
    
    [self initdatas];
}

//初始化控件
- (void)initviews
{
    self.tableView.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    //导航栏
    self.title = @"登录设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:COLOR_NAVIGATION_TITLE}];
    
    //导航栏背景
    UIImage * imageNavBg = [UIImage imageNamed:@"navigationbarbackground"];
    imageNavBg = [imageNavBg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.navigationController.navigationBar setBackgroundImage:imageNavBg forBarMetrics:UIBarMetricsDefault];
    
    //导航栏左侧按钮
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navigationbar_back-1"] forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    [btnCancel addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = bbi;
}

//初始化table数据
- (void)initdatas
{
    self.settings = [[NSMutableArray alloc]initWithCapacity:100];
    NSString * str = @"服务器地址";
    [self.settings addObject:str];
    str = @"跳过登录";
    [self.settings addObject:str];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button taps
//取消按键
- (void)cancelTap:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
   
    cell.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    cell.textLabel.text = self.settings[indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.settings[indexPath.row] isEqualToString:@"服务器地址"])
    {
        LoginSettingServerViewController * server = [[LoginSettingServerViewController alloc]init];
        [self.navigationController pushViewController:server animated:NO];
    }
    else if ([self.settings[indexPath.row] isEqualToString:@"跳过登录"])
    {
        //认证成功后把用户名设为全局
        [LJUtil setUsername:@"_Anonymity_"];
        [LJUtil setUserpwd:@"123456"];
        
        LJTabBarController * mainTabBarView = [[LJTabBarController alloc]init];
        [self presentViewController:mainTabBarView animated:NO completion:nil];
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
