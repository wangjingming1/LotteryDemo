//
//  LSVCLotteryWinningView.h
//  Lottery
//  中奖视图
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel;

typedef NS_ENUM(NSInteger, LSVCLotteryWinningViewStyle) {
    LSVCLotteryWinningViewStyle_HomePage,
    LSVCLotteryWinningViewStyle_LotteryPastPeriod,
    LSVCLotteryWinningViewStyle_LotteryService,
};

@protocol LSVCLotteryWinningViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
@end


@interface LSVCLotteryWinningView : UIView
/**图标*/
@property (nonatomic, strong) UIImageView *iconView;
/**彩种名*/
@property (nonatomic, strong) UILabel *kindNameLabel;
/**期数*/
@property (nonatomic, strong) UILabel *issueNumberLabel;
/**时间*/
@property (nonatomic, strong) UILabel *dateLabel;
/**奖池*/
@property (nonatomic, strong) UILabel *jackpotLabel;
/**红球*/
@property (nonatomic, strong) UIView *redBallView;
/**篮球*/
@property (nonatomic, strong) UIView *blueBallView;
/**右侧箭头*/
@property (nonatomic, strong) UIImageView *rightArrowView;
/**试机号*/
@property (nonatomic, strong) UILabel *testNumberLabel;

/**红蓝球底部的线*/
@property (nonatomic, strong) UIView *ballBackLineView;

/**界面底部的线*/
@property (nonatomic, strong) UIView *backLineView;
/**数据model*/
@property (nonatomic, strong) LotteryWinningModel *model;
@property (nonatomic, weak) id<LSVCLotteryWinningViewDelegate> delegate;

@property (nonatomic) LSVCLotteryWinningViewStyle style;
- (instancetype)initWithStyle:(LSVCLotteryWinningViewStyle)style;
@end

NS_ASSUME_NONNULL_END
