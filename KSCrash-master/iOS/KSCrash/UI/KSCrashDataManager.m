//
//  KSCrashDataManager.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashDataManager.h"
#import "KSCrash.h"

@implementation KSCrashDataManager

+ (NSArray *)reportList
{
    return [[KSCrash sharedInstance] allReports];
}

+ (NSDictionary *)reportByID:(NSString *)reportId
{
    return [[KSCrash sharedInstance] reportByReportID:reportId];
}

@end
