//
//  UILabel+Padding.m
//  Lottery
//
//  Created by wangjingming on 2020/3/20.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UILabel+Padding.h"
#import <objc/runtime.h>
#import "GlobalDefines.h"

static NSString *RI_ASS_KEY = @"com.UILabel.AttributeExtension.random-Padding";

@implementation UILabel (Padding)
- (void)setPadding:(UIEdgeInsets)padding{
    NSValue *value = [NSValue value:&padding withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, (__bridge const void *)RI_ASS_KEY, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)padding{
    NSValue *value = objc_getAssociatedObject(self, (__bridge const void *)RI_ASS_KEY);
    UIEdgeInsets padding = UIEdgeInsetsZero;
    if (value){
        [value getValue:&padding];
    }
    return padding;
}

+ (void)load{
    kImportantReminder(@"通过runtime进行方法替换")
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"intrinsicContentSize"));
    Method method2 = class_getInstanceMethod([self class], @selector(intrinsicContentSizeSwizzle));
    method_exchangeImplementations(method1, method2);
}

- (CGSize)intrinsicContentSizeSwizzle{
    CGSize size = [self intrinsicContentSizeSwizzle];
    size.width += self.padding.left + self.padding.right;
    size.height += self.padding.top + self.padding.bottom;
    return size;
}
@end
