//
//  MySelectBallView.h
//  Lottery
//  算奖工具(我的投注and我的命中)
//  Created by wangjingming on 2020/3/11.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel, MASViewAttribute;

typedef NS_ENUM(NSInteger, MySelectBallViewStyle) {
    SelectBallViewStyle,
    TargetBallViewStyle,
};

@interface MySelectBallView : UIView
@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^finishBlock)(NSString *redCount, NSString *blueCount);
@property (nonatomic, strong) LotteryWinningModel *model;
- (instancetype)initWithStyle:(MySelectBallViewStyle)style;
- (void)setOldRedCount:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount;
- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom;
@end

NS_ASSUME_NONNULL_END
