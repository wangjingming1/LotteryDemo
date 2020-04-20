//
//  BonusView.h
//  Lottery
//  算奖工具(根据我的投注、命中计算后的奖金)
//  Created by wangjingming on 2020/3/13.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryPrizeModel;

@interface BonusView : UIView
@property (nonatomic, strong) NSArray<LotteryPrizeModel *> *prizeModelArray;
@end

NS_ASSUME_NONNULL_END
