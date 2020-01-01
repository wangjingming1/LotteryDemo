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
- (CGFloat)getStatusbarHeight;
- (CGFloat)getNavigationbarHeight;
- (CGFloat)getTabbarHeight;
@end

NS_ASSUME_NONNULL_END
