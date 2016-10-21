//
//  FriendsAddressBookHeaderView2.m
//  QQList
//
//  Created by locky on 14/11/22.
//  Copyright (c) 2014年 locky. All rights reserved.
//

#import "FriendsAddressBookHeaderView2.h"
#import "FriendsAddressBookGroupModel2.h"
@implementation FriendsAddressBookHeaderView2{
    UIButton *_arrowBtn;
    UILabel *_label;
}
+ (instancetype)headerView:(UITableView *)tableView{
    static NSString *identifier = @"header";
    FriendsAddressBookHeaderView2 *header = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!header) {
        header = [[FriendsAddressBookHeaderView2 alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super init]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:[UIImage imageNamed:@"header_bg"] forState:UIControlStateNormal];
        //[button setBackgroundImage:[UIImage imageNamed:@"header_bg_highlighted"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor cyanColor]];
        [button setImage:[UIImage imageNamed:@"addressBookArrow"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.imageView.contentMode = UIViewContentModeCenter;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.imageView.clipsToBounds = NO;
        _arrowBtn = button;
        [self addSubview:_arrowBtn];
        //创建label，显示当前在线人数
        UILabel *labelRight = [[UILabel alloc] init];
        labelRight.textAlignment = NSTextAlignmentCenter;
        _label = labelRight;
        [self addSubview:_label];
    }
    return self;
}
#pragma mark - buttonAction
- (void)buttonAction{
    self.groupModel.isOpen = !self.groupModel.isOpen;
    //如果代理申明了clickView方法
    if ([self.delegate respondsToSelector:@selector(clickView)]) {
        [self.delegate clickView];
    }
}
- (void)didMoveToSuperview{
    _arrowBtn.imageView.transform = self.groupModel.isOpen ? CGAffineTransformMakeRotation(M_PI_2) :CGAffineTransformMakeRotation(0);
}
//布局
- (void)layoutSubviews{
    [super layoutSubviews];
    _arrowBtn.frame = self.bounds;
    _label.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}
//赋值
- (void)setGroupModel:(FriendsAddressBookGroupModel2 *)groupModel{
    _groupModel = groupModel;
    [_arrowBtn setTitle:_groupModel.name forState:UIControlStateNormal];
    _label.text = [NSString stringWithFormat:@"%@/%lu",_groupModel.online,(unsigned long)_groupModel.friends.count];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
