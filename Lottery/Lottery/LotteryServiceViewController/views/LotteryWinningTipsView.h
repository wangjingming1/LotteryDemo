//
//  LotteryWinningTipsView.h
//  Lottery
//  提醒视图(指定彩种一段时间的中奖信息顶部使用了这个提醒视图)
//  Created by wangjingming on 2020/2/29.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel;

@interface LotteryWinningTipsView : UIView
@property (nonatomic, strong)LotteryWinningModel *model;
@end

NS_ASSUME_NONNULL_END
