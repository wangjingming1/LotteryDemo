//
//  NSDate+ExtendedDate.m
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "NSDate+ExtendedDate.h"

@implementation NSDate (ExtendedDate)
+ (NSArray <NSString *> *)getWeekdayArray{
    return @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
}
/*!
    由于西方一周的开始是从周日开始算的和我们不一样，我们一周的开始是周一，在初始化日期数组的时候一定要从周日开始
 */
+ (NSString *)weekdayStringWithDate:(NSDate *)date {
    //获取周几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];//1代表周日，2代表周一，后面依次
    NSArray *weekArray = [NSDate getWeekdayArray];
    NSString *weekStr = weekArray[weekday-1];
    return weekStr;
}
@end
