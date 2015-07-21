//
//  KSCrashReportSinkFileStore.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/19.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashReportSinkFileStore.h"

@interface KSCrashReportSinkFileStore ()

@property (nonatomic,strong)NSString *fileStorePath;

@property (nonatomic,strong)NSString *fileStoreMeta;

@end

@implementation KSCrashReportSinkFileStore

+ (KSCrashReportSinkFileStore *)sinkWithFileStorePath:(NSString *)filePath withFileMeta:(NSString *)fileMeta
{
    return [[self alloc]initWithFileStorePath:filePath withFileMeta:fileMeta];
}

- (instancetype)initWithFileStorePath:(NSString *)filePath withFileMeta:(NSString *)fileMeta
{
    if (self = [super init]) {
        
        if ([filePath isEqualToString:@""] || filePath == nil) {
            NSLog(@"%@ 初始化需要crash日志存储文件路径: %@",NSStringFromClass([KSCrashReportSinkFileStore Class]),filePath);
            return nil;
        }
        
        self.fileStorePath = [filePath copy];
        self.fileStoreMeta = [fileMeta copy];
    }
    return self;
}

- (id <KSCrashReportFilter>) defaultCrashReportFilterSetAppleFmt
{
    return [KSCrashReportFilterPipeline filterWithFilters:
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide],
            [KSCrashReportFilterStringToData filter],
            [KSCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
            self,
            nil];
}

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet
{
    return [KSCrashReportFilterPipeline filterWithFilters:
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],
            self,
            nil];
}

#pragma mark - 实际存储路径

- (void)filterReports:(NSArray *)reports onCompletion:(KSCrashReportFilterCompletion)onCompletion
{
    NSMutableString *logContent = [NSMutableString string];
    
    //填充当前时间
    
    //填充文件信息头
    [logContent appendFormat:@"==============================\n"];
    [logContent appendFormat:@"\n"];
    [logContent appendFormat:@"%@\n",self.fileStoreMeta];
    [logContent appendFormat:@"\n"];
    [logContent appendFormat:@"==============================\n"];
    
    NSInteger i = 0;
    for(NSString* report in reports)
    {
        NSLog(@"Report %d:\n%@", ++i, report);
        [logContent appendFormat:@"%@/n",report];
    }
    
    //保存文件
    NSData *fileData = [logContent dataUsingEncoding:NSUTF8StringEncoding];
    
    BOOL isSuccess =  [fileData writeToFile:self.fileStorePath atomically:YES];
    
    if (isSuccess) {
        
        kscrash_i_callCompletion(onCompletion, reports, YES,
                                 [NSError errorWithDomain:[[self class] description]
                                                     code:0
                                              description:@"保存日志文件成功"]);
    }else{
        
        kscrash_i_callCompletion(onCompletion, reports, YES,
                                 [NSError errorWithDomain:[[self class] description]
                                                     code:0
                                              description:@"保存日志文件失败"]);
    }
}

@end
