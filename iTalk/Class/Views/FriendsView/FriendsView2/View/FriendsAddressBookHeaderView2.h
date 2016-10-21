//
//  FriendsAddressBookHeaderView2.h
//  QQList
//
//  Created by locky on 14/11/22.
//  Copyright (c) 2014年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsAddressBookGroupModel2.h"
@protocol FriendsAddressBookHeaderViewDelegate2 <NSObject>

@optional
- (void)clickView;

@end

@interface FriendsAddressBookHeaderView2 : UITableViewHeaderFooterView
@property (nonatomic, assign) id<FriendsAddressBookHeaderViewDelegate2> delegate;

@property (nonatomic, strong) FriendsAddressBookGroupModel2 *groupModel;
+ (instancetype)headerView:(UITableView *)tableView;
@end
