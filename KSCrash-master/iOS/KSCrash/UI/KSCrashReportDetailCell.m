//
//  KSCrashReportDetailCell.m
//  KSCrash-iOS
//
//  Created by ZYVincent on 15/5/20.
//  Copyright (c) 2015年 Karl Stenerud. All rights reserved.
//

#import "KSCrashReportDetailCell.h"


@interface KSCrashReportDetailCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *seprateLine;

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,assign)CGFloat contentMargin;

@property (nonatomic,assign)CGFloat cellMargin;

@property (nonatomic,assign)CGFloat titleFontSize;

@property (nonatomic,assign)CGFloat contentFontSize;

@end

@implementation KSCrashReportDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleFontSize = 13.f;
        self.contentFontSize = 13.f;
        self.cellMargin = 7.f;
        self.contentMargin = 8.f;
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.frame = CGRectMake(self.cellMargin, self.cellMargin, 40, 30);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = [UIFont systemFontOfSize:self.contentFontSize];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.seprateLine = [[UIImageView alloc]init];
        self.seprateLine.frame = CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width + self.contentMargin, self.cellMargin, 0.5, 30);
        self.seprateLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.seprateLine];
    
    }
    return self;
}

- (void)setItemContent:(KSCrashItemContentModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    self.titleLabel.textColor = contentModel.titleColor;
    self.contentLabel.textColor = contentModel.contentColor;
    
    self.titleLabel.text = contentModel.title;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentOrigin = (self.seprateLine.frame.origin.x + self.seprateLine.frame.size.width + self.contentMargin);
    CGFloat contentWidth = screenWidth - contentOrigin;
    
    CGSize contentSize = [contentModel.content sizeWithFont:[UIFont systemFontOfSize:self.contentFontSize] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.contentLabel.frame = CGRectMake(contentOrigin, self.cellMargin, contentWidth, contentSize.height);
    self.contentLabel.text = contentModel.content;
    
    CGFloat bottomLineOriginY = MAX(self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+self.cellMargin, 44);

    if (bottomLineOriginY == 44) {
        
        self.contentLabel.center = CGPointMake(self.contentLabel.center.x, 22);
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, 22);
    }
}

- (CGFloat)contentHeight
{
    CGFloat bottomLineOriginY = MAX(self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+self.cellMargin, 44);

    return bottomLineOriginY;
}

@end
