//
//  LotteryConvenientServiceModel.m
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryConvenientServiceModel.h"

@implementation LotteryConvenientServiceModel
- (instancetype)init{
    self = [super init];
    if (self){
       self.title = @"";
       self.image = @"";
       self.className = @"";
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [self init];
    if (self){
        self.title = [dict objectForKey:@"title"];
        self.image = [dict objectForKey:@"image"];
        self.className = [dict objectForKey:@"className"];
    }
    return self;
}
@end
