//
//  NewsDownloadManager.h
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDownloadManager : NSObject

+ (void)newsDownloadBegin:(NSInteger)begin count:(NSInteger)count finsh:(void (^)(NSArray *news))finsh;
@end

NS_ASSUME_NONNULL_END
