//
//  LotteryBannerView.h
//  Lottery
//  轮播视图
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryBannerView;
@protocol LotteryBannerViewDelegate <NSObject>

/**
 协议方法实现方式
 optional 可选 (默认是必须实现的)
 */
@optional
/**
 用来传值的协议方法

 @param bannerView 本类
 @param currentImage 选中图片所在位置
 */
- (void)selectImage:(LotteryBannerView *)bannerView currentImage:(NSInteger)currentImage;
@end

@interface LotteryBannerView : UIView

@property (nonatomic, weak)id <LotteryBannerViewDelegate> delegate;
/**
 设置图片数组
 @param imageArray 外界传入的图片数组(UIImage or URLString or ImagePath or ImageName)
 */
- (void)setImageArray:(NSArray *)imageArray;

- (void)startTimer;
- (void)pauseTimer;
/**
 销毁定时器方法
 */
- (void)destroyTimer;

@end
