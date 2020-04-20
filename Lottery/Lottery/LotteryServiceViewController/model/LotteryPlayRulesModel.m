//
//  LotteryPlayRulesModel.m
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPlayRulesModel.h"

@implementation LotteryPlayRulesModel
+ (LotteryPlayRulesModel *)initLotteryPlayRulesModelWithDict:(NSDictionary *)dict{
    LotteryPlayRulesModel *model = [[LotteryPlayRulesModel alloc] init];
    model.kindName = [dict objectForKey:@"title"];
    model.sortOrder = [[dict objectForKey:@"sortOrder"] boolValue];
    model.lotteryShowTime = [dict objectForKey:@"lotteryTimeStr"];
    model.lotteryTime = [dict objectForKey:@"lotteryTime"];
    model.percentage = [dict objectForKey:@"percentage"];
    model.multipleBets = [dict objectForKey:@"multipleBets"];
    //----------------------------------------------------手动分割线
    NSArray <NSDictionary *> *prizeInfoArray = [dict objectForKey:@"lotteryPrize"];
    NSMutableArray <LotteryPrizeInfoModel *> *prizeInfoModelArray = [@[] mutableCopy];
    for (NSDictionary *prizeInfoDict in prizeInfoArray){
        LotteryPrizeInfoModel *prizeInfoModel = [LotteryPrizeInfoModel initLotteryPrizeInfoModelWithDict:prizeInfoDict];
        [prizeInfoModelArray addObject:prizeInfoModel];
    }
    model.prizeInfoArray = prizeInfoModelArray;

    //----------------------------------------------------手动分割线
    NSDictionary *redBullRules = [dict objectForKey:@"redBall"];
    model.redBullSame = [[redBullRules objectForKey:@"same"] boolValue];
    model.redBullCount = [[redBullRules objectForKey:@"count"] integerValue];
    model.redBullMultipleMaxCount = [[redBullRules objectForKey:@"multipleMaxCount"] integerValue];
    NSString *redBullRangeStr = [redBullRules objectForKey:@"scope"];
    NSArray *redBullRangeArray = [redBullRangeStr componentsSeparatedByString:@","];
    if (redBullRangeArray.count == 2){
        model.redBullRange = NSMakeRange([redBullRangeArray.firstObject integerValue], [redBullRangeArray.lastObject integerValue]);
    }
    
    //----------------------------------------------------手动分割线
    NSDictionary *blueBullRules = [dict objectForKey:@"blueBall"];
    model.blueBullSame = [[blueBullRules objectForKey:@"same"] boolValue];
    model.blueBullCount = [[blueBullRules objectForKey:@"count"] integerValue];
    model.blueBullMultipleMaxCount = [[blueBullRules objectForKey:@"multipleMaxCount"] integerValue];
    NSString *blueBullRangeStr = [blueBullRules objectForKey:@"scope"];
    NSArray *blueBullRangeArray = [blueBullRangeStr componentsSeparatedByString:@","];
    if (blueBullRangeArray.count == 2){
        model.blueBullRange = NSMakeRange([blueBullRangeArray.firstObject integerValue], [blueBullRangeArray.lastObject integerValue]);
    }
    
    return model;
}

@end


@implementation LotteryPrizeInfoModel
+ (LotteryPrizeInfoModel *)initLotteryPrizeInfoModelWithDict:(NSDictionary *)dict{
    LotteryPrizeInfoModel *model = [[LotteryPrizeInfoModel alloc] init];
    model.level = [dict objectForKey:@"level"];
    model.bonus = [dict objectForKey:@"bonus"];
    
    NSArray <NSDictionary *> *winningRulesArray = [dict objectForKey:@"winningRules"];
    NSMutableArray <LotteryWinningRulesModel *> *winningRulesModelArray = [@[] mutableCopy];
    for (NSDictionary *winningRulesDict in winningRulesArray){
        LotteryWinningRulesModel *winningRulesModel = [LotteryWinningRulesModel initLotteryWinningRulesModelWithDict:winningRulesDict];
        [winningRulesModelArray addObject:winningRulesModel];
    }
    model.winningRulesArray = winningRulesModelArray;
    
    NSDictionary *testbonusDict = [dict objectForKey:@"testbonus"];
    if (testbonusDict){
        LotteryTestBonus *textBonus = [LotteryTestBonus initLotteryTestBonusWithDict:testbonusDict];
        model.testBonus = textBonus;
    }
    return model;
}


@end


@implementation LotteryWinningRulesModel

+ (LotteryWinningRulesModel *)initLotteryWinningRulesModelWithDict:(NSDictionary *)dict{
    LotteryWinningRulesModel *model = [[LotteryWinningRulesModel alloc] init];
    model.redBullSameCount = [[dict objectForKey:@"red"] integerValue];
    model.blueBullSameCount = [[dict objectForKey:@"blue"] integerValue];
    model.consistency = [[dict objectForKey:@"consistency"] boolValue];
    return model;
}

@end


@implementation LotteryTestBonus
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.percentage = @"";
        self.bonus = @"";
    }
    return self;
}

+ (LotteryTestBonus *)initLotteryTestBonusWithDict:(NSDictionary *)dict{
    LotteryTestBonus *model = [[LotteryTestBonus alloc] init];
    NSString *bonus = [dict objectForKey:@"bonus"];
    NSArray *array = [bonus componentsSeparatedByString:@","];
    if (array.count == 1){
        double number = [array.firstObject doubleValue];
        if (number < 1){
            model.percentage = array.firstObject;
        } else {
            model.bonus = array.firstObject;
        }
    } else if (array.count > 1){
        model.percentage = array.firstObject;
        model.bonus = array.lastObject;
    }
    NSString *lotteryNumberStr = [dict objectForKey:@"lotteryNumber"];
    NSArray *lotteryNumberArray = [lotteryNumberStr componentsSeparatedByString:@","];
    if (lotteryNumberArray.count == 2){
        model.lotteryNumberRange = NSMakeRange([lotteryNumberArray.firstObject integerValue], [lotteryNumberArray.lastObject integerValue]);
        
    }
    return model;
}

@end
