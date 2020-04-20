//
//  HomePageDownloadManager.h
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageDownloadManager : NSObject

+ (void)homePageDownloadData:(void (^)(NSDictionary *datas))finsh;
@end

NS_ASSUME_NONNULL_END
