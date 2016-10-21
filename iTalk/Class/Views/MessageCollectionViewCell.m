//
//  MessageCollectionViewCell.m
//  iTalk
//
//  Created by locky1218 on 15-4-14.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "LJStringUtil.h"

@implementation MessageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //背景颜色
        self.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
        
        // 用户头像
        self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 55, 55)];
        self.userImageView.image = [UIImage imageNamed:@"img_01"];
        [self addSubview:self.userImageView];
        
        // 用户名字
        self.labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 105, 21)];
        self.labelUserName.text = @"nametest";
        self.labelUserName.textColor = [UIColor blackColor];
        self.labelUserName.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.labelUserName];
        
        // 最后消息
        self.labelLastMsg = [[UILabel alloc]initWithFrame:CGRectMake(80, 46, 202, 16)];
        self.labelLastMsg.text = @"msgtest";
        self.labelLastMsg.textColor = [UIColor grayColor];
        self.labelLastMsg.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.labelLastMsg];
        
        // 最后消息时间 -- 等获得最后的时间字符串后位置需要改变
        self.labelLastMsgTime = [[UILabel alloc]initWithFrame:CGRectMake(215, 10, 95, 21)];
        self.labelLastMsgTime.text = @"timetest";
        self.labelLastMsgTime.textColor = [UIColor grayColor];
        self.labelLastMsgTime.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.labelLastMsgTime];
        
        
    }
    
    return self;
}

- (void)reAlignLayout
{
    //CGSize size = [self.labelLastMsgTime.text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    UIFont * font = [UIFont systemFontOfSize:14];
    CGSize strSize = [LJStringUtil StringSizeWithText:self.labelLastMsgTime.text andFont:font];
    self.labelLastMsgTime.frame = CGRectMake(SCREENWIDTH-strSize.width-10, 10, strSize.width, strSize.height);
}



#pragma mark - Private

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:207.0f/255.0f green:198.0f/255.0f blue:173.0f/255.0f alpha:1.0];
    }
    else {
        self.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    }
}

@end
