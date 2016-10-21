//
//  LJMessages.h
//  iTalk
//
//  Created by locky1218 on 15-4-1.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJMessages : NSObject

@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString * time;
@property (strong, nonatomic) NSString * body;
@property (assign, nonatomic) int flag;//0为未读，1为已读
@property (strong, nonatomic) NSString * me;//是不是我发送出去的

@end
