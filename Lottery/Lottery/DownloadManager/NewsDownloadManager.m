//
//  NewsDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "NewsDownloadManager.h"
#import "LotteryNewsModel.h"
#import "HttpManager.h"

@implementation NewsDownloadManager

+ (void)newsDownloadBegin:(NSInteger)begin count:(NSInteger)count finsh:(void (^)(NSArray *news))finsh {
    
#ifdef kTEST
    NSArray *array = [NewsDownloadManager geTestLotteryNewsModelArray:begin count:count];
    if (finsh){
        finsh(array);
    }
#else
#endif
}

#pragma mark - test
+ (NSArray *)geTestLotteryNewsModelArray:(NSInteger)begin count:(NSInteger)count{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
//    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSArray *datas = [dic objectForKey:@"data"];
    NSInteger i = begin;
    while (count > 0) {
        NSDictionary *dict = datas[i++%datas.count];
        LotteryNewsModel *model = [[LotteryNewsModel alloc] initWithDict:dict];
        [array addObject:model];
        count--;
    }
    return array;
}
@end
