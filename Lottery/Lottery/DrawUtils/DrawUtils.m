//
//  DrawUtils.m
//  Lottery
//
//  Created by wangjingming on 2020/3/31.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "DrawUtils.h"
void drawCircle(CGContextRef ctx, CGPoint center, int radius, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) {
    CGContextSaveGState(ctx);
    
    CGContextSetFillColorWithColor(ctx, fillColor);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    //fill circle
    CGContextAddArc(ctx, center.x, center.y, radius, 0, M_PI*2, 0);
    
    //stroke
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

void drawPolygon(CGContextRef ctx, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) {
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, fillColor);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    
    CGContextAddPath(ctx, path);
    
    //stroke
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

void drawAuxiliaryLine(CGContextRef ctx, CGPoint p1, CGPoint p2, CGFloat lineWidth, CGColorRef lineColor, BOOL dash, CGFloat dashSize, BOOL setLineCap) {
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, lineWidth);
    if (setLineCap) {
        CGContextSetLineCap(ctx, kCGLineCapSquare);
    }
    
    CGContextSetStrokeColorWithColor(ctx, lineColor);
    if (dash) {
        CGFloat lengths[] = { dashSize, dashSize };
        CGContextSetLineDash(ctx, 0, lengths, 2);
    }
    
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}
#pragma mark - text
void drawTextAtPoint(CGContextRef context, double x, double y, DrawTextStyle drawTextStyle, NSString *text, double radian, CGFloat fontSize, UIColor *color) {
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, x, y);
    CGContextRotateCTM(context, radian);
    UIGraphicsPushContext(context);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontSize];
    attributes[NSForegroundColorAttributeName] = color;
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, fontSize)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}
                                     context:nil].size;
    CGPoint point = CGPointMake(0, 0);
    if (drawTextStyle & DrawTextStyle_X_Center){
        point.x = -size.width/2;
    } else if (drawTextStyle & DrawTextStyle_X_Right){
        point.x = -size.width;
    }
    if (drawTextStyle & DrawTextStyle_Y_Center){
        point.y = -size.height/2;
    } else if (drawTextStyle & DrawTextStyle_Y_Bottom){
        point.y = -size.height;
    }
    [text drawAtPoint:point withAttributes:attributes];
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}
#pragma mark - color
void drawGradationColor(CGContextRef context, CGPathRef path, NSArray <UIColor *> * colors, CGPoint startPoint, CGPoint endPoint){
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSMutableArray *cfColorArray = [@[] mutableCopy];
    for (int i = 0; i < colors.count; i++){
        [cfColorArray addObject:(__bridge id)colors[i].CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) cfColorArray, locations);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
