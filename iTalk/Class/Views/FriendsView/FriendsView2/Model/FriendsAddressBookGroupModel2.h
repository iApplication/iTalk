//
//  FriendsAddressBookGroupModel2.h
//  QQList
//
//  Created by locky on 15/05/02.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FriendsAddressBookFriendsModel;
@interface FriendsAddressBookGroupModel2 : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, strong) NSArray *friends;
//@property (nonatomic, strong) FriendsAddressBookFriendsModel *friendModel;
@property (nonatomic, assign) BOOL isOpen;//分组是否展开

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)GroupWithDict:(NSDictionary *)dict;

@end
