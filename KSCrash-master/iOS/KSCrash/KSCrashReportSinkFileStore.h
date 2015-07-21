//
//  KSCrashReportSinkFileStore.h
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/19.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

@interface KSCrashReportSinkFileStore : NSObject<KSCrashReportFilter>

+ (KSCrashReportSinkFileStore *)sinkWithFileStorePath:(NSString *)filePath withFileMeta:(NSString *)fileMeta;

- (instancetype)initWithFileStorePath:(NSString *)filePath withFileMeta:(NSString *)fileMeta;

- (id <KSCrashReportFilter>) defaultCrashReportFilterSetAppleFmt;

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet;

@end
