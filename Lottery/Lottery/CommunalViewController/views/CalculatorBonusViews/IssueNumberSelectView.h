//
//  IssueNumberSelectView.h
//  Lottery
//  算奖工具(期数选择器)
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel, MASViewAttribute;
@interface IssueNumberSelectView : UIView
//一页显示多少个 默认10个
@property (nonatomic) NSInteger count;
//当前选中
@property (nonatomic) NSInteger selectIdx;
@property (nonatomic, copy) void (^selectModel)(LotteryWinningModel *model);

@property (nonatomic, strong) NSArray <LotteryWinningModel *> *modelArray;

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom;
@end

NS_ASSUME_NONNULL_END
