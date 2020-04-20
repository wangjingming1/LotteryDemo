//
//  LotteryDownloadManager.h
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LotteryWinningModel;
NS_ASSUME_NONNULL_BEGIN

@interface LotteryDownloadManager : NSObject
+ (void)lotteryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSDictionary <NSString *, NSArray <LotteryWinningModel *> *> *lotteryDict))finsh;


#pragma mark - test
+ (NSArray <LotteryWinningModel *> *)lotteryWinningModelRandomizedByIdentifier:(NSString *)identifier begin:(NSInteger)begin count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
