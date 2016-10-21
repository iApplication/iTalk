//
//  LJDateUtil.m
//  iTalk
//
//  Created by locky1218 on 15-4-25.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LJDateUtil.h"

@implementation LJDateUtil

+ (BOOL)isCurrentDay:(NSDate *)aDate
{
    if (aDate==nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

+ (BOOL)isCurrentWeek:(NSDate *)aDate
{
    NSDate * date1 = [LJDateUtil dateStartOfWeek:aDate];
    NSDate * date2 = [LJDateUtil dateStartOfWeek:[NSDate date]];
    if ([date1 isEqualToDate:date2]) {
        return YES;
    }
    return NO;
}

+ (NSDate *)dateStartOfWeek:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:aDate];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:aDate options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

@end
