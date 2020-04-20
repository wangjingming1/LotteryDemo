//
//  LotteryBottomToolsbar.h
//  Lottery
//  彩票界面底部的工具栏(走势图，算奖工具)
//  Created by wangjingming on 2020/2/28.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class LotteryBottomToolsbar;

typedef NS_ENUM(NSInteger, LotteryBottomTools) {
    LotteryBottomTools_trendchart,  //走势图
    LotteryBottomTools_calculator,  //算奖工具
};

@protocol LotteryBottomToolsbarDelegate <NSObject>
//选中的工具
- (void)lotteryBottomToolsbar:(LotteryBottomToolsbar *)toolsbar selectTools:(LotteryBottomTools)tools;

@end

@interface LotteryBottomToolsbar : UIView
//彩票类别
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, weak) id<LotteryBottomToolsbarDelegate> delegate;

- (void)setToolsbarTextFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
