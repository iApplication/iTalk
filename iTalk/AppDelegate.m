//
//  AppDelegate.m
//  iTalk
//
//  Created by locky1218 on 15-3-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MessageViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize xmppStream;
@synthesize password, username;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    loginViewController = [[LoginViewController alloc]init];
    self.window.rootViewController = loginViewController;
    
    [self.window makeKeyAndVisible];
    
    xmppStream = [[XMPPStream alloc]init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //打开数据库
    //NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //NSString * documentsDirectory = [paths objectAtIndex:0];
    //documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"fmdb.db"];
    //NSLog(@"db path: %@", documentsDirectory);
    
    NSString * path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"fmdb.db"];
    NSLog(@"%@", path);
    self.fmdb = [FMDatabase databaseWithPath:path];
    BOOL result = [self.fmdb open];
    if(NO == result)
    {
        NSLog(@"打开数据库失败！");
        [LJUtil alert:@"打开数据库失败!"];
    }
    
    //创建表-消息表
    NSString * sql = @"create table if not exists messages(username text, time text, msg text, flag text, me text)";
    result = [self.fmdb executeUpdate:sql];
    if(NO == result)
    {
        NSLog(@"创建表失败");
        [LJUtil alert:@"创建表失败"];
    }
    
    //创建好友表
    sql = @"create table if not exists friends(username text, groupname text)";
    result = [self.fmdb executeUpdate:sql];
    if(NO == result)
    {
        NSLog(@"创建表失败");
        [LJUtil alert:@"创建表失败"];
    }
    
    //创建好友分组表
    sql = @"create table if not exists groups(name text)";
    result = [self.fmdb executeUpdate:sql];
    if(NO == result)
    {
        NSLog(@"创建表失败");
        [LJUtil alert:@"创建表失败"];
    }

    return YES;
}

#pragma mark Connect/disconnect

- (void)setHostName:(NSString *)hostname
{
    [xmppStream setHostName:hostname];//!!!不设，则默认本机
}

//登录连接服务器
- (BOOL)connectWithUserName:(NSString *)_username andUserPassword:(NSString *)_userpwd
{
    //check whethere it is already connected
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    //JID 用户名@域名
    NSString *myJID = [NSString stringWithFormat:@"%@@localhost", _username];
    NSString *myPassword = _userpwd;
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    
    //设置流中的JID
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    password = _userpwd;//保存密码，供后面用
    username = _username;//保存用户名，供全局使用
    
    //[xmppStream setHostName:DOMAIN_NAME];//!!!不设，则默认本机
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        [LJUtil alert:@"连接服务器失败!"];
        
        NSLog(@"Error connecting: %@", error);
        
        return NO;
    }
    
    //显示指示
    [SVProgressHUD showWithStatus:@"正在连接服务器..." maskType:SVProgressHUDMaskTypeBlack];
    
    return YES;
}

//断开与服务器的连接
- (void)disconnect
{
    NSLog(@"disconnect called!");
    [self goOffline];//发一个离线消息
    [xmppStream disconnect];//与服务器断开
}

#pragma mark XMPPStream delegate

//连接服务器成功事件，并没有去验证用户密码等
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接服务器成功！");
    
    if(NO == self.isRegister)//登录
    {
        [SVProgressHUD setStatus:@"正在登录..."];
        
        //isXmppConnected = YES;
        
        NSError *error = nil;
        
        //发送验证用户验证信息  JID之前已经设了
        if (![xmppStream authenticateWithPassword:password error:&error])
        {
            NSLog(@"无法验证用户信息: %@", error);
            [SVProgressHUD dismiss];
            if(error)//异常断开时候才显示，自己调用接口断开不显示
            {
                [LJUtil alert:@"无法验证用户信息"];
            }
        }
    }
    else//注册
    {
        [SVProgressHUD setStatus:@"正在注册..."];
        
        //isXmppConnected = YES;
        
        NSError *error = nil;
        
        //发送验证用户验证信息  JID之前已经设了
        if (![xmppStream registerWithPassword:password error:&error])
        {
            NSLog(@"无法注册用户: %@", error);
            [SVProgressHUD dismiss];
            if(error)//异常断开时候才显示，自己调用接口断开不显示
            {
                [LJUtil alert:@"无法注册用户"];
            }
        }
    }

    
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册有错误（%@）！", error);
    [SVProgressHUD dismiss];
    [LJUtil alert:@"当前用户注册失败，请更换用户名"];
    //断开连接，才能注册下一个用户
    [self disconnect];
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    [SVProgressHUD dismiss];
    [LJUtil alert:@"注册成功"];
    //断开连接，才能登录用户
    [self disconnect];
    
    //回到登录窗口
    [loginViewController.registerViewController dismissViewControllerAnimated:YES completion:nil];
    loginViewController.usernameText.text = loginViewController.registerViewController.usernameText.text;
    loginViewController.userpwdText.text = loginViewController.registerViewController.userpwdText.text;
    
}

//断开连接，并返回连接错误--我这边测试修改域名为错误域名会隔很长时间才会超时出错
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"断开连接（%@）！", error);
    [SVProgressHUD dismiss];
    if(error)//异常断开
    {
        [LJUtil alert:@"与服务器断开连接!"];
    }
    
}

//用户认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"用户认证成功");
    [self goOnline];//发送在线的消息
    [SVProgressHUD dismiss];
    
    //认证成功后把用户名设为全局
    [LJUtil setUsername:username];
    [LJUtil setUserpwd:password];
    
    //认证成功后显示聊天界面
    [loginViewController showMainView];
}

//用户认证失败-密码错误等原因
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"用户认证失败");
    [self disconnect];//认证失败要断开连接,否则下一次无法连接上了
    [SVProgressHUD dismiss];
    [LJUtil alert:@"登录失败，请检查用户名密码!"];
}

//给服务器端发送一个有效用户信息
- (void)goOnline
{
    //创建一个在线对象
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    [[self xmppStream] sendElement:presence];
}

//离线
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

//获得离线消息的时间
- (NSDate *)getDelayStampTime:(XMPPMessage *)_message
{
    //获得xml中的delay标签
    XMPPElement * delay = (XMPPElement *)[_message elementForName:@"delay"];
    if(delay)//如果有说明是离线消息
    {
        //获得时间戳
        NSString * timeString = [[(XMPPElement *)[_message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //获得格式化对象
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间的具体格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSArray * arr = [timeString componentsSeparatedByString:@"T"];
        //获得日期
        NSString * dateStr = [arr objectAtIndex:0];
        NSString * timeStr = [[[arr objectAtIndex:1]componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象，这个对象里的时区是0时区
        NSDate * localDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000", dateStr, timeStr]];
        return localDate;
    }
    else
    {
        return nil;
    }
}

//接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"来消息了（%@）", message);
    //NSLog(@"离线0时区消息的时间是:%@", [self getDelayStampTime:message]);
    NSDate * date = [self getDelayStampTime:message];
    if(nil == date)//在线消息
    {
        date = [NSDate date];
    }
    //获得格式化对象
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间的具体格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strDate = [dateFormatter stringFromDate:date];//消息时间
    //NSLog(@"消息的时间是:%@", strDate);
    
    XMPPJID * remoteJID = [message from];
    NSString * thatUsername = [remoteJID user];//远端用户名
    NSString * body = [[message elementForName:@"body"] stringValue];//消息内容
    NSString * thismessage = [NSString stringWithFormat:@"(%@)%@:%@", strDate, thatUsername, body];//组合一下后通知
    NSLog(@"提取后的消息内容:%@", thismessage);
    
    //将消息写入数据库
    BOOL result = [self.fmdb executeUpdate:@"insert into messages values(?, ?, ?, ?, ?)", thatUsername, strDate, body, @"0", @"notmyself"];//最后一个为0则为未读消息
    if(!result)
    {
        NSLog(@"保存消息失败");
    }
    
    //tab页签需要接收消息提示
    //before: no use
    //MessageTableViewController * messageTableViewController = [LJUtil messageTableViewController];
    //[messageTableViewController showNumber];
    
    // 让messageview的tabbar显示总共的未读消息
    [[MessageViewController sharedMessageViewController] showNumber];
    
    //详细试图也要进行更新
    //创建一个通知
    NSNotification * recvMessageNotify = [[NSNotification alloc]initWithName:@"RECVMSG" object:[NSString stringWithFormat:@"%@,%@,%@", thatUsername, strDate, body] userInfo:nil];
    //发送通知 往通知中心投递通知
    [[NSNotificationCenter defaultCenter] postNotification:recvMessageNotify];
    
}

//发送消息
- (void)sendMessage:(NSString *)_msg to:(NSString *)_thatUsername
{
    //创建一个xml
    //根元素
    NSXMLElement * message = [NSXMLElement elementWithName:@"message"];
    
    //定义根元素的属性
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@localhost", _thatUsername]];
    [message addAttributeWithName:@"from" stringValue:@"1111@localhost"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSXMLElement * body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:_msg];
    [message addChild:body];
    NSLog(@"this message: %@", message);
    
    [xmppStream sendElement:message];//发送数据
    
}



#pragma mark utilities




#pragma mark appdelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "locky.com.iTalk" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iTalk" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iTalk.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
