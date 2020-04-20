//
//  BonusView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/13.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BonusView.h"
#import "GlobalDefines.h"
#import "LotteryWinningModel.h"
#import "Masonry.h"

@interface BonusView()
@property (nonatomic, strong) NSString *bouns;
@property (nonatomic, strong) UILabel *bonusLabel;
@property (nonatomic, strong) UIView *lotteryBonusDetailedView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation BonusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    self.backgroundColor = [UIColor whiteColor];//kUIColorFromRGB10(252, 253, 233);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kLocalizedString(@"中奖奖金");
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = kLocalizedString(@"开奖结果仅供参考，以官方开奖信息为准");
    tipsLab.textColor = UIColor.commonSubTipsTintTextColor;
    tipsLab.font = [UIFont systemFontOfSize:kSubTipsFontOfSize];
    
    [self addSubview:titleLabel];
    [self addSubview:self.bonusLabel];
    [self addSubview:self.lotteryBonusDetailedView];
    [self addSubview:tipsLab];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(kPadding20);
    }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(kPadding10);
    }];
    [self.lotteryBonusDetailedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bonusLabel.mas_bottom).offset(kPadding10);
        make.left.mas_equalTo(kPadding15*2);
        make.right.mas_equalTo(-kPadding15*2);
    }];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lotteryBonusDetailedView.mas_bottom).offset(kPadding10);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-kPadding20);
    }];
}

- (void)setPrizeModelArray:(NSArray<LotteryPrizeModel *> *)prizeModelArray{
    NSInteger bonus = 0;
    for (LotteryPrizeModel *model in prizeModelArray){
        bonus += [model.bonus integerValue] * [model.number integerValue];
    }
    _prizeModelArray = prizeModelArray;
    [self reloadBonusLabel:[NSString stringWithFormat:@"%ld",bonus]];
    [self reloadLotteryBonusDetailedView];
}

- (void)reloadBonusLabel:(NSString *)bonusStr{
    NSString *bonus = [NSString stringWithFormat:@"%@%@(%@)", bonusStr, kLocalizedString(@"元"), kLocalizedString(@"税前")];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:bonus];
    
    NSRange bonusStrRange = [bonus rangeOfString:bonusStr];
    NSRange yuanStrRange = [bonus rangeOfString:kLocalizedString(@"元")];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:bonusStrRange];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:bonusStrRange];
    
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:yuanStrRange];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:yuanStrRange];
    
    self.bonusLabel.attributedText = attriStr;
}

- (void)reloadLotteryBonusDetailedView{
    [self.lotteryBonusDetailedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *firstView = [self createFirstLotteryBonusDetailedView];
    [self.lotteryBonusDetailedView addSubview:firstView];
    for (int i = 0; i < self.prizeModelArray.count; i++){
        UIView *view = [self createLotteryBonusDetailedView:self.prizeModelArray[i]];
        if (i % 2 == 0){
            view.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
        } else {
            view.backgroundColor = kUIColorFromRGB10(237, 238, 239);
        }
        [self.lotteryBonusDetailedView addSubview:view];
    }
    for (UIView *view in self.lotteryBonusDetailedView.subviews){
        [view.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [view.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    [self.lotteryBonusDetailedView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [self.lotteryBonusDetailedView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
    }];
    for (UIView *view in self.lotteryBonusDetailedView.subviews){
        for (int i = 0; i < view.subviews.count - 1; i++){
            UIView *v = view.subviews[i];
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [kDividingLineColor colorWithAlphaComponent:0.5];
            [v addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(v.mas_right).offset(-0.5);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(v);
            }];
        }
    }
}

- (UIView *)createFirstLotteryBonusDetailedView{
    /**
    奖项、单注奖金(元)、中奖注数、中奖金额(元)
    字体颜色：kUIColorFromRGB10(224, 109, 72)
    背景色：kUIColorFromRGB10(251, 243, 202)
    */
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kUIColorFromRGB10(251, 243, 202);
    NSArray *labelArray = @[kLocalizedString(@"奖项"), kLocalizedString(@"单注奖金(元)"), kLocalizedString(@"中奖注数"), kLocalizedString(@"中奖金额(元)")];
    for (int i = 0; i < labelArray.count; i++){
        UILabel *label = [self createLabel:labelArray[i] fontSize:13];
        label.textColor = kUIColorFromRGB10(224, 109, 72);
        [backView addSubview:label];
    }
    
    return backView;
}

- (UIView *)createLotteryBonusDetailedView:(LotteryPrizeModel *)model{
    UIView *backView = [[UIView alloc] init];
    NSInteger bonus = [model.bonus integerValue];
    NSInteger count = [model.number integerValue];
    NSString *allBonus = [NSString stringWithFormat:@"%ld", bonus*count];
    UILabel *levelLabel = [self createLabel:model.level fontSize:13];
    UILabel *bonusLabel = [self createLabel:model.bonus fontSize:13];
    UILabel *bonusCountLabel = [self createLabel:model.number fontSize:13];
    UILabel *allBonusLabel = [self createLabel:allBonus fontSize:13];
    
    if (![model.number isEqualToString:@"0"]){
        bonusCountLabel.textColor = [UIColor redColor];
    }
    if (![allBonus isEqualToString:@"0"]){
        allBonusLabel.textColor = [UIColor redColor];
    }
    
    [backView addSubview:levelLabel];
    [backView addSubview:bonusLabel];
    [backView addSubview:bonusCountLabel];
    [backView addSubview:allBonusLabel];

    return backView;
}

- (UILabel *)createAllBonusLabel:(NSString *)allBonus{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = allBonus;
    if ([allBonus isEqualToString:@"0"]){
        label.textColor = UIColor.commonTitleTintTextColor;
    } else {
        label.textColor = [UIColor redColor];
    }
    return label;
}

- (UILabel *)createLabel:(NSString *)text fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = UIColor.commonTitleTintTextColor;
    label.text = text;
    return label;
}

- (UILabel *)bonusLabel{
    if (!_bonusLabel){
        _bonusLabel = [[UILabel alloc] init];
        _bonusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _bonusLabel;
}

- (UIView *)lotteryBonusDetailedView{
    if (!_lotteryBonusDetailedView){
        _lotteryBonusDetailedView = [[UIView alloc] init];
        _lotteryBonusDetailedView.layer.cornerRadius = 3;
        _lotteryBonusDetailedView.layer.borderWidth = 1;
        _lotteryBonusDetailedView.layer.borderColor = kUIColorFromRGB10(245, 209, 169).CGColor;
    }
    return _lotteryBonusDetailedView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadDrawLine];
}

- (void)reloadDrawLine{
    CGRect bouns = self.bounds;
    CGFloat w = CGRectGetWidth(bouns);
    CGFloat h = CGRectGetHeight(bouns);
    CGFloat triangleSide = 6;
    
    UIBezierPath *tagPath = [UIBezierPath new];
    [tagPath moveToPoint:CGPointMake(0, kPadding10)];
    [tagPath addLineToPoint:CGPointMake(w/2 - triangleSide, kPadding10)];
    [tagPath addLineToPoint:CGPointMake(w/2, kPadding10 - triangleSide)];
    [tagPath addLineToPoint:CGPointMake(w/2 + triangleSide, kPadding10)];
    [tagPath addLineToPoint:CGPointMake(w, kPadding10)];
    [tagPath addLineToPoint:CGPointMake(w, h + 1000)];
    [tagPath addLineToPoint:CGPointMake(0, h + 1000)];
    [tagPath addLineToPoint:CGPointMake(0, kPadding10)];
    
    [tagPath stroke];
    if (!self.shapeLayer){
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.frame = bouns;
        self.shapeLayer.lineWidth = 1;
        self.shapeLayer.strokeColor = kUIColorFromRGB10(228, 213, 113).CGColor;// [UIColor redColor].CGColor;
        self.shapeLayer.fillColor = kUIColorFromRGB10(253, 252, 233).CGColor;//[UIColor clearColor].CGColor;
        [self.shapeLayer removeFromSuperlayer];
        [self.layer insertSublayer:self.shapeLayer atIndex:0];
//        [self.layer addSublayer:self.shapeLayer];
    }
    self.shapeLayer.path = tagPath.CGPath;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
