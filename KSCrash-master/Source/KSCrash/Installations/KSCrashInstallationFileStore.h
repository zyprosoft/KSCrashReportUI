//
//  KSCrashInstallationFileStore.h
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/19.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import <KSCrash/KSCrash.h>

@interface KSCrashInstallationFileStore : KSCrashInstallation

@property (nonatomic,strong)NSString *filePath;

@property (nonatomic,strong)NSString *fileMeta;

+ (KSCrashInstallationStandard*) sharedInstance;

@end
