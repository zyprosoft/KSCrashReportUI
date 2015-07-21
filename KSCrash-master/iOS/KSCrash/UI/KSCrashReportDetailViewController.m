//
//  KSCrashReportDetailViewController.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashReportDetailViewController.h"
#import "KSCrashReportDetailCell.h"
#import "KSCrashDataManager.h"

@interface KSCrashReportDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *reportTable;

@property (nonatomic,strong)NSMutableArray *reportSourceArray;


@end

@implementation KSCrashReportDetailViewController

- (instancetype)initWithReportID:(NSString *)reportID;
{
    if (self  = [super init]) {
        
        self.reportSourceArray = [[NSMutableArray alloc]init];
        [self.reportSourceArray addObject:[NSMutableArray array]];
        [self.reportSourceArray addObject:[NSMutableArray array]];
        [self.reportSourceArray addObject:[NSMutableArray array]];
        
        [self detailWithReportID:reportID];
        
    }
    return self;
}

- (void)detailWithReportID:(NSString *)reportID
{
    NSDictionary *reportDict = [KSCrashDataManager reportByID:reportID];
    
    NSLog(@"reportDict :%@",reportDict);
    
    NSDictionary *crashDict = [reportDict objectForKey:@"crash"];
    
    [self addItem:@"diagnosis" content:crashDict[@"diagnosis"] titleColor:[UIColor redColor] contentColor:[UIColor blackColor] section:0];

    NSDictionary *errorDict = [crashDict objectForKey:@"error"];
    
    [self detailWithError:errorDict];
    
    NSDictionary *backtrace = [[crashDict objectForKey:@"threads"] firstObject];
    
    [self detailWithCrashThreadBackTrace:backtrace];
}

- (void)addItem:(NSString *)title content:(NSString *)content section:(NSInteger)section
{
    [self addItem:title content:content titleColor:[UIColor blackColor] contentColor:[UIColor blackColor] section:section];
}

- (void)addItem:(NSString *)title content:(NSString *)content titleColor:(UIColor *)tColor contentColor:(UIColor *)contentColor section:(NSInteger)section
{
    NSMutableArray *sectionArray = [self.reportSourceArray objectAtIndex:section];
    
    NSString *titleFormate = [NSString stringWithFormat:@"%@",title];
    NSString *contentFormate = [NSString stringWithFormat:@"%@",content];
    
    KSCrashItemContentModel *item = [[KSCrashItemContentModel alloc]init];
    item.title = titleFormate;
    item.content = contentFormate;
    item.titleColor = tColor;
    item.contentColor = contentColor;
    KSCrashReportDetailCell *cell = [[KSCrashReportDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setItemContent:item];
    item.contentHeight = [cell contentHeight];
    
    [sectionArray addObject:item];
    
}

- (void)detailWithError:(NSDictionary *)errorDict
{
    [self addItem:@"reason" content:[errorDict objectForKey:@"reason"] section:1];
    
    [self addItem:@"address" content:[errorDict objectForKey:@"address"] section:1];
    
    [self addItem:@"mach" content:[self dictionaryToContentString:[errorDict objectForKey:@"mach"]] section:1];
    
    [self addItem:@"type" content:[errorDict objectForKey:@"type"] section:1];

    [self addItem:@"exception" content:[self dictionaryToContentString:[errorDict objectForKey:@"nsexception"]] section:1];
    
    [self addItem:@"signal" content:[self dictionaryToContentString:[errorDict objectForKey:@"signal"]] section:1];

}

- (void)detailWithCrashThreadBackTrace:(NSDictionary *)traceDict
{
    NSDictionary *contentDict = [traceDict objectForKey:@"backtrace"];
    
    [self addItem:@"dispatch_queue" content:[traceDict objectForKey:@"dispatch_queue"] section:2];

    [self addItem:@"current_thread" content:[traceDict objectForKey:@"current_thread"] section:2];

    [self addItem:@"crashed" content:[traceDict objectForKey:@"crashed"] section:2];
    
    [self addItem:@"index" content:[traceDict objectForKey:@"index"] section:2];

    NSArray *symbols = [contentDict objectForKey:@"contents"];
    
    [self symbolsToString:symbols];
}

- (void)symbolsToString:(NSArray *)symbols
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString *bunldName =  infoDict[@"CFBundleName"];
    
    for (NSInteger index = 0; index < symbols.count ; index ++) {
        
        NSString *contentString = [self symbolsDictToString:[symbols objectAtIndex:index]];
        
        if ([contentString rangeOfString:bunldName].location != NSNotFound) {
            
            [self addItem:[NSString stringWithFormat:@"%d",index] content:contentString titleColor:[UIColor redColor] contentColor:[UIColor redColor] section:2];

        }else{
            
            [self addItem:[NSString stringWithFormat:@"%d",index] content:contentString section:2];

        }
        
    }
}

#define KSStringObject(x) [NSString stringWithFormat:@"%@",x]

- (NSString *)symbolsDictToString:(NSDictionary *)symbol
{
    NSMutableString *contentString = [NSMutableString string];
    
    [contentString appendString:KSStringObject([symbol objectForKey:@"object_name"])];
    
    [contentString appendString:@"    "];

    [contentString appendString:KSStringObject([symbol objectForKey:@"symbol_name"])];
    
    return contentString;
}

- (NSString *)dictionaryToContentString:(NSDictionary *)dict
{
    NSMutableString *contentString = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [contentString appendFormat:@"%@ : %@ \n",key,obj];
        
    }];
    
    return contentString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.reportTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight-44-20)];
    self.reportTable.backgroundColor = [UIColor whiteColor];
    self.reportTable.dataSource = self;
    self.reportTable.delegate = self;
    self.reportTable.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.reportTable];
    
}


#pragma mark - UITableView dataSource And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.reportSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.reportSourceArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [self.reportSourceArray objectAtIndex:indexPath.section];
    KSCrashItemContentModel *item = [sectionArray objectAtIndex:indexPath.row];
    
    return item.contentHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"关键原因";
            break;
        case 1:
            title = @"错误描述";
            break;
        case 2:
            title = @"崩溃线程回溯";
            break;
        default:
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    KSCrashReportDetailCell *cell = (KSCrashReportDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[KSCrashReportDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *sectionArray = [self.reportSourceArray objectAtIndex:indexPath.section];
    [cell setItemContent:[sectionArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
