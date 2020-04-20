//
//  TrendChartLayer.m
//  Lottery
//
//  Created by wangjingming on 2020/3/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BonusTrendChartLayer.h"
#import "DrawUtils.h"

#import "GlobalDefines.h"
#import "BonusTrendChartModel.h"
#import "LotteryPracticalMethod.h"

@interface BonusTrendChartLayer()
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval animatedDurationTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) BOOL isDrawMask;
@end

@implementation BonusTrendChartLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showFootnote = YES;
        self.lineWidth = 1;
        self.footnoteHeight = 20;
        self.isDrawMask = NO;
        [self setContentsScale:[[UIScreen mainScreen] scale]];
    }
    return self;
}

- (void)startAnimated {
    [self invalidateDisplayLink];
    
    self.animatedDurationTime = 0.5;
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    self.isDrawMask = YES;
    
    [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(maskAnimated:)];
    [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}

- (void)invalidateDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.animatedDurationTime = 0;
    self.isDrawMask = NO;
    [self setNeedsDisplay];
}

- (void)maskAnimated:(CADisplayLink *)displayLink{
    NSTimeInterval curTime = [NSDate timeIntervalSinceReferenceDate];
    double timeOffset = curTime - self.startTime;
    
    if (timeOffset > self.animatedDurationTime){
        [self invalidateDisplayLink];
    } else {
        [self setNeedsDisplay];
    }
}

- (void)calculateXArray:(CGFloat *)xArray yArray:(CGFloat *)yArray dataArray:(long long *)dataArray width:(CGFloat)width height:(CGFloat)height{
    long long minData = 1e14, maxData = -1e14;//±1亿亿,暂时精度够用
    NSInteger dateCount = self.model.trendChartDataModelArray.count;
    CGFloat singleWidth = width/dateCount;
    for (int i = 0; i < dateCount; i++) {
        long long data = [self.model.trendChartDataModelArray[i].data longLongValue];
        dataArray[i] = data;
        if (data < minData) minData = data;
        if (data > maxData) maxData = data;
    }
    
    CGFloat minY = CGRectGetMinY(self.drawRect) + 1/4.0*height;
    CGFloat contextY = height - minY*2;
    for (int i = 0; i < dateCount; i++) {
        long long data = *(dataArray + i);
        CGFloat y = 0;
        if (maxData != minData){
            y = minY + (maxData - data)*1.0/(maxData - minData)*contextY;//尴尬了,没有浮点数,这里乘上个1.0转一下
        }
        yArray[i] = y;
        
        CGFloat x = CGRectGetMinX(self.drawRect) + singleWidth/2 + singleWidth*i;
        xArray[i] = x;
    }
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.model) return;
    if (!self.model.trendChartDataModelArray.count) return;
    NSInteger dateCount = self.model.trendChartDataModelArray.count;
    CGFloat footnoteHeight = self.footnoteHeight;
    CGFloat width = CGRectGetWidth(self.drawRect);
    CGFloat height = self.showFootnote ? CGRectGetHeight(self.drawRect) - footnoteHeight : CGRectGetHeight(self.drawRect);
    
    CGFloat xArray[dateCount];
    CGFloat yArray[dateCount];
    long long dataArray[dateCount];
    
    [self calculateXArray:xArray yArray:yArray dataArray:dataArray width:width height:height];
    CGFloat minX = CGRectGetMinX(self.drawRect), minY = CGRectGetMinY(self.drawRect);
    drawAuxiliaryLine(ctx, CGPointMake(minX, minY), CGPointMake(minX + width, minY), self.lineWidth, self.model.footNoteColor.CGColor, NO, 0, NO);
    for (int i = 0; i < dateCount; i++){
        CGFloat x = xArray[i];
        drawAuxiliaryLine(ctx, CGPointMake(x, minY), CGPointMake(x, height), self.lineWidth, self.model.footNoteColor.CGColor, YES, 5, YES);
        if (self.showFootnote){
            BonusTrendChartDataModel *dataModel = self.model.trendChartDataModelArray[i];
            drawTextAtPoint(ctx, x, height + 5, DrawTextStyle_X_Left | DrawTextStyle_Y_Top, dataModel.footnote, 0, 12, self.model.footNoteColor);
        }
    }
    
    if (self.showFootnote && self.model.footnote){
        drawAuxiliaryLine(ctx, CGPointMake(minX, height), CGPointMake(minX + width, height), self.lineWidth, self.model.lineColor.CGColor, NO, 0, NO);
        drawTextAtPoint(ctx, minX, height + 5, DrawTextStyle_X_Left | DrawTextStyle_Y_Top, self.model.footnote, 0, 12, self.model.footNoteColor);
    }
    
    CGFloat radius = kPadding10/2;
    NSString *unit = self.model.trendChartDataModelArray.firstObject.unit;
    drawCircle(ctx, CGPointMake(minX + radius, minY + radius + kPadding10), radius, self.model.nodeColor.CGColor, self.model.nodeColor.CGColor, 0);
    drawTextAtPoint(ctx, minX + radius*2 + kPadding10, minY + radius + kPadding10, DrawTextStyle_X_Left | DrawTextStyle_Y_Center, self.model.title, 0, 12, self.model.titleColor);
    
    [self drawBonusTrendChartData:ctx xArray:xArray yArray:yArray bonusDataArray:dataArray unit:unit arrayCount:dateCount drawH:height radius:radius];
    if (self.isDrawMask) {
        [self drawMask:ctx polygon:self.bounds];// width:width height:height];
    }
}

- (void)drawBonusTrendChartData:(CGContextRef)ctx xArray:(const CGFloat *)xArray yArray:(const CGFloat *)yArray bonusDataArray:(const long long *)dataArray unit:(NSString *)unit arrayCount:(NSInteger)arrayCount drawH:(CGFloat)drawH radius:(CGFloat)radius{
    [self drawGradationColor:ctx xArray:xArray yArray:yArray arrayCount:arrayCount drawH:drawH];
    for (NSInteger i = 0; i < arrayCount; i++){
        long long currentData = *(dataArray + i);
        CGFloat currentX = *(xArray + i);
        CGFloat currentY = yArray[i];
        if (i + 1 < arrayCount){
            CGFloat nextX = *(xArray + i + 1);
            CGFloat nextY = yArray[i + 1];
            drawAuxiliaryLine(ctx, CGPointMake(currentX, currentY), CGPointMake(nextX, nextY), self.lineWidth, self.model.lineColor.CGColor, NO, 0, NO);
        }
        drawCircle(ctx, CGPointMake(currentX, currentY), radius, self.model.nodeColor.CGColor, self.model.nodeColor.CGColor, 0);
        NSString *title = [NSString stringWithFormat:@"%@%@", [LotteryPracticalMethod getMaxUnitText:currentData withPrecisionNum:2], unit];
        drawTextAtPoint(ctx, currentX, currentY - radius, DrawTextStyle_X_Center | DrawTextStyle_Y_Bottom, title, 0, 12, self.model.titleColor);
    }
}

- (void)drawGradationColor:(CGContextRef)ctx xArray:(const CGFloat *)xArray yArray:(const CGFloat *)yArray arrayCount:(NSInteger)arratCount drawH:(CGFloat)drawH{
    if (arratCount == 0) return;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, xArray[0], yArray[0]);
    for (int i = 1; i < arratCount; i++){
        CGPathAddLineToPoint(path, NULL, xArray[i], yArray[i]);
    }
    CGPathAddLineToPoint(path, NULL, xArray[arratCount - 1], drawH);
    CGPathAddLineToPoint(path, NULL, xArray[0], drawH);
    CGPathCloseSubpath(path);
    
    UIColor *startColor = [self.model.nodeColor colorWithAlphaComponent:0.5];
    UIColor *endColor = [UIColor.commonBackgroundColor colorWithAlphaComponent:0.5];
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    //绘制渐变色
    drawGradationColor(ctx, path, @[startColor, endColor], startPoint, endPoint);
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
}

- (void)drawMask:(CGContextRef)ctx polygon:(CGRect)polygon{
    NSTimeInterval curTime = [NSDate timeIntervalSinceReferenceDate];
    double timeOffset = curTime - self.startTime;
    if (timeOffset > self.animatedDurationTime){
        timeOffset = self.animatedDurationTime;
    }
    double percentage = timeOffset / self.animatedDurationTime;
    
    NSInteger dateCount = self.model.trendChartDataModelArray.count;
    
    CGFloat singleWidth = CGRectGetWidth(polygon)/dateCount;
    
    CGFloat minX = CGRectGetMinX(polygon) + singleWidth/2 + (CGRectGetWidth(polygon) - singleWidth)*percentage, maxX = CGRectGetMaxX(polygon);
    CGFloat minY = CGRectGetMinY(polygon) + 40, maxY = CGRectGetMaxY(polygon);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, minY);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    CGPathAddLineToPoint(path, NULL, maxX, maxY);
    CGPathAddLineToPoint(path, NULL, minX, maxY);
    
    drawPolygon(ctx, path, UIColor.commonBackgroundColor.CGColor, [UIColor clearColor].CGColor, 0);
}
@end
