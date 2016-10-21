//
//  FriendsAddressBookGroupModel2.m
//  QQList
//
//  Created by locky on 15/05/02.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "FriendsAddressBookGroupModel2.h"
#import "FriendsAddressBookFriendsModel.h"
@implementation FriendsAddressBookGroupModel2

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in self.friends) {
            FriendsAddressBookFriendsModel *model = [FriendsAddressBookFriendsModel FriendWithDict:dict];
            [muArray addObject:model];
        }
        self.friends = muArray;
    }
    return self;
}
+ (instancetype)GroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
