//
//  BonusTrendChartView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/26.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BonusTrendChartView.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "UIView+Color.h"
#import "UIView+AttributeExtension.h"
#import "BonusTrendChartLayer.h"

@interface BonusTrendChartView()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *drawTrendChartView;
@property (nonatomic, strong) NSArray *bonusTypeArray;
@property (nonatomic, strong) NSMutableArray *jackpotModelArray;
@property (nonatomic, strong) NSMutableArray *firstprizeModelArray;
@end

@implementation BonusTrendChartView
{
    NSString *_bonusType;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setUI];
    }
    return self;
}

- (void)initData{
    _bonusType = kLocalizedString(@"一等奖");
    self.bonusTypeArray = @[kLocalizedString(@"一等奖"), kLocalizedString(@"奖池")];
    self.jackpotModelArray = [@[] mutableCopy];
    self.firstprizeModelArray = [@[] mutableCopy];
}

- (void)setUI{
    self.backgroundColor = UIColor.commonBackgroundColor;
    [self addSubview:self.headerView];
    [self addSubview:self.drawTrendChartView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(kPadding20);
    }];
    
    [self.drawTrendChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding20);
        make.right.mas_equalTo(-kPadding20);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(kPadding20);
        make.bottom.mas_equalTo(0);
    }];
    
    [self setNeedsLayout];//设置重新布局标记
    [self layoutIfNeeded];//在当前runloop中立即重新布局
    [self reloadHeaderButtonsLayer];
}

- (void)setModelArray:(NSArray<BonusTrendChartModel *> *)modelArray{
    _modelArray = modelArray;
    [self.jackpotModelArray removeAllObjects];
    [self.firstprizeModelArray removeAllObjects];
    for (BonusTrendChartModel *model in modelArray){
        if ([model.title isEqualToString:@"奖池金额"]){
            [self.jackpotModelArray addObject:model];
        } else {
            [self.firstprizeModelArray addObject:model];
        }
    }
    [self reloadTrendChartView];
}

- (UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc] init];
        _headerView.layer.borderWidth = 1;
        _headerView.layer.borderColor = kUIColorFromRGB10(240, 240, 240).CGColor;
        _headerView.layer.masksToBounds = YES;
        for (NSString *type in self.bonusTypeArray){
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:type forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:kUIColorFromRGB10(215, 87, 63) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColor.commonLightGreyColor];
            [button addTarget:self action:@selector(segmentedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.stringTag = type;
            [_headerView addSubview:button];
            
            BOOL isSelected = [_bonusType isEqualToString:type];
            [button setSelected:isSelected];
        }
        [(UIButton *)(_headerView.subviews.firstObject) setSelected:YES];
        
        [_headerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [_headerView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(35);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return _headerView;
}

- (UIView *)drawTrendChartView{
    if (!_drawTrendChartView){
        _drawTrendChartView = [[UIView alloc] init];
    }
    return _drawTrendChartView;
}

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom{
    [self.drawTrendChartView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);
    }];
    [self setNeedsLayout];//设置重新布局标记
    [self layoutIfNeeded];//在当前runloop中立即重新布局
    [self reloadTrendChartView];
}

- (void)reloadTrendChartView{
    [self.drawTrendChartView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSArray *modelArray = self.firstprizeModelArray;
    if ([_bonusType isEqualToString:kLocalizedString(@"奖池")]){
        modelArray = self.jackpotModelArray;
    }
    if (modelArray.count == 0) return;
    [self.drawTrendChartView setNeedsLayout];//设置重新布局标记
    [self.drawTrendChartView layoutIfNeeded];//在当前runloop中立即重新布局
    CGFloat y = 0, padding = 20;
    for (int i = 0; i < modelArray.count; i++){
        BonusTrendChartModel *model = modelArray[i];
        BonusTrendChartLayer *layer = [[BonusTrendChartLayer alloc] init];
        CGFloat layerH = (CGRectGetHeight(self.drawTrendChartView.frame) - layer.footnoteHeight)/modelArray.count;
        if (i == modelArray.count - 1){
            layerH += layer.footnoteHeight;
        }
        layer.drawRect = CGRectMake(padding, 0, CGRectGetWidth(self.drawTrendChartView.frame), layerH);
        layer.frame = CGRectMake(-padding, y, CGRectGetWidth(self.drawTrendChartView.frame) + padding*2, layerH);//layer.drawRect;
        layer.model = model;
        layer.lineWidth = 1;
        layer.showFootnote = i == modelArray.count - 1;
        
        //这里不调用一句这个layer就不会进drawInContext方法...
        [layer setNeedsDisplay];
        [self.drawTrendChartView.layer addSublayer:layer];
        [layer startAnimated];
        y += CGRectGetHeight(layer.frame);
    }
}

- (void)segmentedButtonClick:(UIButton *)button {
    _bonusType = button.stringTag;
    for (UIView *view in self.headerView.subviews){
        if (![view isKindOfClass:[UIButton class]]) continue;
        [(UIButton *)view setSelected:view == button];
    }
    [self reloadHeaderButtonsLayer];
    [self reloadTrendChartView];
    NSLog(@"segmentedButtonClick");
}

- (void)reloadHeaderButtonsLayer{
    UIButton *btn1 = self.headerView.subviews.firstObject;
    UIButton *btn2 = self.headerView.subviews.lastObject;
    
    NSArray *btn1Color = btn1.selected ? @[kUIColorFromRGB10(215, 87, 63), kUIColorFromRGB10(230, 130, 105)] : @[];
    NSArray *btn2Color = btn2.selected ? @[kUIColorFromRGB10(230, 130, 105), kUIColorFromRGB10(215, 87, 63)] : @[];
    
    [btn1 setGradationColor:btn1Color startPoint:CGPointMake(0.0, 0.5) endPoint:CGPointMake(1.0, 0.5)];
    [btn2 setGradationColor:btn2Color startPoint:CGPointMake(0.0, 0.5) endPoint:CGPointMake(1.0, 0.5)];
    
    self.headerView.layer.cornerRadius = CGRectGetHeight(self.headerView.frame)/2;
}

- (void)layoutSubviews{
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.frame, CGRectZero) && self.modelArray.count && self.drawTrendChartView.layer.sublayers.count){
        [self reloadTrendChartView];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self.drawTrendChartView.layer.sublayers makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
