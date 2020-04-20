//
//  LotteryNewsModel.h
//  Lottery
//  新闻数据
//  Created by wangjingming on 2020/1/9.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryNewsModel : NSObject
/**新闻来源*/
@property (nonatomic, copy) NSString *informationSources;
/**发布时间*/
@property (nonatomic, copy) NSString *time;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**图片链接*/
@property (nonatomic, copy) NSString *imageUrl;
/**新闻链接*/
@property (nonatomic, copy) NSString *newsUrl;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
