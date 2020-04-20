//
//  LotteryBottomToolsbar.m
//  Lottery
//
//  Created by wangjingming on 2020/2/28.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryBottomToolsbar.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "LotteryKindName.h"

@interface LotteryBottomToolsbar()
@property (nonatomic, strong) UIButton *trendchartButton;
@property (nonatomic, strong) UIButton *calculatorButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LotteryBottomToolsbar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    [self addSubview:self.lineView];
    [self addSubview:self.trendchartButton];
    [self addSubview:self.calculatorButton];
    
    [self.trendchartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(-0);
    }];
    
    [self.calculatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.trendchartButton);
        make.left.mas_equalTo(self.trendchartButton.mas_right);
        make.right.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.trendchartButton.mas_right).offset(-1);
        make.centerY.mas_equalTo(self.trendchartButton);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(self).multipliedBy(1/2.0);
    }];
}

- (void)setIdentifier:(NSString *)identifier{
    _identifier = identifier;
    BOOL showCalculatorButton = NO;
    if (kLotteryIsShuangseqiu(identifier) || kLotteryIsDaletou(identifier)){
        showCalculatorButton = YES;
    }
    [self.trendchartButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (showCalculatorButton){
            make.width.mas_equalTo(self).multipliedBy(0.5);
        } else {
            make.width.mas_equalTo(self);
        }
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (showCalculatorButton){
            make.width.mas_equalTo(2);
        } else {
            make.width.mas_equalTo(0);
        }
    }];
}

- (void)setToolsbarTextFont:(UIFont *)font{
    self.trendchartButton.titleLabel.font = font;
    self.calculatorButton.titleLabel.font = font;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kDividingLineColor;
    }
    return _lineView;
}

- (UIButton *)trendchartButton{
    if (!_trendchartButton){
        _trendchartButton = [[UIButton alloc] init];
        [_trendchartButton setTitle:@"走势图" forState:UIControlStateNormal];
        [_trendchartButton setTitleColor:kUIColorFromRGB10(78,132,239) forState:UIControlStateNormal];
        [_trendchartButton setImage:[UIImage imageNamed:@"trendChart"] forState:UIControlStateNormal];
        [_trendchartButton setImage:[UIImage imageNamed:@"trendChart"] forState:UIControlStateHighlighted];
        [_trendchartButton setImageEdgeInsets:UIEdgeInsetsMake(kPadding10/2, 0, kPadding10/2, kPadding10/2)];
        [_trendchartButton setTitleEdgeInsets:UIEdgeInsetsMake(kPadding10/2, kPadding10/2, kPadding10/2, 0)];
        [_trendchartButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _trendchartButton.tag = LotteryBottomTools_trendchart;
        [_trendchartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _trendchartButton.layer.masksToBounds = YES;
    }
    return _trendchartButton;
}

- (UIButton *)calculatorButton{
    if (!_calculatorButton){
        _calculatorButton = [[UIButton alloc] init];
        [_calculatorButton setTitle:@"算奖工具" forState:UIControlStateNormal];
        [_calculatorButton setTitleColor:kUIColorFromRGB10(78,132,239) forState:UIControlStateNormal];
        [_calculatorButton setImage:[UIImage imageNamed:@"calculator"] forState:UIControlStateNormal];
        [_calculatorButton setImage:[UIImage imageNamed:@"calculator"] forState:UIControlStateHighlighted];
        [_calculatorButton setImageEdgeInsets:UIEdgeInsetsMake(kPadding10/2, 0, kPadding10/2, kPadding10/2)];
        [_calculatorButton setTitleEdgeInsets:UIEdgeInsetsMake(kPadding10/2, kPadding10/2, kPadding10/2, 0)];
        [_calculatorButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        _calculatorButton.tag = LotteryBottomTools_calculator;
        [_calculatorButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _calculatorButton.layer.masksToBounds = YES;
    }
    return _calculatorButton;
}

- (void)buttonClick:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lotteryBottomToolsbar:selectTools:)]){
        [self.delegate lotteryBottomToolsbar:self selectTools:(LotteryBottomTools)button.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
