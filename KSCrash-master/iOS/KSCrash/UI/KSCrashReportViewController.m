//
//  KSCrashReportViewController.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/21.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashReportViewController.h"
#import "KSCrashReportListViewController.h"

@interface KSCrashReportViewController ()

@end

@implementation KSCrashReportViewController

- (instancetype)init
{
    KSCrashReportListViewController *listVC = [[KSCrashReportListViewController alloc]init];
    
    if (self = [super initWithRootViewController:listVC]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}


@end
