//
//  WJMCheckBoxView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AttributeExtension.h"

NS_ASSUME_NONNULL_BEGIN
@class WJMTagLabel, WJMCheckBoxView;

@interface WJMCheckboxBtn : UIControl
//label与imageView的间隔 default:0
@property (nonatomic) CGFloat gap;
@property (nonatomic, strong) WJMTagLabel *titleLabel;
+ (instancetype)radioBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag;
+ (instancetype)tickBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag;

- (instancetype)initRadioBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag;
- (instancetype)initTickBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag;
@end


@protocol WJMCheckBoxViewDelegate <NSObject>
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didSelectItemAtStringTag:(NSString *)stringTag;
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didDeselectItemAtStringTag:(NSString *)stringTag;
@end

@interface WJMCheckBoxView : UIView
//default [btns count];
@property (nonatomic) NSUInteger maximumValue;
@property (nonatomic, weak) id<WJMCheckBoxViewDelegate>delegate;

- (instancetype)initCheckboxBtnBtns:(NSArray <WJMCheckboxBtn *>*)btns;

- (void)selectCheckBoxBtn:(NSString *)stringTag;
- (void)selectCheckBoxSingleBtn:(NSString *)stringTag;
@end

NS_ASSUME_NONNULL_END
