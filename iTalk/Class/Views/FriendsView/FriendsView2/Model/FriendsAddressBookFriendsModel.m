//
//  FriendsAddressBookFriendsModel.m
//  QQList
//
//  Created by locky on 15/05/02.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "FriendsAddressBookFriendsModel.h"

@implementation FriendsAddressBookFriendsModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)FriendWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
