//
//  MessageDetailTableViewCell.m
//  iTalk
//
//  Created by locky1218 on 15-4-24.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "MessageDetailTableViewCell.h"

@implementation MessageDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //设置背景颜色
    self.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    
    //初始化
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bubbleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        _bubbleView.backgroundColor = [UIColor clearColor];
        
        _photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        
        [self.contentView addSubview:_bubbleView];
        [self.contentView addSubview:_photo];
    }
    return self;
}

-(void)setContent:(LJMessages*)msg
{
    //自己
    if ([msg.me isEqualToString:@"myself"])
    {
        _photo.frame = CGRectMake(SCREENWIDTH-60, 10, 50, 50);
        _photo.image = [UIImage imageNamed:@"img_02"];
        
        
        [self bubbleView:msg.body from:YES withPosition:65 withView:_bubbleView];
        
    }
    //另一端
    else
    {
        _photo.frame = CGRectMake(10, 10, 50, 50);
        _photo.image = [UIImage imageNamed:@"img_01"];
        
        
        [self bubbleView:msg.body from:NO withPosition:65 withView:_bubbleView];
    }
    
}

//泡泡文本
- (void)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position withView:(UIView*)bulleView{
    for (UIView *subView in bulleView.subviews) {
        [subView removeFromSuperview];
    }
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = bulleView;
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage * bubble = fromSelf ? [UIImage imageNamed:@"SenderVoiceBox"]:[UIImage imageNamed:@"ReceiverVoiceBox"];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    //NSLog(@"size：%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    //bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(SCREENWIDTH-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
}

//泡泡语音
- (void)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf  withPosition:(int)position withView:(UIView *)yuyinView{
    
    for (UIView *subView in yuyinView.subviews) {
        [subView removeFromSuperview];
    }
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 250;
    if(fromSelf)
        yuyinView.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        yuyinView.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    button.frame = CGRectMake(0, 0, yuyinwidth, 54);
    [yuyinView addSubview:button];
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d''",logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
}

@end
