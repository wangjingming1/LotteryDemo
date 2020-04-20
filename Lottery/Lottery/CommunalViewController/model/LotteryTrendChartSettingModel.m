//
//  LotteryTrendChartSettingModel.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryTrendChartSettingModel.h"

@interface LotteryTrendChartSettingModel()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray <LotterySettingModel *> *settingDefaultModelArray;
@property (nonatomic, strong) NSDictionary *lotteryTrendChartSettingDict;
@property (nonatomic, strong) NSArray <LotterySettingModel *> *parameterArray;
@end

@implementation LotteryTrendChartSettingModel
- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        [self reloadSettingModel];
        self.identifier = identifier;
    }
    return self;
}

- (void)setIdentifier:(NSString *)identifier{
    _identifier = identifier;
    NSDictionary *dict = [self.lotteryTrendChartSettingDict objectForKey:identifier];
    NSString *titles = [dict objectForKey:@"title"];
    self.titleArray = [titles componentsSeparatedByString:@","];
}

- (NSArray<LotterySettingModel *> *)getParameterArray:(NSString *)title{
    NSDictionary *dict = [self.lotteryTrendChartSettingDict objectForKey:self.identifier];
    
    NSMutableArray <LotterySettingModel *> *array = [@[] mutableCopy];
    NSDictionary *parameterDataDict = [dict objectForKey:@"parameter"];
    NSArray *allKeys = [parameterDataDict allKeys];
    NSArray *parameterDataArray = @[];
    for (NSString *key in allKeys){
        if ([key containsString:title]){
            parameterDataArray = parameterDataDict[key];
            break;
        }
    }
    for (NSDictionary *d in parameterDataArray){
        NSString *settingDefaultTitle = [d objectForKey:@"setting"];
        LotterySettingModel *defaultModel = [self getDefaultSettingModel:settingDefaultTitle];
        [array addObject:defaultModel];
    }
    self.parameterArray = array;
    return array;
}

- (void)reloadSettingModel{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lotteryTrendChartSetting" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *dict = [jsonDict objectForKey:@"data"];
    self.lotteryTrendChartSettingDict = dict;
    
//    NSDictionary *defaultModelDict = [dict objectForKey:@"setting"];
//    [self reloadSettingDefaultModelArray:defaultModelDict];
}

//- (void)reloadSettingDefaultModelArray:(NSDictionary *)dict{
//    NSMutableArray <LotterySettingModel *> *settingDefaultModelArray = [@[] mutableCopy];
//    NSArray *keys = [dict allKeys];
//    for (NSString *key in keys){
//        NSDictionary *settingDict = dict[key];
//        LotterySettingModel *model = [[LotterySettingModel alloc] initWithDict:settingDict];
//        [settingDefaultModelArray addObject:model];
//    }
//    self.settingDefaultModelArray = settingDefaultModelArray;
//}

- (LotterySettingModel *)getDefaultSettingModel:(NSString *)setting{
    NSDictionary *defaultModelDict = [self.lotteryTrendChartSettingDict objectForKey:@"setting"];
    NSDictionary *settingDict = defaultModelDict[setting];
    LotterySettingModel *model = [[LotterySettingModel alloc] initWithDict:settingDict];
    return model;
}

//- (LotterySettingModel *)getSettingDefaultModelByTitle:(NSString *)title{
//    for (LotterySettingModel *model in self.settingDefaultModelArray){
//        if ([model.title isEqualToString:title]){
//            return model;
//        }
//    }
//    return [[LotterySettingModel alloc] init];
//}
@end

#pragma mark - LotterySettingModel
@implementation LotterySettingModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        self.title = [dict objectForKey:@"title"];
        self.multipleSelection = [[dict objectForKey:@"multipleSelection"] boolValue];
        self.content = [dict objectForKey:@"content"];
        self.defaultSelection = [dict objectForKey:@"default"];
    }
    return self;
}
@end
