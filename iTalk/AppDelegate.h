//
//  AppDelegate.h
//  iTalk
//
//  Created by locky1218 on 15-3-29.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"

@class LoginViewController;
@class FMDatabase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, XMPPStreamDelegate>
{
    LoginViewController * loginViewController;//登录界面
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;

//用户名密码
@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString * password;

@property (assign, nonatomic) BOOL isRegister;

- (BOOL)connectWithUserName:(NSString *)_username andUserPassword:(NSString *)_userpwd;//登录连接服务器
- (void)disconnect;//离线，且断开连接服务器

@property (strong, nonatomic)FMDatabase * fmdb;

- (void)sendMessage:(NSString *)_msg to:(NSString *)_thatUsername;

- (void)setHostName:(NSString *)hostname;//设置主机地址

@end

