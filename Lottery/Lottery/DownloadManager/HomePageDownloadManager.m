//
//  HomePageDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageDownloadManager.h"
#import "HttpManager.h"
#import "GlobalDefines.h"

#import "LotteryDownloadManager.h"

#import "LotteryBannerModel.h"
#import "LotteryConvenientServiceModel.h"
#import "LotteryWinningModel.h"
#import "LotteryNewsModel.h"

@implementation HomePageDownloadManager

+ (void)homePageDownloadData:(void (^)(NSDictionary *datas))finsh {
    #ifdef kTEST
        NSDictionary *datas = [HomePageDownloadManager geTestHomePageDatas];
        if (finsh){
            finsh(datas);
        }
    #else
    
    #endif
}

#pragma mark - test
+ (NSDictionary *)geTestHomePageDatas{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"homePage" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *dict = [jsonDict objectForKey:@"data"];
    if (dict && dict.count > 0){
        NSArray *banners = [dict objectForKey:@"banners"];
        NSArray *convenientServices = [dict objectForKey:@"convenientServices"];
        NSArray *winnings = [dict objectForKey:@"winnings"];
        NSArray *news = [dict objectForKey:@"news"];
        
        NSMutableDictionary *datas = [@{} mutableCopy];
        HomePageDownloadManager *manager = [[HomePageDownloadManager alloc] init];
        datas[@"banners"] = [manager getBannerModels:banners];
        datas[@"convenientServices"] = [manager getLotteryConvenientServiceModels:convenientServices];
        datas[@"winnings"] = [manager getLotteryWinningModels:winnings];
        datas[@"news"] = [manager getLotteryNewsModels:news];
        return datas;
    }
    return @{};
}

- (NSArray <LotteryBannerModel *> *)getBannerModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LotteryBannerModel *model = [LotteryBannerModel yy_modelWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (NSArray <LotteryConvenientServiceModel *> *)getLotteryConvenientServiceModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LotteryConvenientServiceModel *model = [[LotteryConvenientServiceModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    return array;
}

- (NSArray <LotteryWinningModel *> *)getLotteryWinningModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        NSString *identifier = [dict objectForKey:@"identifier"];
        NSString *lotteryDataJson = [dict objectForKey:@"lotteryData"];
        LotteryWinningModel *model;
        if ([lotteryDataJson isEqualToString:@"test"]){
            NSArray *array = [LotteryDownloadManager lotteryWinningModelRandomizedByIdentifier:identifier begin:0 count:1];
            model = [array firstObject];
        } else {
            NSData *jsonData = [lotteryDataJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *lotteryDataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            
            model = [[LotteryWinningModel alloc] initWithDict:lotteryDataDict];
        }
    
        [array addObject:model];
    }
    return array;
}

- (NSArray <LotteryNewsModel *> *)getLotteryNewsModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LotteryNewsModel *model = [[LotteryNewsModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    return array;
}
@end
