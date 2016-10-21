//
//  SettingTableViewController.m
//  iTalk
//
//  Created by locky1218 on 15-3-30.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "SettingTableViewController.h"
#import "RequestPostUploadHelper.h"
#import "ModifyPasswordViewController.h"
#import "QRCodeViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 == section)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if(0 == indexPath.section)
    {
        cell.textLabel.text = @"我的头像";
        cell.imageView.image = [UIImage imageNamed:@"person.png"];
    }
    else
    {
        if(0 == indexPath.row)
        {
            cell.textLabel.text = @"修改密码";
        }
        else
        {
            cell.textLabel.text = @"我的二维码";
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        return 88;
    }
    else
    {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)//上传头像
    {
        //获得上传图片的路径
        NSString * path = [[NSBundle mainBundle]pathForResource:@"person" ofType:@"png"];
        NSLog(@"path:%@", path);
        //定制附加参数
        NSMutableDictionary * dir = [NSMutableDictionary dictionaryWithCapacity:7];
        [dir setValue:@"ios上传试试" forKey:@"title"];
        NSString * url = @"http://127.0.0.1/italk/up/up.php";
        NSArray * nameArr = [path componentsSeparatedByString:@"/"];
        NSLog(@"path:%@", nameArr);
        //开始上传-上传名为用户名+png
        [RequestPostUploadHelper postRequestWithURL:url postParems:dir picFilePath:path picFileName:@"1111.png"];
        NSLog(@"come:%@", [nameArr objectAtIndex:[nameArr count]-1]);
    }
    else//第二个区
    {
        if(0 == indexPath.row)//修改密码
        {
            ModifyPasswordViewController * modifyPasswordViewController = [[ModifyPasswordViewController alloc]init];
            [self presentViewController:modifyPasswordViewController animated:NO completion:nil];
        }
        else//二维码
        {
            QRCodeViewController * qrcodeViewController = [[QRCodeViewController alloc]init];
            [self.navigationController pushViewController:qrcodeViewController animated:YES];
        }
    }
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
