//
//  FriendsAddressBookFriendsModel.h
//  QQList
//
//  Created by locky on 15/05/02.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsAddressBookFriendsModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *groupname;
//@property (nonatomic, assign) BOOL isVip;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)FriendWithDict:(NSDictionary *)dict;
@end
