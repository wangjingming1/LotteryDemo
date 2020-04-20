//
//  BonusTrendChartView.h
//  Lottery
//  走势图-奖金走势
//  Created by wangjingming on 2020/3/26.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusTrendChartModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MASViewAttribute, BonusTrendChartModel;

@interface BonusTrendChartView : UIView

@property (nonatomic, strong) NSArray<BonusTrendChartModel *> *modelArray;

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom;
@end

NS_ASSUME_NONNULL_END
