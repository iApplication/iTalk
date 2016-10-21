//
//  LJUtil.h
//  LoginRegister
//
//  Created by locky1218 on 15-3-22.
//  Copyright (c) 2015年 locky1218. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTableViewController.h"

@interface LJUtil : NSObject

+ (void)alert:(NSString *)msg; //警报

+ (NSString *)trim:(NSString *)_str;//去掉字符串两端空格

+ (void)setMessageView:(MessageTableViewController *)_msgView;
+ (MessageTableViewController *)messageTableViewController;

//获得和改变自己的用户名密码
+ (void)setUsername:(NSString *)_username;
+ (NSString *)username;
+ (void)setUserpwd:(NSString *)_userpwd;
+ (NSString *)userpwd;

@end
