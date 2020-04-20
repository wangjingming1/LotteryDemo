//
//  HPVCHeaderView.h
//  Lottery
//  头部轮播视图
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryBannerView, LotteryBannerModel;
NS_ASSUME_NONNULL_BEGIN

@protocol HPVCHeaderViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
@end

@interface HPVCHeaderView : UIImageView
@property (nonatomic, weak) id<HPVCHeaderViewDelegate> delegate;
@property (nonatomic, weak) LotteryBannerView *bannerView;
- (void)reloadBannerView:(NSArray<LotteryBannerModel *> *)datas;
@end

NS_ASSUME_NONNULL_END
