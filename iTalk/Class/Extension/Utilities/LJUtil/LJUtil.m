//
//  LJUtil.m
//  LoginRegister
//
//  Created by locky1218 on 15-3-22.
//  Copyright (c) 2015年 locky1218. All rights reserved.
//

#import "LJUtil.h"
#import <UIKit/UIKit.h>

static MessageTableViewController * messageTableViewController = nil;
static NSString * username = nil;
static NSString * userpwd = nil;

@implementation LJUtil

+ (void)alert:(NSString *)msg
{
    UIAlertView * alertmsg = [[UIAlertView alloc]initWithTitle:@"友情提示" message:msg delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertmsg show];
}

+ (NSString *)trim:(NSString *)_str
{
    return [_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)setMessageView:(MessageTableViewController *)_msgView
{
    messageTableViewController = _msgView;
}

+ (MessageTableViewController *)messageTableViewController
{
    return messageTableViewController;
}

+ (void)setUsername:(NSString *)_username
{
    username = _username;
}

+ (NSString *)username
{
    return username;
}

+ (void)setUserpwd:(NSString *)_userpwd
{
    userpwd = _userpwd;
}

+ (NSString *)userpwd
{
    return userpwd;
}
@end
