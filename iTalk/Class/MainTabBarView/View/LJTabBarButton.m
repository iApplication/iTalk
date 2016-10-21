//
//  LJTabBarButton.m
//  TabBarDemo
//
//  Created by locky1218 on 15-4-12.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LJTabBarButton.h"
#import "KLComment.h"
#import "LJBadgeButton.h"

// 图标比例
#define LJTabBarButtonImageRatio 0.6

@interface LJTabBarButton()
// 数字提醒
@property (nonatomic, weak)  LJBadgeButton * badgeButton;
@end
@implementation LJTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor colorWithRed:156.0/255.0 green:146.0/255.0 blue:131.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:51.0/255.0 green:33.0/255.0 blue:24.0/255.0 alpha:1] forState:UIControlStateSelected];
        if (!ios7) {
            [self setBackgroundImage:[UIImage imageWithName:@"tabbar_slider"] forState:UIControlStateSelected];
        }
        // 提醒数字按钮
        LJBadgeButton *badgeButton = [[LJBadgeButton alloc]init];
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    // kvo 监听属性
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  keyPath 属性名
 *  object  哪个对象的属性被改变
 *  change  属性发生的改变
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    // 设置提醒数字的位置
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = self.frame.size.height * LJTabBarButtonImageRatio;
    CGFloat imageW = self.frame.size.width;
    return CGRectMake(0, 0, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = self.frame.size.height * LJTabBarButtonImageRatio;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
