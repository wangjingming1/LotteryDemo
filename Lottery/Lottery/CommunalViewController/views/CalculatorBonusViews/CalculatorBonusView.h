//
//  CalculatorBonusView.h
//  Lottery
//  算奖工具顶部的菜单下面显示的界面(期次选择、我的投注、我的命中)
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel, CalculatorBonusView;

@protocol CalculatorBonusViewDelegate <NSObject>

@optional
- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showIssueNumberSelector:(void(^)(LotteryWinningModel *newModel))result;

- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showMySelectBallSelector:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount result:(void(^)(NSString *newRedCount, NSString *newBlueCount))result;
- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showMyTargetBallSelector:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount result:(void(^)(NSString *newRedCount, NSString *newBlueCount))result;
@end

@interface CalculatorBonusView : UIView
@property (nonatomic, weak) id <CalculatorBonusViewDelegate> delegate;
@property (nonatomic, strong)LotteryWinningModel *model;
@property (nonatomic) BOOL initSelectBall; //default NO;

@end

NS_ASSUME_NONNULL_END
