//
//  TrendChartSettingView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LotterySettingModel, MASViewAttribute;

@interface TrendChartSettingView : UIView
@property (nonatomic, copy) void (^finishBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, strong)NSArray <LotterySettingModel *> *settingArray;

- (instancetype)initWithTitle:(NSString *)title;
- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom;
@end

NS_ASSUME_NONNULL_END
