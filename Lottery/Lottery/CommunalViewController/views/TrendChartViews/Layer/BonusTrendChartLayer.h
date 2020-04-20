//
//  TrendChartLayer.h
//  Lottery
//
//  Created by wangjingming on 2020/3/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN
@class BonusTrendChartModel;

@interface BonusTrendChartLayer : CALayer
@property (nonatomic) CGRect drawRect;
@property (nonatomic, strong) BonusTrendChartModel *model;
@property (nonatomic) CGFloat footnoteHeight;   //20
@property (nonatomic) CGFloat lineWidth;        //1
@property (nonatomic) BOOL showFootnote;        //YES

- (void)startAnimated;
@end

NS_ASSUME_NONNULL_END
