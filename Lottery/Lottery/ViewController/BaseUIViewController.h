//
//  BaseUIViewController.h
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseUIViewController : UIViewController
@property (nonatomic, strong) UIButton *navBarLeftButton;
@property (nonatomic, copy) NSString *navBarLeftButtonTitle;
@property (nonatomic, strong) NSAttributedString *navBarLeftButtonAttributedTitle;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSDictionary *params;
- (CGFloat)getStatusbarHeight;
- (CGFloat)getNavigationbarHeight;
- (CGFloat)getTabbarHeight;
- (CGFloat)getCurrentAlpha;


- (void)popViewController;
- (NSString *)navBarLeftButtonImage;

- (void)navBarBackButtonClick:(UIButton *)leftButton;
- (void)navBarLeftButtonClick:(UIButton *)leftButton;

- (void)addRefreshHearderView:(SEL)refreshingAction otherScrollView:(UIScrollView *)otherScrollView;
- (void)addRefreshFooterView:(SEL)refreshingAction otherScrollView:(UIScrollView *)otherScrollView;

- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
