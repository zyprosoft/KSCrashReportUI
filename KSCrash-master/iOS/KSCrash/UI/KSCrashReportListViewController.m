//
//  KSCrashReportListViewController.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashReportListViewController.h"
#import "KSCrashDataManager.h"
#import "KSCrashReportStore.h"
#import "KSCrashReportDetailViewController.h"

@interface KSCrashReportListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)NSMutableArray *reportListArray;

@property (nonatomic,strong)NSDateFormatter *dateFormatter;

@end

@implementation KSCrashReportListViewController

- (instancetype)init
{
    if (self = [super init]) {

        //
        self.reportListArray = [[NSMutableArray alloc]init];
        
        [self.reportListArray addObjectsFromArray:[KSCrashDataManager reportList]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    self.listTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight-44-20)];
    self.listTable.backgroundColor = [UIColor whiteColor];
    self.listTable.dataSource = self;
    self.listTable.delegate = self;
    [self.view addSubview:self.listTable];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [self.dateFormatter setDateFormat:@"Y-M-d HH:mm:ss"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setupCancelBtn:cancelBtn];
    
    //响应事件
    [cancelBtn addTarget:self action:@selector(dismissPickerViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //设置Item
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem = nil;
    
}

- (void)setupCancelBtn:(UIButton *)button
{
    button.frame = CGRectMake(0, 0, 40, 20);
    //标题
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    //标题状态颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)dismissPickerViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView dataSource And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    KSCrashReportInfo *info = [self.reportListArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = info.reportID;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:info.creationDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSCrashReportInfo *info = [self.reportListArray objectAtIndex:indexPath.row];

    KSCrashReportDetailViewController *detailVC = [[KSCrashReportDetailViewController alloc]initWithReportID:info.reportID];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
