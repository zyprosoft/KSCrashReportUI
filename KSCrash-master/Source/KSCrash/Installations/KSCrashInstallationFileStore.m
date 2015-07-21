//
//  KSCrashInstallationFileStore.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/19.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashInstallationFileStore.h"
#import "KSCrashReportSinkFileStore.h"

@implementation KSCrashInstallationFileStore

IMPLEMENT_EXCLUSIVE_SHARED_INSTANCE(KSCrashInstallationFileStore)

- (id) init
{
    if((self = [super initWithRequiredProperties:[NSArray arrayWithObjects:
                                                  @"fileMeta",
                                                  @"filePath",
                                                  nil]]))
    {
    }
    return self;
}

- (id<KSCrashReportFilter>) sink
{
    KSCrashReportSinkFileStore* sink = [KSCrashReportSinkFileStore sinkWithFileStorePath:self.filePath withFileMeta:self.fileMeta];
    return [sink defaultCrashReportFilterSet];
}

@end
