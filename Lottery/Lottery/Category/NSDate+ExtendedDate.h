//
//  NSDate+ExtendedDate.h
//  Lottery
//  自定义的时间类扩展
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ExtendedDate)
/*! 获取指定date是星期几 */
+ (NSString *)weekdayStringWithDate:(NSDate *)date;

/*! 返回@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]*/
+ (NSArray <NSString *> *)getWeekdayArray;
@end

NS_ASSUME_NONNULL_END
