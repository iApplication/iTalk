//
//  NewsTableViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "NewsTableViewController.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.users = [[NSMutableArray alloc]initWithCapacity:100];
    
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    searchBar.delegate = self;//！！指明代理
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.tableView.tableHeaderView = searchBar;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//使用之前指明搜索栏的代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * str = searchBar.text;
    str = [LJUtil trim:str];
    if([str isEqualToString:@""])
    {
        [LJUtil alert:@"搜索的内容不能为空"];
        searchBar.text = @"";
        return;
    }
    
    [self.users removeAllObjects];//先清除掉之前的集合
    [self.tableView reloadData];
    
    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://localhost/italk/users/findusers.php?id=%@", str]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data)
    {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(array)//搜索到用户
        {
            for(NSDictionary * dict in array)
            {
                NSString * username = [dict objectForKey:@"username"];
                [self.users addObject:username];
            }
            [self.tableView reloadData];//重新加载数据
        }
        else
        {
            [LJUtil alert:@"无该用户信息"];
        }
    }
    else
    {
        [LJUtil alert:@"查询失败,请稍后再试"];
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
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    cell.textLabel.text = self.users[indexPath.row];
    
    return cell;
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
