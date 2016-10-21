//
//  LJStringUtil.m
//  iTalk
//
//  Created by locky1218 on 15-4-25.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "LJStringUtil.h"

@implementation LJStringUtil

+ (CGSize)StringSizeWithText:(NSString*)text andFont:(UIFont *)font
{
    //设置字体
    CGSize size = CGSizeMake(180, 20000.0f);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    if (ios7)//IOS 7.0 以上
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }
    else
    {
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
    }
    
    return size;
}

@end
