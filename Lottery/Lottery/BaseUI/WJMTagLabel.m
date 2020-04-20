//
//  WJMTagLabel.m
//  Lottery
//
//  Created by wangjingming on 2020/3/10.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTagLabel.h"
#import "GlobalDefines.h"

@interface WJMTagLabel()
@property (nonatomic, strong) UIBezierPath *tagPath;
@property (nonatomic, strong) NSMutableArray *layerArray;
@end

@implementation WJMTagLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = WJMTagLabelStyle_BubblesStyle;
        self.triangleSide = 4;
        self.layerArray = [@[] mutableCopy];
    }
    return self;
}
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (self.style == WJMTagLabelStyle_RadioStyle || self.style == WJMTagLabelStyle_TickStyle){
        [self reloadTagLayer];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadTagLayer];
}

- (void)reloadTagLayer{
    [self.layerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layerArray removeAllObjects];
    CGRect frame = self.bounds;
    if (self.style == WJMTagLabelStyle_RadioStyle){
        [self reloadRadioStyleBezierPath:frame];
    } else if (self.style == WJMTagLabelStyle_TickStyle){
        [self reloadTickStyleBezierPath:frame];
    } else {
        [self reloadBubblesStyleBezierPath:frame];
    }
}

- (void)reloadBubblesStyleBezierPath:(CGRect)frame{
    /*
        1.5PI
    01PI     0PI
        0.5PI
     */
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame) - self.triangleSide;
    CGFloat cornerRadius = h/5;
    
    UIBezierPath *tagPath = [UIBezierPath new];
    [tagPath moveToPoint:CGPointMake(cornerRadius, 0)];
    [tagPath addLineToPoint:CGPointMake(w - cornerRadius, 0)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, cornerRadius) radius:cornerRadius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(w, h - cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0 endAngle:0.5*M_PI clockwise:YES];
    
    [tagPath addLineToPoint:CGPointMake(w/2 + self.triangleSide, h)];
    [tagPath addLineToPoint:CGPointMake(w/2, h+self.triangleSide)];
    [tagPath addLineToPoint:CGPointMake(w/2 - self.triangleSide, h)];
    
    [tagPath addLineToPoint:CGPointMake(cornerRadius, h)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0.5*M_PI endAngle:M_PI clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(0, cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
    
    [tagPath stroke];
    [tagPath fill];
    [tagPath closePath];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = frame;
    layer.path = tagPath.CGPath;
    layer.fillColor = [UIColor redColor].CGColor;// [UIColor redColor].CGColor;
    self.layer.mask = layer;
}

- (void)reloadRadioStyleBezierPath:(CGRect)frame{
    CGRect rect = [self textRectForBounds:frame limitedToNumberOfLines:self.numberOfLines];
    if (self.textAlignment == NSTextAlignmentCenter){
        rect.origin.x -= self.triangleSide*2;// + kPadding10;
        rect.size.width -= self.triangleSide*2;// + kPadding10);
    } else if (self.textAlignment == NSTextAlignmentRight){
        rect.origin.x -= self.triangleSide*2 + kPadding10;
        rect.size.width -= (self.triangleSide*2 + kPadding10);
    }
    if (rect.origin.x < 1){
        rect.origin.x = 1;
    }
    CGFloat x = CGRectGetMinX(rect);
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame);
    
    CGFloat outerRingRadius = self.triangleSide;
    CGFloat innerRingRadius = outerRingRadius/2;
    
    UIBezierPath *outerRingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x + outerRingRadius, h/2) radius:outerRingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CAShapeLayer *outerLayer = [CAShapeLayer layer];
    outerLayer.frame = self.bounds;
    outerLayer.path = outerRingPath.CGPath;
    outerLayer.strokeColor = kUIColorFromRGB10(237, 169, 158).CGColor;
    outerLayer.fillColor = kUIColorFromRGB10(251, 244, 241).CGColor;
    
    [self.layer addSublayer:outerLayer];
    [self.layerArray addObject:outerLayer];
    
    if (self.selected){
        UIBezierPath *innerRingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x + outerRingRadius/2 + innerRingRadius, h/2) radius:innerRingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer *innerRingLayer = [CAShapeLayer layer];
        innerRingLayer.frame = self.bounds;
        innerRingLayer.path = innerRingPath.CGPath;
        innerRingLayer.fillColor = kUIColorFromRGB10(213, 88, 69).CGColor;
        
        [self.layer addSublayer:innerRingLayer];
        [self.layerArray addObject:innerRingLayer];
    }
}

- (void)reloadTickStyleBezierPath:(CGRect)frame{
    if (self.selected){
        CGFloat w = CGRectGetWidth(frame);
        CGFloat h = CGRectGetHeight(frame);
        /*
         
             1.5PI
           PI     PI
             0.5PI
         
             1  2
                3
         */
        kImportantReminder(@"这里出现了傻逼问题semicirclePath只画出了一个残废的扇形(弧线M_PI_2到M_PI,只过了1、3点,没经过2点)")
        kImportantReminder(@"所以补了一个appendPath(一个经过1、2、3点的三角形)作补充,具体问题以后有时间再调整吧")
        
        UIBezierPath *semicirclePath = [UIBezierPath bezierPath];
        [semicirclePath addArcWithCenter:CGPointMake(w, 0) radius:self.triangleSide startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
        UIBezierPath *appendPath = [UIBezierPath bezierPath];
        [appendPath moveToPoint:CGPointMake(w - self.triangleSide, 0)];
        [appendPath addLineToPoint:CGPointMake(w, 0)];
        [appendPath addLineToPoint:CGPointMake(w, self.triangleSide)];
        
        [semicirclePath appendPath:appendPath];
        
        UIBezierPath *tickPath = [UIBezierPath new];
//        [tickPath moveToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/5 + 2, self.triangleSide/5*2 + 1)];
//        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/5*2 + 2, self.triangleSide/5*3)];
//        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/4*3, self.triangleSide/3)];
        
        [tickPath moveToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/3, self.triangleSide/2)];
        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/5*2 + 2, self.triangleSide/5*3)];
        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/4*3, self.triangleSide/3)];
        
        [tickPath stroke];
        
        
        CAShapeLayer *semicircleLayer = [CAShapeLayer layer];
        semicircleLayer.frame = self.bounds;
        semicircleLayer.fillColor = kUIColorFromRGB10(215, 88, 63).CGColor;
        semicircleLayer.path = semicirclePath.CGPath;
        
        CAShapeLayer *tickLayer = [CAShapeLayer layer];
        tickLayer.frame = self.bounds;
        tickLayer.fillColor = [UIColor clearColor].CGColor;
        tickLayer.strokeColor = [UIColor whiteColor].CGColor;
        tickLayer.path = tickPath.CGPath;
        
        [self.layer addSublayer:semicircleLayer];
        [self.layer addSublayer:tickLayer];
        
        [self.layerArray addObject:semicircleLayer];
        [self.layerArray addObject:tickLayer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect{
    if (self.style == WJMTagLabelStyle_RadioStyle){
        rect.origin.x = self.triangleSide*2 + kPadding10;
        rect.size.width -= (self.triangleSide*2 + kPadding10);
    } else if (self.style == WJMTagLabelStyle_TickStyle){
        
    } else {
        rect.size.height = rect.size.height - self.triangleSide;
    }
    [super drawTextInRect:rect];
}
@end
