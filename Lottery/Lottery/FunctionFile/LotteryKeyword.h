//
//  LotteryKeyword.h
//  Lottery
//
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryKeyword : NSObject
- (NSString *)identifierToName:(NSString *)identifier;
- (NSString *)identifierToIcon:(NSString *)identifier;

- (NSString *)identifierToType:(NSString *)type identifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
