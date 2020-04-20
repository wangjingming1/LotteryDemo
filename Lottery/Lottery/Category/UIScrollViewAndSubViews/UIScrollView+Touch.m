//
//  UIScrollView+Touch.m
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIScrollView+Touch.h"
#import "GlobalDefines.h"
#import <objc/runtime.h>

@implementation UIScrollView (Touch)
+ (void)load
{
    kImportantReminder(@"通过runtime进行方法替换")
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"touchesShouldCancelInContentView:"));
    Method method2 = class_getInstanceMethod([self class], @selector(touchesShouldCancelInContentViewSwizzle:));
    method_exchangeImplementations(method1, method2);
}
kImportantReminder(@"canCancelContentTouches如果为NO,则整个touch事件响应链(touchesBegan,touchesMoved,touchesEnded等)全交由子view处理,会有scrollView无法滚动现象")
kImportantReminder(@"当UIScrollView将touch事件交给子view后，若手指发生滑动时，调用此方法。如果返回NO，则子view处理touch事件, 返回YES，则UIScrollView处理，产生滑动。（需要canCancelContentTouches属性是YES，只要不是UIControll的子类，这个属性默认是YES。）既能立即响应UIButton，也能自由滑动UIScrollView。")
- (BOOL)touchesShouldCancelInContentViewSwizzle:(UIView *)view{
    kImportantReminder(@"由于原方法通过runtime替换了,所以这里想要调用原方法只能通过新起的名字来调用,并不会产生循环调用的问题");
    [self touchesShouldCancelInContentViewSwizzle:view];
    return YES;
}
@end
