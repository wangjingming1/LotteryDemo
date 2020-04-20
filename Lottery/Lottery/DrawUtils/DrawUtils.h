//
//  DrawUtils.h
//  Lottery
//
//  Created by wangjingming on 2020/3/31.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    DrawTextStyle_X_Left        = 1<<0,
    DrawTextStyle_X_Center      = 1<<1,
    DrawTextStyle_X_Right       = 1<<2,
    
    DrawTextStyle_Y_Top         = 1<<3,
    DrawTextStyle_Y_Center      = 1<<4,
    DrawTextStyle_Y_Bottom      = 1<<5,
} DrawTextStyle;

void drawCircle(CGContextRef ctx, CGPoint center, int radius, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

void drawPolygon(CGContextRef ctx, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

void drawAuxiliaryLine(CGContextRef ctx, CGPoint p1, CGPoint p2, CGFloat lineWidth, CGColorRef lineColor, BOOL dash, CGFloat dashSize, BOOL setLineCap);

void drawTextAtPoint(CGContextRef context, double x, double y, DrawTextStyle drawTextStyle, NSString *text, double radian, CGFloat fontSize, UIColor *color);

void drawGradationColor(CGContextRef context, CGPathRef path, NSArray <UIColor *> * colors, CGPoint startPoint, CGPoint endPoint);

