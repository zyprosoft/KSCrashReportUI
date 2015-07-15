//
//  KSCrashItemContentModel.h
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSCrashItemContentModel : NSObject

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,strong)UIColor *titleColor;

@property (nonatomic,strong)UIColor *contentColor;

@property (nonatomic,assign)CGFloat contentHeight;

@end
