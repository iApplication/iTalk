//
//  FriendsTableViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "AddFriendViewController.h"
#import "DetailViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

@synthesize friendNames;

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏右侧有加号按钮
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTap:)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    self.friendNames = [[NSMutableArray alloc]initWithCapacity:100];
    //从数据库中读取好友信息
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select * from friends";
    FMResultSet * rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        [self.friendNames addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addTap:(id)sender
{
    //AddFriendViewController * addFriendViewController = [[AddFriendViewController alloc]init];
    //addFriendViewController.friendTableViewController = self;
    //[self presentViewController:addFriendViewController animated:NO completion:nil];
}

- (void)addFriend:(NSString *)_friendName
{
    BOOL hasThisFriend = NO;
    for(NSString * str in self.friendNames)
    {
        if([str isEqualToString:_friendName])
        {
            hasThisFriend = YES;
        }
    }
    if(NO == hasThisFriend)//数据中没有此用户才去添加到数据库和集合中
    {
        //放到数据库中
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        FMDatabase * fmdb = app.fmdb;
        BOOL result = [fmdb executeUpdate:@"insert into friends values(?, ?)", _friendName, @"我的好友"];
        if(YES == result)
        {
            //添加到集合中
            [self.friendNames addObject:_friendName];
            //重新显示一下
            [self.tableView reloadData];
        }
        else
        {
            //LOG
        }
    }
    
    
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

    return self.friendNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.friendNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailViewController = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detailViewController.usernameStr = self.friendNames[indexPath.row];
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
