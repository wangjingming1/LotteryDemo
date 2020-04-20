//
//  HPVCConvenientServiceView.h
//  Lottery
//  便捷服务视图
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryConvenientServiceModel;
NS_ASSUME_NONNULL_BEGIN

@protocol HPVCConvenientServiceViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
- (void)reloadViewFinish:(UIView *)initiator;
@end

@interface HPVCConvenientServiceView : UIView
@property (nonatomic, weak) id <HPVCConvenientServiceViewDelegate> delegate;

- (void)reloadConvenientServiceView:(NSArray<LotteryConvenientServiceModel *> *)datas;
@end

NS_ASSUME_NONNULL_END
