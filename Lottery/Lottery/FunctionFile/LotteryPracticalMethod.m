//
//  LotteryPracticalMethod.m
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPracticalMethod.h"

@implementation LotteryPracticalMethod

#pragma mark 数字 -
//将number转换成以百为单位
+ (double)hundred:(long long)number {
    return number/100.0;
}

//将number转换成以千为单位
+ (double)thousand:(long long)number {
    return [LotteryPracticalMethod hundred:number] / 10.0;
}

//将number转换成以万为单位
+ (double)tenThousand:(long long)number {
    return [LotteryPracticalMethod hundred:[LotteryPracticalMethod hundred:number]];
}

//将number转换成以亿为单位
+ (double)hundredMillion:(long long)number {
    return [LotteryPracticalMethod tenThousand:[LotteryPracticalMethod tenThousand:number]];
}

//将number转成最大单位(即1万-9999万，1亿到9999亿)，保留dp位小数
+ (NSString *)getMaxUnitText:(long long)number withPrecisionNum:(NSInteger)precision {
    if (number < 10000){
        return [NSString stringWithFormat:@"%lld", number];
    }
    NSString *unit = @"";
    double other = number;
    if (number < 100000000){
        unit = @"万";
        precision = 0;
        other = [LotteryPracticalMethod tenThousand:number];
    } else {
        unit = @"亿";
        other = [LotteryPracticalMethod hundredMillion:number];
    }
    //生成format格式
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",(long)precision];
    NSString *otherValue = [NSString stringWithFormat:format, other];
    return [NSString stringWithFormat:@"%@%@", otherValue, unit];
}

#pragma mark 随机数 -
+ (NSString *)arc4random:(int)number {
    NSString *str = @"";
    for (int i = 0; i < number; i++){
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random_uniform(10)]];
    }
    return str;
}
@end
