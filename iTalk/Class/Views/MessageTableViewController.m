//
//  MessageTableViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "MessageTableViewController.h"
#import "DetailViewController.h"


@interface MessageTableViewController ()

@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.msgs = [[NSMutableArray alloc]initWithCapacity:100];
    
}

- (void)showNumber
{
    //获得未读消息总数
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select count(*) from messages where flag=0";
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
        
        sql = @"select count(*) from messages where username=? and flag=0";
        rs = [fmdb executeQuery:sql, msg.username];
        [rs next];
        msg.flag = [rs intForColumnIndex:0];
    }
    [rs close];
    
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.msgs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LJMessages * msg = self.msgs[indexPath.row];
    cell.textLabel.text = msg.username;
    
    cell.detailTextLabel.text = msg.body;
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    numLabel.textColor = [UIColor redColor];
    numLabel.textAlignment = NSTextAlignmentRight;
    if(msg.flag > 0)
    {
        numLabel.text = [NSString stringWithFormat:@"%d", msg.flag];
    }
    cell.accessoryView = numLabel;
    
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJMessages * msg = self.msgs[indexPath.row];
    
    DetailViewController * detailViewController = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detailViewController.usernameStr = msg.username;
    [self presentViewController:detailViewController animated:NO completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
