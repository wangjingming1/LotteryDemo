//
//  LotteryBonusListView.h
//  Lottery
//  奖级、奖金列表
//  Created by wangjingming on 2020/3/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel;
@interface LotteryBonusListView : UIView
@property (nonatomic, strong) LotteryWinningModel *model;
@end

NS_ASSUME_NONNULL_END
