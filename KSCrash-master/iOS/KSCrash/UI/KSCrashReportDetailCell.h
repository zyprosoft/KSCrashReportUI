//
//  KSCrashReportDetailCell.h
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCrashItemContentModel.h"

@interface KSCrashReportDetailCell : UITableViewCell

- (void)setItemContent:(KSCrashItemContentModel *)contentModel;

- (CGFloat)contentHeight;

@end
