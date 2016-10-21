# POP-Animation

非 `CocoaPods` 版本的 `POP`，自 2015.04.10 官网 `POP` 的 `master` 版本修改而成

>注意

Xcode6以上新建的项目中，需要创建出pch文件，并且在pch文件中添加以下代码

```
//
//  POP.pch
//  POP
//
//  Created by XianMingYou on 15/4/10.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#ifndef POP_POP_pch
#define POP_POP_pch


#import <Availability.h>

#ifndef __IPHONE_4_0
#warning "This project uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#endif

```
一定要在pch文件中添加以下两行，否则编译无法通过

```
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
```
