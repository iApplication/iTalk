//
//  FriendsAddressBooViewController2.m
//  QQList
//
//  Created by locky on 14/11/22.
//  Copyright (c) 2014年 locky. All rights reserved.
//

#import "FriendsAddressBookViewController2.h"
#import "FriendsAddressBookGroupModel2.h"
#import "FriendsAddressBookFriendsModel.h"
#import "FriendsAddressBookHeaderView2.h"
@interface FriendsAddressBookViewController2 ()<FriendsAddressBookHeaderViewDelegate2>
@property (nonatomic, strong) NSArray *groupArray;

@property (nonatomic, strong)NSMutableDictionary * frienddic1;
@property (nonatomic, strong)NSMutableDictionary * frienddic2;
@property (nonatomic, strong)NSMutableDictionary * frienddic3;
@property (nonatomic, strong)NSMutableDictionary * frienddic4;
@property (nonatomic, strong)NSMutableDictionary * frienddic5;

@end

@implementation FriendsAddressBookViewController2
//懒加载
//- (NSArray *)dataArray{
////    if (!_dataArray) {
////        NSString *path = [[NSBundle mainBundle] pathForResource:@"friends.plist" ofType:nil];
////        NSArray *array = [NSArray arrayWithContentsOfFile:path];
////        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:array.count];
////        for (NSDictionary *dict in array) {
////            FriendsAddressBookGroupModel2 *groupModel = [FriendsAddressBookGroupModel2 GroupWithDict:dict];
////            [muArray addObject:groupModel];
////        }
////        _dataArray = [muArray copy];
////    }
//    return _dataArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置headerview高度
    self.tableView.sectionHeaderHeight = 40;
    //去除tableview多余的线
    [self clipExtraCellLine:self.tableView];
    
    //从数据库获得好友
    NSMutableArray * friendModels = [NSMutableArray array];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select * from friends";
    FMResultSet * rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        FriendsAddressBookFriendsModel * friendmodel = [[FriendsAddressBookFriendsModel alloc]init];
        friendmodel.name = [rs stringForColumnIndex:0];
        friendmodel.icon = @"img_01.png";
        friendmodel.intro = @"no intro";
        friendmodel.groupname = [rs stringForColumnIndex:1];

        [friendModels addObject:friendmodel];
    }
    [rs close];
    
    NSLog(@"friends count:%lu", (unsigned long)[friendModels count]);
    
    //从数据库获得分组
    NSMutableArray * groupModels = [NSMutableArray array];
    sql = @"select * from groups";
    rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        NSLog(@"group count");
        FriendsAddressBookGroupModel2 * groupmodel = [[FriendsAddressBookGroupModel2 alloc]init];
        groupmodel.name = [rs stringForColumnIndex:0];
        groupmodel.online = @"0";
        NSMutableArray * friends = [NSMutableArray array];
        for (FriendsAddressBookFriendsModel * friendmodel in friendModels) {
            if ([friendmodel.groupname isEqualToString:groupmodel.name]) {
                [friends addObject:friendmodel];
            }
            NSLog(@"friends");
        }
        groupmodel.friends = [friends copy];
        
        [groupModels addObject:groupmodel];
    }
    [rs close];
    
    NSLog(@"group count:%lu", (unsigned long)[groupModels count]);
    
    self.groupArray = [groupModels copy];
    
//    //初始化数据
//    FriendsAddressBookFriendsModel * friendmodel1 = [[FriendsAddressBookFriendsModel alloc]init];
//    friendmodel1.name = @"friend 2";
//    friendmodel1.icon = @"img_01.png";
//    friendmodel1.intro = @"no intro";
//    //friendmodel1.isVip = NO;
//    FriendsAddressBookFriendsModel * friendmodel2 = [[FriendsAddressBookFriendsModel alloc]init];
//    friendmodel2.name = @"friend 1";
//    friendmodel2.icon = @"img_01.png";
//    friendmodel2.intro = @"no intro";
//    //friendmodel2.isVip = NO;
//    FriendsAddressBookFriendsModel * friendmodel3 = [[FriendsAddressBookFriendsModel alloc]init];
//    friendmodel3.name = @"friend 3";
//    friendmodel3.icon = @"img_01.png";
//    friendmodel3.intro = @"no intro";
//    //friendmodel3.isVip = NO;
//    FriendsAddressBookFriendsModel * friendmodel4 = [[FriendsAddressBookFriendsModel alloc]init];
//    friendmodel4.name = @"friend 4";
//    friendmodel4.icon = @"img_01.png";
//    friendmodel4.intro = @"no intro";
//    //friendmodel4.isVip = NO;
//    FriendsAddressBookFriendsModel * friendmodel5 = [[FriendsAddressBookFriendsModel alloc]init];
//    friendmodel5.name = @"friend 5";
//    friendmodel5.icon = @"img_01.png";
//    friendmodel5.intro = @"no intro";
//    //friendmodel5.isVip = NO;
//    
//    NSArray * friendsArray1 = [NSArray arrayWithObjects:friendmodel1, friendmodel2, nil];
//    NSArray * friendsArray2 = [NSArray arrayWithObjects:friendmodel3, friendmodel4, friendmodel5, nil];
//    
//    FriendsAddressBookGroupModel2 * groupmodel1 = [[FriendsAddressBookGroupModel2 alloc]init];
//    groupmodel1.name = @"group 1";
//    groupmodel1.online = @"0";
//    groupmodel1.friends = friendsArray1;
//    FriendsAddressBookGroupModel2 * groupmodel2 = [[FriendsAddressBookGroupModel2 alloc]init];
//    groupmodel2.name = @"group 2";
//    groupmodel2.online = @"0";
//    groupmodel2.friends = friendsArray2;
//    
//    NSMutableArray * groups = [[NSMutableArray alloc]initWithCapacity:100];
//    [groups addObject:groupmodel1];
//    //[groups addObject:groupmodel2];
//    
//    self.groupArray = [groups copy];
//    
//    NSMutableArray * groups2 = [[NSMutableArray alloc]initWithArray:self.groupArray];
//    [groups2 addObject:groupmodel2];
//    
//    self.groupArray = [groups2 copy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FriendsAddressBookGroupModel2 *groupModel = self.groupArray[section];
    NSInteger count = groupModel.isOpen ? groupModel.friends.count : 0;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"friendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    FriendsAddressBookGroupModel2 *groupModel = self.groupArray[indexPath.section];
    FriendsAddressBookFriendsModel *friendModel = groupModel.friends[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:friendModel.icon];
    cell.textLabel.text = friendModel.name;
    //cell.detailTextLabel.text = friendModel.intro;
    
    return cell;
}
#pragma mark - UITableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FriendsAddressBookHeaderView2 *header = [FriendsAddressBookHeaderView2 headerView:tableView];
    header.delegate = self;
    header.groupModel = self.groupArray[section];//注意这里的理解
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - HeaderView delegate
- (void)clickView{
    [self.tableView reloadData];
}
#pragma mark - 去掉多余的线
- (void)clipExtraCellLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    [self.tableView setTableFooterView:view];
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
