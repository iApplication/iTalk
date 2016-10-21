//
//  LJDateUtil.h
//  iTalk
//
//  Created by locky1218 on 15-4-25.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJDateUtil : NSObject

// 比较是否是今天
+ (BOOL)isCurrentDay:(NSDate *)aDate;

// 是否是同一周
+ (BOOL)isCurrentWeek:(NSDate *)aDate;

// 一个日期星期的开始日期
+ (NSDate *)dateStartOfWeek:(NSDate *)aDate;

@end
