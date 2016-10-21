//
//  FriendsAddressBookViewController.m
//  iTalk
//
//  Created by locky1218 on 15-5-1.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "FriendsAddressBookViewController.h"
#import "LJIndexView.h"
#import "AddFriendViewController.h"

#define CRAYON_NAME(CRAYON)	[[CRAYON componentsSeparatedByString:@"#"] objectAtIndex:0]

@interface FriendsAddressBookViewController ()<UITableViewDataSource, UITableViewDelegate, LJIndexViewDataSource>

// properties for section array
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray * groups;
@property (nonatomic, strong) NSString *alphaString;  //存放首字母的字符串
@property (nonatomic, strong) NSMutableArray *sectionArray;

// properties for tableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIColor *tableColor;
@property (nonatomic, strong) UIColor *tableTextColor;
@property (nonatomic, strong) UIColor *tableSeparatorColor;
@property (nonatomic, strong) UIColor *tableHeaderColor;
@property (nonatomic, strong) UIColor *tableHeaderTextColor;
@property (nonatomic, strong) UIFont *font;

// LJIndexView
@property (nonatomic, strong) LJIndexView *indexView;

// properties for exampleView delegate
@property (nonatomic, strong) NSArray * allExamples;



#pragma mark all properties from LJIndexView

// set this to NO if you want to get selected items during the pan (default is YES)
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

// set the font of the selected index item (usually you should choose the same font with a bold style and much larger)
// (default is the same font as previous one with size 40.0 points)
@property (nonatomic, strong) UIFont *selectedItemFont;

// set the color for index items
@property (nonatomic, strong) UIColor *fontColor;

// set if items in index are going to darken during a pan (default is YES)
@property (nonatomic, assign) BOOL darkening;

// set if items in index are going ti fade during a pan (default is YES)
@property (nonatomic, assign) BOOL fading;

// set the color for the selected index item
@property (nonatomic, strong) UIColor *selectedItemFontColor;

// set index items aligment (NSTextAligmentLeft, NSTextAligmentCenter or NSTextAligmentRight - default is NSTextAligmentCenter)
@property (nonatomic, assign) NSTextAlignment itemsAligment;

// set the right margin of index items (default is 10.0)
@property (nonatomic, assign) CGFloat rightMargin;

// set the upper margin of index items (default is 20.0)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat upperMargin;

// set the lower margin of index items (default is 20.0)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat lowerMargin;

// set the maximum amount for item deflection (default is 75.0)
@property (nonatomic,assign) CGFloat maxItemDeflection;

// set the number of items deflected below and above the selected one (default is 5)
@property (nonatomic, assign) int rangeOfDeflection;

// set the curtain color if you want a curtain to appear (default is none)
@property (nonatomic, strong) UIColor *curtainColor;

// set the amount of fading for the curtain between 0 to 1 (default is 0.2)
@property (nonatomic, assign) CGFloat curtainFade;

// set if you need a curtain not to hide completely
@property (nonatomic, assign) BOOL curtainStays;

// set if you want a curtain to move while panning (default is NO)
@property (nonatomic, assign) BOOL curtainMoves;

// set if you need curtain to have the same upper and lower margins (default is NO)
@property (nonatomic, assign) BOOL curtainMargins;

// set this property to YES and it will automatically set margins so that gaps between items are 5.0 points (default is YES)
@property BOOL ergonomicHeight;

@end

@implementation FriendsAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化视图
    [self initviews];
    
}

#pragma mark - 初始化视图
- (void)initviews
{
    self.view.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    self.tableView.backgroundColor = COLOR_MILKWHITE_BACKGROUND;
    
    //导航栏字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:COLOR_NAVIGATION_TITLE}];
    
    //导航栏右侧图标
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navigationbar_addfriend"] forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    [btnCancel addTarget:self action:@selector(addTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = bbi;

    
    // setting all examples for the first example
    self.allExamples = @[@(1), @(0), @(0), @(0), @(0)];
    
    // load first sit of data to table
    [self firstTableExample];
    //[self secondTableExample];
    
    // initialise tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 20;
    [self.view addSubview:self.tableView];
    
    // initialise LJIndexView
    self.indexView = [[LJIndexView alloc]initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
    [self AttributesForLJIndexView];
    [self readAttributes];
    [self.view addSubview:self.indexView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button taps

- (void)addTap:(id)sender
{
    AddFriendViewController * addFriendViewController = [[AddFriendViewController alloc]init];
    addFriendViewController.friendAddressBookViewController = self;
    
    [self.navigationController pushViewController:addFriendViewController animated:NO];
    
}


#pragma mark settigns examples of tableView and LJIndexView

- (void)firstTableExample
{
    self.tableColor = COLOR_MILKWHITE_BACKGROUND;
    self.tableTextColor = [UIColor blackColor];
    self.tableSeparatorColor = [UIColor greenColor];//[UIColor colorWithWhite:0.9 alpha:1.0];
    self.tableHeaderColor = [UIColor cyanColor];//[UIColor colorWithRed:80.0/255.0 green:215.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.tableHeaderTextColor = [UIColor blueColor];
    [self refreshTable];
}

//indexView的属性
- (void)AttributesForLJIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
    
}

// 处理table的数据源
- (void)refreshTable
{
    //首字母字符串清空
    self.alphaString = @"";
    
    //获得所有的好友用户名
    self.friends = [NSArray array];
    self.friends = [self getAllUsernames];
    self.groups = [self gerAllGroupsnames];
    
    //计算section数
    int numberOfFirstLetters = [self countFirstLettersInArray:self.friends];
    
    //将所有section中的item加到当前section中，并保存在sectionArray中
    self.sectionArray = [NSMutableArray array];
    for (int i=0; i< numberOfFirstLetters; i++) {
        [self.sectionArray addObject:[self itemsInSection:i]];
    }
    
    //显示到tableview中
    [self.tableView setSeparatorColor:self.tableSeparatorColor];
    [self.tableView reloadData];
    [self.tableView reloadSectionIndexTitles];
    [self.indexView refreshIndexItems];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[self.sectionArray count] -1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSArray *)getAllUsernames
{
//    NSArray * usernames = [NSArray arrayWithObjects:@"AAAA", @"abcd", @"BBBB", @"ZZZZ", @"CCCC", @"DDDD", @"EEEE", @"FFFF", @"GGGG", @"HHHH", @"IIII", @"JJJJ",@"KKKK",@"LLLL",@"MMMM",@"NNNN",@"OOOO",@"PPPP",@"QQQQ",@"RRRR",@"SSSS",@"TTTT",@"UUUU",@"VVVV",@"WWWW",@"XXXX",@"YYYY",@"ZZZZ", @"1111", @"9999", nil];
//    return usernames;
    //从数据库中读取好友信息
    NSMutableArray * friends = [NSMutableArray array];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select * from friends";
    FMResultSet * rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        [friends addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return friends;
}

- (NSArray *)gerAllGroupsnames
{
    //从数据库中读取好友信息
    NSMutableArray * groups = [NSMutableArray array];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * fmdb = app.fmdb;
    NSString * sql = @"select * from groups";
    FMResultSet * rs = [fmdb executeQuery:sql];
    while([rs next])
    {
        [groups addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return groups;
}

//添加好友
- (void)addFriend:(NSString *)_friendName
{
    //添加好友
    BOOL hasThisFriend = NO;
    for(NSString * str in self.friends)
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
            NSMutableArray * friends = [[NSMutableArray alloc]initWithArray:self.friends];
            [friends addObject:_friendName];
            self.friends = [friends copy];
            //重新显示一下
            //[self.tableView reloadData];
            [self refreshTable];
        }
        else
        {
            //LOG
        }
    }
    
    //添加group
    NSString * groupname = @"我的好友";
    BOOL hasThisGroup = NO;
    for(NSString * str in self.groups)
    {
        if([str isEqualToString:groupname])//TODO
        {
            hasThisGroup = YES;
        }
    }
    if(NO == hasThisGroup)//数据中没有此用户才去添加到数据库和集合中
    {
        //放到数据库中
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        FMDatabase * fmdb = app.fmdb;
        BOOL result = [fmdb executeUpdate:@"insert into groups values(?)", groupname];
        if(YES == result)
        {
            //添加到集合中
            NSMutableArray * groups = [[NSMutableArray alloc]initWithArray:self.groups];
            [groups addObject:groupname];
            self.groups = [groups copy];
            //重新显示一下
            [self.tableView reloadData];
        }
        else
        {
            //LOG
        }
    }

}


#pragma mark building sectionArray for the tableView

//计算section数，并且将alphaString排序
- (int)countFirstLettersInArray:(NSArray *)categoryArray
{
    NSMutableArray *existingLetters = [NSMutableArray array];
    for (NSString *name in categoryArray)
    {
        NSString *firstLetterInName = [name substringToIndex:1];
        NSCharacterSet *notAllowed = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvsxyz0123456789"] invertedSet];
        NSRange range = [firstLetterInName rangeOfCharacterFromSet:notAllowed];
        
        //首字母不在alphaString中，且为合法的首字母，则加入到alphaString中
        if (![existingLetters containsObject:firstLetterInName] && range.location == NSNotFound )
        {
            [existingLetters addObject:firstLetterInName];
            self.alphaString = [self.alphaString stringByAppendingString:firstLetterInName];
        }
        
        //存放未排序的首字母
        NSMutableArray * rawAlphaArray = [NSMutableArray array];
        //存放排序后的首字母
        NSArray * alphaArray = [NSArray array];
        
        for (int i = 0; i < [self.alphaString length]; i++)
        {
            NSString *substr = [self.alphaString substringWithRange:NSMakeRange(i,1)];
            [rawAlphaArray addObject:substr];
        }
        //升序排序
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        alphaArray = [rawAlphaArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        //将升序的array转换成string
        self.alphaString = [alphaArray componentsJoinedByString:@""];
        
    }
    
    return [existingLetters count];
}

//获得当前section所有的名字
- (NSArray *)itemsInSection: (NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@",[self firstLetter:section]];
    return [self.friends filteredArrayUsingPredicate:predicate];
}

//获得当前section的首字母
- (NSString *)firstLetter: (NSInteger) section
{
    return [[self.alphaString substringFromIndex:section] substringToIndex:1];
}


#pragma mark LJIndexForTableView datasource methods
//以升序返回所有首字母
- (NSArray *)sectionIndexTitlesForLJIndexView:(LJIndexView *)indexView
{
    // in example 3 we want to show different index titles
    NSString *alpabeth = @"Ằdele Boss Cat Dog Egg Fog George Harry Idle Joke Key Luke Marry New Open Pot Rocket String Table Umbrella Violin Wind Xena Yellow Zyrro";

    NSMutableArray * results = [NSMutableArray array];
    
    for (int i = 0; i < [self.alphaString length]; i++)
    {
        NSString *substr = [self.alphaString substringWithRange:NSMakeRange(i,1)];
        [results addObject:substr];
    }
    
    if ([self.allExamples[2] boolValue])
    {
        return [alpabeth componentsSeparatedByString:@" "];
    }
    else
    {
        if ([self.allExamples[3] boolValue]) {
            NSMutableArray *lowerCaseResults = [NSMutableArray new];
            for (NSString *letter in results) {
                [lowerCaseResults addObject:[letter lowercaseString]];
            }
            results = lowerCaseResults;
        }
        return results;
    }
}


- (void)sectionForSectionLJIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
}

# pragma mark TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArray[section]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得当前cell的变量
    NSArray *sectionItem = self.sectionArray[indexPath.section];
    NSString *cellItem = sectionItem[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:self.indexView.font.fontName size:20.0];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@",cellItem];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = self.tableTextColor;
    cell.contentView.backgroundColor = self.tableColor;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.tintColor = self.tableHeaderColor;
    headerView.textLabel.textColor = self.tableHeaderTextColor;
    headerView.textLabel.font = [UIFont fontWithName:self.indexView.selectedItemFont.fontName size:headerView.textLabel.font.pointSize];
    [[headerView textLabel] setText:[NSString stringWithFormat:@"     %@",[self firstLetter:section]]];
    headerView.contentView.backgroundColor = COLOR_NAVIGATION_TITLE;
    return headerView;
}


#pragma mark reading/writting attributes for LJIndexItemsForTableView

- (void)readAttributes
{
    self.getSelectedItemsAfterPanGestureIsFinished = self.indexView.getSelectedItemsAfterPanGestureIsFinished;
    self.font = self.indexView.font;
    self.selectedItemFont = self.indexView.selectedItemFont;
    self.fontColor = self.indexView.fontColor;
    self.selectedItemFontColor = self.indexView.selectedItemFontColor;
    self.darkening = self.indexView.darkening;
    self.fading = self.indexView.fading;
    self.itemsAligment = self.indexView.itemsAligment;
    self.rightMargin = self.indexView.rightMargin;
    self.upperMargin = self.indexView.upperMargin;
    self.lowerMargin = self.indexView.lowerMargin;
    self.maxItemDeflection = self.indexView.maxItemDeflection;
    self.rangeOfDeflection = self.indexView.rangeOfDeflection;
    self.curtainColor = self.indexView.curtainColor;
    self.curtainFade = self.indexView.curtainFade;
    self.curtainMargins = self.indexView.curtainMargins;
    self.curtainStays = self.indexView.curtainStays;
    self.curtainMoves = self.indexView.curtainMoves;
    self.ergonomicHeight = self.indexView.ergonomicHeight;
}

- (void)writeAttributes
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = self.getSelectedItemsAfterPanGestureIsFinished;
    self.indexView.font = self.font;
    self.indexView.selectedItemFont = self.selectedItemFont;
    self.indexView.fontColor = self.fontColor;
    self.indexView.selectedItemFontColor = self.selectedItemFontColor;
    self.indexView.darkening = self.darkening;
    self.indexView.fading = self.fading;
    self.indexView.itemsAligment = self.itemsAligment;
    self.indexView.rightMargin = self.rightMargin;
    self.indexView.upperMargin = self.upperMargin;
    self.indexView.lowerMargin = self.lowerMargin;
    self.indexView.maxItemDeflection = self.maxItemDeflection;
    self.indexView.rangeOfDeflection = self.rangeOfDeflection;
    self.indexView.curtainColor = self.curtainColor;
    self.indexView.curtainFade = self.curtainFade;
    self.indexView.curtainMargins = self.curtainMargins;
    self.indexView.curtainStays = self.curtainStays;
    self.indexView.curtainMoves = self.curtainMoves;
    self.indexView.ergonomicHeight = self.ergonomicHeight;
}

@end
