//
//  LotteryBannerModel.h
//  Lottery
//  轮播视图数据
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LotteryBannerModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
