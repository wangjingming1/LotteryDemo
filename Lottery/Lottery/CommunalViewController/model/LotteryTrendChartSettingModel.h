//
//  LotteryTrendChartSettingModel.h
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LotterySettingModel;

@interface LotteryTrendChartSettingModel : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong, readonly) NSArray *titleArray;
@property (nonatomic, strong, readonly) NSArray <LotterySettingModel *> *parameterArray;
- (instancetype)initWithIdentifier:(NSString *)identifier;

- (void)reloadSettingModel;//重新读取json,刷新自己
- (NSArray<LotterySettingModel *> *)getParameterArray:(NSString *)title;
@end

@interface LotterySettingModel :NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) BOOL multipleSelection;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *defaultSelection;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
NS_ASSUME_NONNULL_END
