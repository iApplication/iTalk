//
//  LJTabBarController.m
//  TabBarDemo
//
//  Created by locky1218 on 15-4-12.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LJTabBarController.h"

#import "UIImage+WB.h"
#import "LJTabBar.h"
#import "LJNavigationController.h"
#import "KLComment.h"

#import "MessageViewController.h"
#import "NewsTableViewController.h"
#import "SettingTableViewController.h"
#import "FriendsAddressBookViewController.h"
#import "FriendsAddressBookViewController2.h"
#import "FriendsTableViewController.h"

@interface LJTabBarController ()<LJTabbarDekegate>
@property (nonatomic, weak) LJTabBar *customTabBar;
@property (nonatomic, weak) MessageViewController *messageViewController;
@property (nonatomic, weak) SettingTableViewController *settingViewController;
@end

@implementation LJTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化tabbar
    [self setupTabBar];
    
    // 初始化所以子控制器
    [self setupAllChildViewControls];
}

- (void)setupTabBar
{
    LJTabBar *customTabBar = [[LJTabBar alloc]init];
    customTabBar.delegate = self;
    customTabBar.frame = self.tabBar.bounds;
    //设置背景图片
    UIImage * tabbarImage = [UIImage imageWithName:@"tabbarbackground"];
    tabbarImage = [tabbarImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.tabBar setBackgroundImage:tabbarImage];
    
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

// tabbar代理方法 点击了哪个
- (void)tabBar:(LJTabBar *)tabBar didSelectedButtonfrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
    
    if (to == 3) { // 点击更多
        //[self.home refreshData];
        // 传递数据
        //self.more.weatherInfo = self.life.weatherInfo;
    }
}

- (void)setupAllChildViewControls
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-49-20)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 首页控制器
    // 创建布局
    MessageViewController * messageViewController = [MessageViewController sharedMessageViewController];
    //home.tabBarItem.badgeValue = @"20";
    [self addChildViewControl:messageViewController title:@"消息" imageName:@"tabbaritem_message" selectedImageName:@"tabbaritem_message_selected"];
    self.messageViewController = messageViewController;
    
    
    // 联系人
    FriendsAddressBookViewController * friendViewController = [[FriendsAddressBookViewController alloc]init];
    //msg.tabBarItem.badgeValue = @"30";
    [self addChildViewControl:friendViewController title:@"好友" imageName:@"tabbaritem_friend" selectedImageName:@"tabbaritem_friend_selected"];
    
    // 团购控制器
    FriendsAddressBookViewController2 * newsViewController = [[FriendsAddressBookViewController2 alloc]init];
    //discover.tabBarItem.badgeValue = @"60";
    [self addChildViewControl:newsViewController title:@"发现" imageName:@"tabbaritem_news" selectedImageName:@"tabbaritem_news_selected"];
    
    // 更多控制器
    SettingTableViewController * settingViewController = [[SettingTableViewController alloc]init];
    //me.tabBarItem.badgeValue = @"80";
    [self addChildViewControl:settingViewController title:@"设置" imageName:@"tabbaritem_setting" selectedImageName:@"tabbaritem_setting_selected"];
    self.settingViewController = settingViewController;
    
}

/**
 *  添加子控制器
 *
 *  @param childVc           子控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 被选中图片
 */
- (void)addChildViewControl:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题图片
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    if (ios7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageWithName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else {
        childVc.tabBarItem.selectedImage = [UIImage imageWithName:selectedImageName];
    }
    
    // 添加到导航控制器
    LJNavigationController *childVcNav = [[LJNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:childVcNav];
    // 添加自定义item
    [self.customTabBar addButtonWithItem:childVc.tabBarItem];
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
