//
//  DetailViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-2.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize msgs;

- (void)viewDidLoad {
    [super viewDidLoad];
    //接收消息通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeMsg:) name:@"RECVMSG" object:nil];
    
    self.msgs = [[NSMutableArray alloc]initWithCapacity:100];
    
    self.thatUsernameLabel.text = self.usernameStr;
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select * from messages where username=?";
    FMResultSet * rs = [fmdb executeQuery:sql, self.usernameStr];
    [self.msgs removeAllObjects];
    while([rs next])
    {
        LJMessages * msg = [[LJMessages alloc]init];
        msg.username = [rs stringForColumnIndex:0];
        msg.body = [rs stringForColumnIndex:2];
        msg.time = [rs stringForColumnIndex:1];
        msg.flag = [rs intForColumnIndex:3];
        msg.me = [rs stringForColumnIndex:4];
        [msgs addObject:msg];
        [fmdb executeUpdate:@"update messages set flag=1 where username=? and time=? and msg=? and me=?", msg.username, msg.time, msg.body, msg.me];
    }
    
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

- (IBAction)backTap:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)closeKeyboard:(UITextField *)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LJMessages * msg = self.msgs[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    cell.textLabel.text = msg.time;
    cell.detailTextLabel.text = msg.body;
    
    //if([msg.me isEqualToString:@"myself"])
    //{
        UILabel * meLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        meLabel.textColor = [UIColor redColor];
        meLabel.textAlignment = NSTextAlignmentLeft;
        meLabel.text = msg.me;
        cell.accessoryView = meLabel;
    //}
    

    
    
    return cell;
}

//消失时更新tab的未读信息数
- (void)viewWillDisappear:(BOOL)animated
{
    [[LJUtil messageTableViewController]showNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if( (self.tableView.contentSize.height - self.tableView.bounds.size.height) >0)
    {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height) animated:NO];
    }
}

- (IBAction)editBegin:(UITextField *)sender {
    CGRect frame = sender.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 258.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (IBAction)editEnd:(UITextField *)sender {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (IBAction)sendTap:(UIButton *)sender {
    NSString * msgStr = self.msgText.text;
    msgStr = [LJUtil trim:msgStr];
    if([msgStr isEqualToString:@""])
    {
        [LJUtil alert:@"不能发送空消息"];
        self.msgText.text = @"";
    }
    else
    {
        AppDelegate * app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        //发送消息
        [app sendMessage:msgStr to:self.usernameStr];
        
        //把消息在本地保存
        FMDatabase * fmdb = [app fmdb];
        NSString * sql = @"insert into messages values(?, ?, ?, ?, ?)";
        
        NSDate * date = [NSDate date];
        //获得格式化对象
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间的具体格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * strDate = [dateFormatter stringFromDate:date];//消息时间
        //NSLog(@"消息的时间是:%@", strDate);

        [fmdb executeUpdate:sql, self.usernameStr, strDate, msgStr, @"1", @"myself"];
        
        LJMessages * message = [[LJMessages alloc]init];
        message.username = self.usernameStr;
        message.time = strDate;
        message.flag = 1;
        message.body = msgStr;
        message.me = @"myself";
        [self.msgs addObject:message];
        
        self.msgText.text = @"";
        [self.tableView reloadData];//重新加载数据
        [self.msgText resignFirstResponder];//关闭键盘
        [self viewDidAppear:NO];//让消息移动到最低端
    }
}

- (void)comeMsg:(id)sender
{
    NSString * strMsg = [sender object];
    NSArray * array = [strMsg componentsSeparatedByString:@","];
    NSString * thatUsername = array[0];
    NSString * time = array[1];
    NSString * body = array[2];
    LJMessages * message = [[LJMessages alloc]init];
    message.username = thatUsername;
    message.time = time;
    message.body = body;
    message.flag = 1; //变成已读
    message.me = @"nomyself";
    [self.msgs addObject:message];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    [fmdb executeUpdate:@"update messages set flag=1 where username=? and time=? and msg=? and me=?", thatUsername, time, body, message.me];
    
    [self.tableView reloadData];//重新加载视图
    [self viewDidAppear:NO];//消息移到最低端
}

@end
