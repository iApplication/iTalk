//
//  LJTabBar.h
//  TabBarDemo
//
//  Created by locky1218 on 15-4-12.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJTabBar;
@protocol LJTabbarDekegate <NSObject>

@optional
- (void)tabBar:(LJTabBar *)tabBar didSelectedButtonfrom:(NSInteger)from to:(NSInteger)to;
@end

@interface LJTabBar : UIView

@property (nonatomic, weak) id<LJTabbarDekegate>delegate;

- (void)addButtonWithItem:(UITabBarItem *)item;

@end
