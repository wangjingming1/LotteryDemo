//
//  LotteryWinningModel.h
//  Lottery
//  彩种及信息
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LotteryPrizeModel, LotteryPlayRulesModel;

@interface LotteryWinningModel : NSObject
/**彩票标示码*/
@property (nonatomic, copy) NSString *identifier;
/**彩票种类*/
@property (nonatomic, copy) NSString *kindName;
/**图标*/
@property (nonatomic, copy) NSString *icon;
/**期数*/
@property (nonatomic, copy) NSString *issueNumber;
/**日期*/
@property (nonatomic, copy) NSString *date;
/**销量*/
@property (nonatomic, copy) NSString *sales;
/**奖池*/
@property (nonatomic, copy) NSString *jackpot;
/**红球*/
@property (nonatomic, copy) NSString *redBall;
/**篮球*/
@property (nonatomic, copy) NSString *blueBall;
/**试机号*/
@property (nonatomic, copy) NSString *testNumber;
/**开奖时间*/
@property (nonatomic, copy) NSString *lotteryTime;

/**是否是最新一期*/
@property (nonatomic) BOOL newest;

/**界面使用，表示当前view是否显示中奖列表*/
@property (nonatomic) BOOL showPrizeView;

/**规则相关*/
@property (nonatomic, strong) LotteryPlayRulesModel *playRulesModel;

/**奖级及中奖注数*/
@property (nonatomic, strong) NSArray <LotteryPrizeModel *> *prizeArray;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSString *)identifierToString:(NSString *)identifier type:(NSString *)type;

- (NSString *)dateToGeneralFormat;

- (NSArray <LotteryPrizeModel *> *)calculatorPrizeArrayWithSelectRedCount:(int)selectRedCount selectBlueCount:(int)selectBlueCount guessRedCount:(int)guessRedCount guessBlueCount:(int)guessBlueCount;
@end


@interface LotteryPrizeModel : NSObject
/**奖级*/
@property (nonatomic, copy) NSString *level;
/**中奖注数*/
@property (nonatomic, copy) NSString *number;
/**单注奖金*/
@property (nonatomic, copy) NSString *bonus;

@property (nonatomic, copy) NSString *gender;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
NS_ASSUME_NONNULL_END
