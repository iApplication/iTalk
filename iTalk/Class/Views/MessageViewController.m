//
//  MessageViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-14.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCollectionViewCell.h"
#import "MessageDetailViewController.h"
#import "DetailViewController.h"
#import "LJDateUtil.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

singleton_implementation(MessageViewController);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 消息保存结构的初始化
    self.msgs = [[NSMutableArray alloc]initWithCapacity:100];
    
    //导航栏字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:COLOR_NAVIGATION_TITLE}];
    
    // 导航栏的背景，名字
    //self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    //self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    //self.navigationItem.title = @"chat";
    
    //设置collectionview布局
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.messageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight-64-49) collectionViewLayout:flowlayout];
    
    //设置代理
    self.messageCollectionView.delegate = self;
    self.messageCollectionView.dataSource = self;
    [self.view addSubview:self.messageCollectionView];
    
    //背景颜色
    self.messageCollectionView.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    
    //注册cell
    [self.messageCollectionView registerClass:[MessageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

// 显示未读消息个数
- (void)showNumber
{
    //获得未读消息总数
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select count(*) from messages where flag=0";//flag=0为未读
    FMResultSet * rs = [fmdb executeQuery:sql];
    [rs next];
    int num = [rs intForColumnIndex:0];
    if(num > 0)
    {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", num];
    }
    else  //为0的时候不显示总未读数
    {
        self.tabBarItem.badgeValue = nil;
    }
    //NSString * num = [rs columnNameForIndex:0];
    //NSString * num = [rs stringForColumnIndex:0];
    //self.tabBarItem.badgeValue = num;
    
    //得到用户消息列表
    [rs close];
    sql = @"select username from messages group by username";
    [self.msgs removeAllObjects];
    rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        LJMessages * msg = [[LJMessages alloc]init];
        msg.username = [rs stringForColumnIndex:0];
        [self.msgs addObject:msg];
    }
    [rs close];
    
    //保存最后发来的消息
    for(LJMessages * msg in self.msgs)
    {
        sql = @"select msg from messages where username=? order by time desc limit 0,1";
        rs = [fmdb executeQuery:sql, msg.username];
        [rs next];
        msg.body = [rs stringForColumnIndex:0];
        [rs close];
        
        sql = @"select time from messages where username=? order by time desc limit 0,1";
        rs = [fmdb executeQuery:sql, msg.username];
        [rs next];
        msg.time = [rs stringForColumnIndex:0];
        [rs close];
        
        sql = @"select count(*) from messages where username=? and flag=0";
        rs = [fmdb executeQuery:sql, msg.username];
        [rs next];
        msg.flag = [rs intForColumnIndex:0];
    }
    [rs close];
    
    // 视图控制器重新加载数据
    [self.messageCollectionView reloadData];
}

//刚登录后也需要显示总共的未读消息
- (void)viewDidAppear:(BOOL)animated
{
    [self showNumber];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.msgs.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    MessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    LJMessages * msg = self.msgs[indexPath.row];
    cell.labelUserName.text = msg.username;
    cell.labelLastMsg.text = msg.body;
    
    //处理显示的时间
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date=[dateFormatter dateFromString:msg.time];
    if(YES == [LJDateUtil isCurrentDay:date])//日期是今天
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString * strDate = [dateFormatter stringFromDate:date];//消息时间
        cell.labelLastMsgTime.text = strDate;
    }
    else if([LJDateUtil isCurrentWeek:date]) //日期是这周
    {
        [dateFormatter setDateFormat:@"EEEE"];
        NSString * strDate = [dateFormatter stringFromDate:date];//消息时间
        cell.labelLastMsgTime.text = strDate;
    }
    else //显示为几月几日
    {
        [dateFormatter setDateFormat:@"M月d日"];
        NSString * strDate = [dateFormatter stringFromDate:date];//消息时间
        cell.labelLastMsgTime.text = strDate;
    }
    
    [cell reAlignLayout];//调整控件的位置
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    //return CGSizeMake((fDeviceWidth-20)/2, (fDeviceWidth-20)/2+50);
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];

    LJMessages * msg = self.msgs[indexPath.row];
    
    MessageDetailViewController * messageDetailViewController = [[MessageDetailViewController alloc]initWithNibName:@"MessageDetailViewController" bundle:nil];
    messageDetailViewController.strUsername = msg.username;
    [self presentViewController:messageDetailViewController animated:NO completion:nil];
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
