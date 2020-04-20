//
//  BallTrendModel.h
//  Lottery
//
//  Created by wangjingming on 2020/4/1.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryTrendChartSettingModel;

@interface BallTrendData : NSObject
@property (nonatomic, copy) NSString *issueNumber;

@end


@interface BallTrendModel : NSObject
@property (nonatomic, strong) LotteryTrendChartSettingModel * settingModel;

- (instancetype)initWithIdentifier:(NSString *)identifier type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
