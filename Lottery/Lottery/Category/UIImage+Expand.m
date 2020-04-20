//
//  UIImage+Expand.m
//  Lottery
//
//  Created by wangjingming on 2020/3/9.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIImage+Expand.h"

@implementation UIImage (Expand)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
