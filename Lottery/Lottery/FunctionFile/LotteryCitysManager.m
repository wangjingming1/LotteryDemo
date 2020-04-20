//
//  LotteryCitysManager.m
//  Lottery
//
//  Created by wangjingming on 2020/3/23.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryCitysManager.h"

@interface LotteryCitysManager()
@property (nonatomic, strong) NSArray *citys;
@end

@implementation LotteryCitysManager
- (instancetype)init {
    self = [super init];
    if (self){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"json"];
        
        NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData *jsonData = [readHandle readDataToEndOfFile];
        
        NSError *err;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSMutableArray *provinces = [[jsonDict objectForKey:@"provinces"] mutableCopy];
        [provinces addObject:@{@"citys":@[], @"provinceName":@"全国"}];
        self.citys = provinces;
        [self removeSpecialAdministrativeRegion];
    }
    return self;
}

- (void)removeSpecialAdministrativeRegion{
    NSMutableArray *citys = [self.citys mutableCopy];
    NSArray *specialAdministrativeRegionArray = @[@"香港", @"澳门", @"台湾"];
    for (NSString *str in specialAdministrativeRegionArray){
        for (NSDictionary *dict in citys){
            NSString *provinceName = dict[@"provinceName"];
            if ([provinceName isEqualToString:str]){
                [citys removeObject:dict];
                break;
            }
        }
    }
    self.citys = citys;
}

- (NSArray *)getProvincesArray{
    NSMutableArray *provincesArray = [@[] mutableCopy];
    for (NSDictionary *dict in self.citys){
        NSString *provinces = [dict objectForKey:@"provinceName"];
        if (!provinces || provinces.length == 0) continue;
        [provincesArray addObject:provinces];
    }
    return [self citysSort:provincesArray];
}

- (NSArray *)getCitys:(NSString *)provinces{
    NSMutableArray *sourceArray = [@[] mutableCopy];
    for (NSDictionary *dict in self.citys){
        NSString *provinceName = dict[@"provinceName"];
        if ([provinces isEqualToString:provinceName]){
            sourceArray = dict[@"citys"];
            break;
        }
    }
    NSMutableArray *citysArray = [@[] mutableCopy];
    for (NSDictionary *dict in sourceArray){
        [citysArray addObject:dict[@"citysName"]];
    }
    return [self citysSort:citysArray];
}

- (NSArray *)citysSort:(NSArray *)citys{
    NSArray *newCitys =
    [citys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *bopomofo1 = [self toBopomofo:obj1];
        NSString *bopomofo2 = [self toBopomofo:obj2];
        if ([obj1 isEqualToString:@"全国"]){
            return NSOrderedAscending;
        } else if ([obj2 isEqualToString:@"全国"]){
            return NSOrderedDescending;
        }
        return [bopomofo1 compare:bopomofo2];
    }];
    
    return newCitys;
}

- (NSString *)toBopomofo:(NSString *)sourceString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:sourceString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSMutableString *pinYin = [[str capitalizedString] mutableCopy];
    if ([[sourceString substringToIndex:1] compare:@"长"] == NSOrderedSame) {
        [pinYin replaceCharactersInRange:NSMakeRange(0, 5) withString:@"Chang"];
    } else if ([[sourceString substringToIndex:1] compare:@"沈"] == NSOrderedSame) {
        [pinYin replaceCharactersInRange:NSMakeRange(0, 4) withString:@"Shen"];
    } else if ([[sourceString substringToIndex:1] compare:@"厦"] == NSOrderedSame) {
        [pinYin replaceCharactersInRange:NSMakeRange(0, 3) withString:@"Xia"];
    } else if ([[sourceString substringToIndex:1] compare:@"地"] == NSOrderedSame) {
        [pinYin replaceCharactersInRange:NSMakeRange(0, 3) withString:@"Di"];
    } else if ([[sourceString substringToIndex:1] compare:@"重"] == NSOrderedSame) {
        [pinYin replaceCharactersInRange:NSMakeRange(0, 5) withString:@"Chong"];
    }
    //返回拼音
    return pinYin;
}

- (NSArray *)bopomofoSort:(NSArray *)citys{
    NSArray *newCitys =
    [citys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        for (int i = 0; i < [obj1 length] && i < [obj2 length]; i++){
            NSString *s1 = [obj1 substringToIndex:i];
            NSString *s2 = [obj2 substringToIndex:i];
            if (s1 > s2){
                return NSOrderedAscending;
            } else if (s1 < s2){
                return NSOrderedDescending;
            }
        }
        return NSOrderedDescending;
    }];
    
    return newCitys;
}

@end
