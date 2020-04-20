//
//  UIView+Color.m
//  Lottery
//
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIView+Color.h"

@implementation UIView (Color)
- (void)setGradationColor:(NSArray <UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *layer = [CAGradientLayer layer];
    for (CAGradientLayer *l in self.layer.sublayers){
        if ([l isKindOfClass:[CAGradientLayer class]]){
            layer = l;
            break;
        }
    }
    if (colors.count == 0){
        [layer removeFromSuperlayer];
        return;
    }
    NSMutableArray *cgColors = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIColor *color in colors){
        [cgColors addObject:(id)color.CGColor];
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.colors = cgColors;
    
    layer.locations = nil;// @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)setShadowAndColor:(UIColor *)color {
    // 阴影颜色
    self.layer.shadowColor = color.CGColor;
    // 阴影偏移，默认(0, -3)
//    self.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 5;
    
}
@end
