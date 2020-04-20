//
//  BallTrendModel.m
//  Lottery
//
//  Created by wangjingming on 2020/4/1.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BallTrendModel.h"

@interface BallTrendModel()
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *type;
@end

@implementation BallTrendModel
- (instancetype)initWithIdentifier:(NSString *)identifier type:(NSString *)type
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.type = type;
    }
    return self;
}

@end
