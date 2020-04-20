//
//  UIView+AttributeExtension.h
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AttributeExtension)
@property (nonatomic, copy)NSString *stringTag;

- (UIView *)viewWithStringTag:(NSString *)stringTag;
@end

NS_ASSUME_NONNULL_END
