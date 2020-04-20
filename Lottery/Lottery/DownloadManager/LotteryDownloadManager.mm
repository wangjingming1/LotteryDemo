//
//  LotteryDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryDownloadManager.h"
#import "LotteryKindName.h"
#import "GlobalDefines.h"

#import "HttpManager.h"

#import "LotteryWinningModel.h"
#import "LotteryPlayRulesModel.h"
#import "NSDate+ExtendedDate.h"

@implementation LotteryDownloadManager

+ (void)lotteryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSDictionary <NSString *, NSArray <LotteryWinningModel *>*> *lotteryDict))finsh {
    NSMutableDictionary *lotteryDict = [@{} mutableCopy];
#ifdef kTEST
    for (NSString *ide in identifiers){
        NSArray *array = [LotteryDownloadManager lotteryWinningModelRandomizedByIdentifier:ide begin:begin count:count];
        lotteryDict[ide] = array;
    }
    if (finsh){
        finsh(lotteryDict);
    }
#else
    NSString *url = @"";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[@"begin"] = [NSString stringWithFormat:@"%ld", begin];
    params[@"count"] = [NSString stringWithFormat:@"%ld", count];
    NSString *ides = @"";
    for (int i = 0; i < identifiers.count; i++){
        [ides stringByAppendingString:identifiers[i]];
        if (i <= identifiers.count - 1){
            [ides stringByAppendingString:@","];
        }
    }
    params[@"identifiers"] = ides;
    [HttpManager http:url params:params finsh:^(id  _Nonnull responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        LotteryWinningModel *model = [[LotteryWinningModel alloc] initWithDict:dic];
        [array addObject:model];
        for (NSString *ide in [dic allKeys]){
            NSMutableArray *lotteryArray = [@[] mutableCopy];
            for (NSDictionary *lotteryDict in lotteryArray){
                LotteryWinningModel *model = [[LotteryWinningModel alloc] initWithDict:lotteryDict];
                [lotteryArray addObject:model];
            }
            lotteryDict[ide] = lotteryArray;
        }
        if (finsh){
            finsh(lotteryDict);
        }
    }];
#endif
}
#pragma mark - test newRandomized
+ (NSArray <LotteryWinningModel *> *)lotteryWinningModelRandomizedByIdentifier:(NSString *)identifier begin:(NSInteger)begin count:(NSInteger)count{
    
    NSMutableArray <LotteryWinningModel *>*winningModelArray = [@[] mutableCopy];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"playRules" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *dict = [jsonDict objectForKey:@"data"];
    NSDictionary *playRulesDict = [dict objectForKey:identifier];
    
    if (playRulesDict) {
        LotteryPlayRulesModel *playRulesModel = [LotteryPlayRulesModel initLotteryPlayRulesModelWithDict:playRulesDict];
        playRulesModel.identifier = identifier;
        
        NSArray *dateArray = [LotteryDownloadManager getLotteryTimeArrayByPlayRulesModel:playRulesModel begin:begin count:count];
        NSString *icon = [LotteryWinningModel identifierToString:identifier type:@"icon"];
        NSString *name = [LotteryWinningModel identifierToString:identifier type:@"name"];
        for (NSInteger i = 0; i < dateArray.count; i++){
            LotteryWinningModel *model = [[LotteryWinningModel alloc] init];
            model.identifier = identifier;
            model.icon = icon;
            model.kindName = name;
            model.issueNumber = [LotteryDownloadManager getIssueNumber:i+begin dateStr:dateArray[i]];
            model.date = dateArray[i];
            model.testNumber = [LotteryDownloadManager getTestNumber:identifier];
            model.lotteryTime = playRulesModel.lotteryShowTime;
            model.playRulesModel = playRulesModel;
            model.newest = (begin == 0 && i == 0);
            //设置中奖号码
            [LotteryDownloadManager setLotteryWinningModelSalesAndBall:model playRulesModel:playRulesModel];
            //设置奖级信息
            [LotteryDownloadManager setLotteryWinningModelPrize:model playRulesModel:playRulesModel];
            [winningModelArray addObject:model];
        }
    }
    return winningModelArray;
}

+ (NSArray <NSString *> *)getLotteryTimeArrayByPlayRulesModel:(LotteryPlayRulesModel *)model begin:(NSInteger)begin count:(NSInteger)count{
    NSString *lotteryTimeStr = model.lotteryTime;
    NSArray *otherArray = [lotteryTimeStr componentsSeparatedByString:@","];
    if (otherArray.count < 2) return @[];
    //时间
    NSString *lotteryTime = otherArray.lastObject;
    //星期几
    NSArray *weekday = [otherArray subarrayWithRange:NSMakeRange(0, otherArray.count - 1)];
    NSMutableArray *weekdayArray = [@[] mutableCopy];
    NSArray *allWeekdayArray = [NSDate getWeekdayArray];
    for (NSString *str in weekday){
        //转成数组下标，不能从1开始，需要-1
        NSInteger weekdayIndex = [str integerValue] - 1;
        //我们这里的星期列表是从周日开始的，所以还需要将下标转成我们的列表下标
        weekdayIndex = (weekdayIndex + 1)%allWeekdayArray.count;
        [weekdayArray addObject:allWeekdayArray[weekdayIndex]];
    }
    NSDate *currentDate = [NSDate date];
    NSMutableArray *dateArray = [@[] mutableCopy];
    //从今天开始往前推dayCount天
    NSInteger i = 0;
    //符合开奖日期的时间数量
    NSInteger dayCount = 0;
    do {
        //往前推i天的时间
        NSTimeInterval days = -(24 * 60 * 60 * i);  // (24 * 60 * 60)表示一天一共有多少秒
        NSDate *appointDate = [currentDate dateByAddingTimeInterval:days];
        NSString *weekdata = [NSDate weekdayStringWithDate:appointDate];
        //判断是否是开奖日期(如大乐透是每周一、三、六 20:30开奖)
        if ([weekdayArray indexOfObject:weekdata] != NSNotFound){
            if (dayCount >= begin){
                if (i == 0 && begin == 0){
                    //如果今天恰好是开奖日期，判断是否到了开奖时间
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSString *dateTime = [formatter stringFromDate:currentDate];
                    NSDate *timeDate = [formatter dateFromString:dateTime];
                    NSDate *lotteryTimeDate = [formatter dateFromString:lotteryTime];
                    NSComparisonResult result = [timeDate compare:lotteryTimeDate];
                    if (result == NSOrderedSame || result == NSOrderedAscending){
                        continue;
                    }
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:kDefaultDateFormat];
                //获取当前时间日期展示字符串 如：05.23
                NSString *appointDateStr = [formatter stringFromDate:appointDate];
                [dateArray addObject:appointDateStr];
                if (dateArray.count == count) {
                    break;
                }
            }
            dayCount++;
        }
    } while (++i);
    return dateArray;
}

+ (void)setLotteryWinningModelSalesAndBall:(LotteryWinningModel *)model playRulesModel:(LotteryPlayRulesModel *)playRulesModel {
    NSString *identifier = model.identifier;
    long long sales = 0;
    long long jackpot = 0;
    if (kLotteryIsShuangseqiu(identifier)){
        sales = 200000000 + arc4random_uniform(300000000);//2亿，3亿
        jackpot = sales + 100000000 + arc4random_uniform(200000000);//1亿，2亿
    } else if (kLotteryIsDaletou(identifier)){
        sales = 200000000 + arc4random_uniform(200000000);//2亿，2亿
        jackpot = sales + 1000000000 + arc4random_uniform(500000000);//10亿，5亿
    } else if (kLotteryIsFucai3d(identifier)){
        sales = 50000000 + arc4random_uniform(1000000);//5千万，1百万
        model.testNumber = [LotteryDownloadManager getTestNumber:identifier];
    } else if (kLotteryIsPailie3(identifier)){
        sales = 10000000 + arc4random_uniform(30000000);//1千万，3千万
    } else if (kLotteryIsPailie5(identifier)){
        sales = 10000000 + arc4random_uniform(6000000);//1千万，6百万
        jackpot = 300000000 + arc4random_uniform(100000000);//3亿，1亿
    } else if (kLotteryIsQixingcai(identifier)){
        sales = 10000000 + arc4random_uniform(10000000);//1千万，1千万
        jackpot = sales + 5000000 + arc4random_uniform(10000000);//5百万，1千万
    } else if (kLotteryIsQilecai(identifier)){
        sales = 5000000 + arc4random_uniform(5000000);//5百万，5百万
        if (random()%2 != 0) {
            jackpot = 1000000 + arc4random_uniform(1000000);//1百万，1百万
        }
    }
    model.sales = [NSString stringWithFormat:@"%lld", sales];
    model.jackpot = [NSString stringWithFormat:@"%lld", jackpot];
    model.redBall = [LotteryDownloadManager getRandomBallByMaxNumber:playRulesModel.redBullRange.length minNumber:playRulesModel.redBullRange.location maxCount:playRulesModel.redBullCount allowDuplicate:playRulesModel.redBullSame isSort:playRulesModel.sortOrder];
    model.blueBall = [LotteryDownloadManager getRandomBallByMaxNumber:playRulesModel.blueBullRange.length minNumber:playRulesModel.blueBullRange.location maxCount:playRulesModel.blueBullCount allowDuplicate:playRulesModel.blueBullSame isSort:playRulesModel.sortOrder];
}

+ (void)setLotteryWinningModelPrize:(LotteryWinningModel *)model playRulesModel:(LotteryPlayRulesModel *)playRulesModel {
    NSMutableArray <LotteryPrizeModel *> *prizeModels = [@[] mutableCopy];
    double percentage = [playRulesModel.percentage doubleValue];
    //可用奖金总额
    double sales = [model.sales doubleValue]*percentage + [model.jackpot doubleValue]*0.1;
    //去掉固定奖剩余奖金总额
    double surplusSales = sales;
    //奖级的奖金为浮动奖金数组
    NSMutableArray *floatSalesArray = [@[] mutableCopy];
    for (LotteryPrizeInfoModel *prizeInfo in playRulesModel.prizeInfoArray){
        LotteryPrizeModel *prizeModel = [[LotteryPrizeModel alloc] init];
        prizeModel.level = prizeInfo.level;
        //根据规则随机中奖注数
        NSRange lotteryNumberRange = prizeInfo.testBonus.lotteryNumberRange;
        NSUInteger lotteryNum = lotteryNumberRange.location + arc4random_uniform((unsigned int)(lotteryNumberRange.length - lotteryNumberRange.location));
        
        prizeModel.number = [NSString stringWithFormat:@"%ld", lotteryNum];
        prizeModel.bonus = prizeInfo.bonus;
        if ([prizeInfo.bonus isEqualToString:@""]){
            //储存浮动奖金的奖级、百分比及最大奖金字典
            NSMutableDictionary *floatSalesDict = [@{} mutableCopy];
            if (![prizeInfo.testBonus.bonus isEqualToString:@""]){
                floatSalesDict[@"maxBonus"] = prizeInfo.testBonus.bonus;
            }
            
            floatSalesDict[@"percentage"] = prizeInfo.testBonus.percentage;
            floatSalesDict[@"level"] = prizeInfo.level;
            
            [floatSalesArray addObject:floatSalesDict];
        }
        [prizeModels addObject:prizeModel];
        double tempSales = [prizeInfo.bonus doubleValue] * lotteryNum;
        surplusSales -= tempSales;
    }
    for (LotteryPrizeModel *prizeModel in prizeModels){
        if (![prizeModel.bonus isEqualToString:@""]) continue;
        for (NSDictionary *dict in floatSalesArray){
            if ([prizeModel.level isEqualToString:[dict objectForKey:@"level"]]){
                double maxBonus = 1e8;
                if ([dict objectForKey:@"maxBonus"]){
                    maxBonus = [[dict objectForKey:@"maxBonus"] doubleValue];
                }
                double percentage = [[dict objectForKey:@"percentage"] doubleValue];
                long long bonus = 0;
                if ([prizeModel.number integerValue] > 0){
                    bonus = (surplusSales*percentage)/[prizeModel.number integerValue];
                }
                if (bonus < 0 || bonus > maxBonus){
                    bonus = maxBonus;
                }
                prizeModel.bonus = [NSString stringWithFormat:@"%lld", bonus];
                [floatSalesArray removeObject:dict];
                break;
            }
        }
        if (floatSalesArray.count == 0) break;
    }
    model.prizeArray = prizeModels;
}

+ (NSString *)getTestNumber:(NSString *)identifier{
    if ([identifier isEqualToString:@"fucai3d"]){
        NSString *testNumber = [LotteryDownloadManager getRandomBallByMaxNumber:9 minNumber:0 maxCount:3 allowDuplicate:YES isSort:NO];
        NSString *doneTestNumber = @"";
        for (int i = 0; i < testNumber.length; i++) {
            doneTestNumber = [doneTestNumber stringByAppendingString:[testNumber substringWithRange:NSMakeRange(i, 1)]];
            if (i%2 == 1 && i+1 != testNumber.length) {
                doneTestNumber = [NSString stringWithFormat:@"%@ ", doneTestNumber];
            }
        }
    }
    return @"";
}

+ (NSString *)getIssueNumber:(NSInteger)number dateStr:(NSString *)dateStr{
    number = number + 1;
    NSDateFormatter *originFormatter = [[NSDateFormatter alloc] init];
    [originFormatter setDateFormat:kDefaultDateFormat];
    NSDate *date = [originFormatter dateFromString:dateStr];
    
    [originFormatter setDateFormat:@"yyyy"];
    NSString *year = [originFormatter stringFromDate:date];
    if (number > 0 && number < 10){
        return [NSString stringWithFormat:@"%@00%ld期", year, number];
    }
    if (number >= 10 && number < 100){
        return [NSString stringWithFormat:@"%@0%ld期", year, number];
    }
    return [NSString stringWithFormat:@"%@%ld期", year, number];
}

+ (NSString *)getRandomBallByMaxNumber:(NSInteger)maxNumber minNumber:(NSInteger)minNumber maxCount:(NSInteger)maxCount allowDuplicate:(BOOL)allowDuplicate isSort:(BOOL)isSort{
    NSMutableArray *array = [@[] mutableCopy];
    //相关规则的maxCount是指模拟选号允许选择的数量, 如果为0并且最大最小值不为0的话，暂时给你一个球吧
    if (minNumber + maxNumber > 0 && maxCount == 0){
        maxCount = 1;
    }
    if (allowDuplicate){
        while (array.count < maxCount) {
            NSInteger value = arc4random() % (maxNumber - minNumber + 1) + minNumber;
            [array addObject:[NSNumber numberWithInteger:value]];
        }
    } else {
        NSMutableSet *set = [NSMutableSet setWithCapacity:maxCount];
        while (set.count < maxCount) {
            NSInteger value = arc4random() % (maxNumber - minNumber + 1) + minNumber;
            [set addObject:[NSNumber numberWithInteger:value]];
        }
        array = [[set allObjects] mutableCopy];
    }
    if (isSort){
        for (int i = 0; i < array.count; i++) {
            for (int j = 0; j < array.count - i-1; j++) {
                if ([array[j] intValue] > [array[j + 1] intValue]) {
                    int tmp = [array[j] intValue];
                    array[j] = array[j + 1];
                    array[j + 1] = [NSNumber numberWithInt:tmp];
                }
            }
        }
    }
    NSString *ballStr = @"";
    for (NSUInteger i = 0; i < array.count; i++){
        if (i != 0){
            ballStr = [ballStr stringByAppendingString:@","];
        }
        NSInteger number =  [array[i] integerValue];
        NSString *numberStr = [NSString stringWithFormat:@"%ld", number];
        if (number < 10 && maxNumber >= 10){
            numberStr = [NSString stringWithFormat:@"0%@", numberStr];
        }
        ballStr = [ballStr stringByAppendingString:numberStr];
    }
    return ballStr;
}
@end
