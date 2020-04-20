//
//  ClassSingle.h
//  Lottery
//  便利的将类改造为单例类
//  Created by wangjingming on 2020/4/12.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#ifndef ClassSingle_h
#define ClassSingle_h

#define CLASSSINGLE_H(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define CLASSSINGLE_M(name) static id _singleManager = nil;\
+ (instancetype)share##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _singleManager = [[self alloc] init];\
    });\
    return _singleManager;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _singleManager = [super allocWithZone:zone];\
    });\
    return _singleManager;\
}\
\
- (id)mutableCopy{\
    return _singleManager;\
}\
\
- (id)copy{\
    return _singleManager;\
}

#else

#define CLASSSINGLE_M(name) static id _singleManager = nil;\
+ (instancetype)share##name{\
return [[self alloc]init];\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_singleManager = [super allocWithZone:zone];\
});\
return _singleManager;\
}\
\
- (id)mutableCopy{\
return _singleManager;\
}\
\
- (id)copy{\
return _singleManager;\
}\
- (oneway void)release{\
}\
\
- (instancetype)retain{\
    return _singleManager;\
}\
\
- (NSUInteger)retainCount{\
    return 9999;\
}\

#endif

#endif /* ClassSingle_h */
