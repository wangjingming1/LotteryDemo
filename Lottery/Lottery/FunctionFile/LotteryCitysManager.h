//
//  LotteryCitysManager.h
//  Lottery
//
//  Created by wangjingming on 2020/3/23.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryCitysManager : NSObject
- (NSArray *)getProvincesArray;
- (NSArray *)getCitys:(NSString *)provinces;
@end

NS_ASSUME_NONNULL_END
