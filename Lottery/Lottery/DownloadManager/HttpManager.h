//
//  HttpManager.h
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTEST
NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : NSObject

+ (void)http:(NSString *)url params:(NSDictionary *)params finsh:(void (^)(id responseObject))finsh;

@end

NS_ASSUME_NONNULL_END
