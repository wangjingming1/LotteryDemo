//
//  LotteryBannerModel.m
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryBannerModel.h"

@implementation LotteryBannerModel
- (instancetype)init{
    self = [super init];
    if (self){
       self.image = @"";
       self.url = @"";
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [self init];
    if (self){
        self.image = [dict objectForKey:@"image"];
        self.url = [dict objectForKey:@"url"];
    }
    return self;
}
@end
