//
//  MessageViewController.h
//  iTalk
//
//  Created by locky1218 on 15-4-14.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface MessageViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * messageCollectionView;//collectionview变量，用于显示每一个消息条目
@property (strong, nonatomic) NSMutableArray * msgs; // 消息的保存结构

- (void)showNumber;// 显示未读消息个数

singleton_interface(MessageViewController);//此类的单例

@end
