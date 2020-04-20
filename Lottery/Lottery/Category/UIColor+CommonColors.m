//
//  UIColor+CommonColors.m
//  Lottery
//
//  Created by wangjingming on 2020/4/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIColor+CommonColors.h"
#import "GlobalDefines.h"

@implementation UIColor (CommonColors)
+ (UIColor *)commonNavigationControllerBarTintColor{
    if (@available(iOS 13.0, *)){
        if (@available(iOS 13.0, *)){
            return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
                if (style == UIUserInterfaceStyleDark){
                    return UIColor.commonBackgroundColor;
                } else {
                    return UIColor.redColor;
                }
            }];
        }
    }
    return UIColor.redColor;
}

+ (UIColor *)commonBackgroundColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(50, 50, 50);
            } else {
                return kUIColorFromRGB10(240, 240, 240);
            }
        }];
    }
    return kUIColorFromRGB10(240, 240, 240);
}

+ (UIColor *)commonGroupedBackgroundColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(80, 80, 80);
            } else {
                return kUIColorFromRGB10(245, 245, 245);
            }
        }];
    }
    return kUIColorFromRGB10(245, 245, 245);
}

+ (UIColor *)commonLightGreyColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(35, 35, 35);
            } else {
                return kUIColorFromRGB10(230, 230, 230);
            }
        }];
    }
    return kUIColorFromRGB10(230, 230, 230);
}

+ (UIColor *)commonSelectedTintTextColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(216, 30, 6);
            } else {
                return kUIColorFromRGB10(216, 30, 6);
            }
        }];
    }
    return kUIColorFromRGB10(216, 30, 6);
//    if (UIColor.CommonColors_UserInterfaceStyleDark){
//        return kUIColorFromRGB10(250, 250, 250);
//    } else {
//        return kUIColorFromRGB10(216, 30, 6);
//    }
}

+ (UIColor *)commonUnselectedTintTextColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(250, 250, 250);
            } else {
                return kUIColorFromRGB10(51, 51, 51);
            }
        }];
    }
    return kUIColorFromRGB10(51, 51, 51);
}

+ (UIColor *)commonTitleTintTextColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(250, 250, 250);
            } else {
                return kUIColorFromRGB10(62, 63, 64);
            }
        }];
    }
    return kUIColorFromRGB10(62, 63, 64);
}

+ (UIColor *)commonSubtitleTintTextColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return kUIColorFromRGB10(200, 200, 200);
            } else {
                return kUIColorFromRGB10(165, 166, 167);
            }
        }];
    }
    return kUIColorFromRGB10(165, 166, 167);
}

+ (UIColor *)commonSubTipsTintTextColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return UIColor.commonLightGreyColor;
            } else {
                return UIColor.commonLightGreyColor;
            }
        }];
    }
    return UIColor.commonLightGreyColor;
}

+ (UIColor *)commonShadowColor{
    if (@available(iOS 13.0, *)){
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            UIUserInterfaceStyle style = traitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark){
                return UIColor.commonLightGreyColor;
            } else {
                return UIColor.commonLightGreyColor;
            }
        }];
    }
    return UIColor.commonLightGreyColor;
}

@end
