//
//  Singleton.h
//  iTalk
//
//  Created by locky1218 on 15-4-15.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#ifndef iTalk_Singleton_h
#define iTalk_Singleton_h

/*
 专门用来保存单例代码
 最后一行不要加 \
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#endif
