//
//  LotteryInformationAccess.h
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryInformationAccess : NSObject
//开奖服务-查看历史
+ (void)setLotteryViewingHistory:(NSString *)lotteryIde;
+ (NSArray *)getLotteryViewingHistoryArray;

//首页-省份列表
+ (void)setLotteryCurrentCity:(NSString *)currentCity;
+ (NSString *)getLotteryCurrentCity;
+ (NSArray *)getLotteryCityHistoryArray;
@end

NS_ASSUME_NONNULL_END
