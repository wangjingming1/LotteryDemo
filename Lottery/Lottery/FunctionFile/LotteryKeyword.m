//
//  LotteryKeyword.m
//  Lottery
//
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryKeyword.h"

@interface LotteryKeyword()
@property (nonatomic, strong) NSDictionary *dict;
@end
@implementation LotteryKeyword
- (instancetype)init
{
    self = [super init];
    if (self){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lotteryKeyword" ofType:@"json"];
        
        NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData *jsonData = [readHandle readDataToEndOfFile];
        
        NSError *err;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        self.dict = [jsonDict objectForKey:@"data"];
    }
    return self;
}

- (NSString *)identifierToName:(NSString *)identifier{
    return [[self.dict objectForKey:identifier] objectForKey:@"name"];
}

- (NSString *)identifierToIcon:(NSString *)identifier{
    return [[self.dict objectForKey:identifier] objectForKey:@"icon"];
}

- (NSString *)identifierToType:(NSString *)type identifier:(NSString *)identifier{
    if ([type isEqualToString:@"icon"]) {
        return [self identifierToIcon:identifier];
    } else if ([type isEqualToString:@"name"]){
        return [self identifierToName:identifier];
    }
    return @"";
}
@end
