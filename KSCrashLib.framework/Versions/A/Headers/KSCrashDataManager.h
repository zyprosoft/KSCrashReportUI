//
//  KSCrashDataManager.h
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCrashDataManager : NSObject

+ (NSArray *)reportList;

+ (NSDictionary *)reportByID:(NSString *)reportId;

@end
