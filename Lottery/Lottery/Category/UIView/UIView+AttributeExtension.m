//
//  UIView+AttributeExtension.m
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIView+AttributeExtension.h"
#import <objc/runtime.h>

static NSString *RI_ASS_KEY = @"com.UIView.AttributeExtension.random-stringTag";

@implementation UIView (AttributeExtension)
- (void)setStringTag:(NSString *)stringTag{
    objc_setAssociatedObject(self, (__bridge const void *)RI_ASS_KEY, stringTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)stringTag{
    NSString * identifier = (NSString *)objc_getAssociatedObject(self, (__bridge const void *)RI_ASS_KEY);
    return identifier;
}

- (UIView *)viewWithStringTag:(NSString *)stringTag{
    for (UIView *view in self.subviews){
        if ([view.stringTag isEqualToString:stringTag]) return view;
        if (view.subviews.count > 0){
            UIView *v = [view viewWithStringTag:stringTag];
            if (v) return v;
        }
    }
    return nil;
}
@end
