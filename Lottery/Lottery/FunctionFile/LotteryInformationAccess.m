//
//  LotteryInformationAccess.m
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryInformationAccess.h"
#import "GlobalDefines.h"

//开奖服务-查看历史
static NSString * const LSVCViewingHistory = @"kLSVCViewingHistory";

//首页(省份列表)-当前城市
static NSString * const HPVCCurrentCityArray = @"HPVCCurrentCityArray";
//首页(省份列表)-历史访问城市
static NSString * const HPVCHistoryCityArray = @"HPVCHistoryCityArray";

@implementation LotteryInformationAccess
+ (void)setLotteryViewingHistory:(NSString *)lotteryIde{
    NSMutableArray *array = [[LotteryInformationAccess getLotteryViewingHistoryArray] mutableCopy];
    if (!array){
        array = [@[] mutableCopy];
    }
    [array removeObject:lotteryIde];
    [array addObject:lotteryIde];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:LSVCViewingHistory];
}

+ (NSArray *)getLotteryViewingHistoryArray{
    NSArray *viewingHistoryArray = [[NSUserDefaults standardUserDefaults] objectForKey:LSVCViewingHistory];
    return viewingHistoryArray;
}

+ (void)setLotteryCurrentCity:(NSString *)currentCity{
    NSMutableArray *cityHistoryArray = [[LotteryInformationAccess getLotteryCityHistoryArray] mutableCopy];
    if (!cityHistoryArray){
        cityHistoryArray = [@[] mutableCopy];
    }
    [cityHistoryArray removeObject:currentCity];
    if ([cityHistoryArray containsObject:@"全国"]){
        [cityHistoryArray insertObject:currentCity atIndex:1];
    } else {
        [cityHistoryArray insertObject:currentCity atIndex:0];
    }
    
    if (cityHistoryArray.count > 3){
        [cityHistoryArray removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:HPVCCurrentCityArray];
    [[NSUserDefaults standardUserDefaults] setObject:cityHistoryArray forKey:HPVCHistoryCityArray];
}

+ (NSString *)getLotteryCurrentCity{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:HPVCCurrentCityArray];
    if (!city) city = @"";
    return city;
}

+ (NSArray *)getLotteryCityHistoryArray{
    NSArray *cityHistoryArray = [[NSUserDefaults standardUserDefaults] objectForKey:HPVCHistoryCityArray];
    if (!cityHistoryArray) cityHistoryArray = @[];
    return cityHistoryArray;
}
@end
