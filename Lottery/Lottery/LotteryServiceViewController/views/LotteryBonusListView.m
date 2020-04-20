//
//  LotteryBonusListView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryBonusListView.h"
#import "GlobalDefines.h"
#import "LotteryWinningModel.h"
#import "Masonry.h"
#import "LotteryPracticalMethod.h"

#define kLotteryBonusListViewFontSize  15

@interface LotteryBonusListView()
@property (nonatomic, strong) UIView *salesJackpotView;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UILabel *jackpotLabel;
@property (nonatomic, strong) UIView *salesJackpotLineView;
@property (nonatomic, strong) UIView *levelView;
@end


@implementation LotteryBonusListView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.salesJackpotView];
    [self addSubview:self.levelView];
    [self.salesJackpotView addSubview:self.salesLabel];
    [self.salesJackpotView addSubview:self.jackpotLabel];
    [self.salesJackpotView addSubview:self.salesJackpotLineView];
    
    
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kPadding20);
        make.width.mas_equalTo(self.salesJackpotView).multipliedBy(1/2.0);
        make.bottom.mas_equalTo(-kPadding20);
    }];
    [self.jackpotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.salesLabel.mas_right);
        make.top.mas_equalTo(self.salesLabel);
        make.right.mas_equalTo(0);
    }];
    [self.salesJackpotLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.salesLabel.mas_right).offset(-1);
        make.centerY.mas_equalTo(self.salesJackpotView);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(self.salesJackpotLineView).multipliedBy(3/5.0);
    }];
    
    [self.salesJackpotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.salesJackpotView);
        make.top.mas_equalTo(self.salesJackpotView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(LotteryWinningModel *)model{
    _model = model;
    NSString *sales = [LotteryPracticalMethod getMaxUnitText:[model.sales longLongValue] withPrecisionNum:2];
    NSString *jackpot = [LotteryPracticalMethod getMaxUnitText:[model.jackpot longLongValue] withPrecisionNum:2];
    
    NSString *salesText = [NSString stringWithFormat:@"%@：%@", kLocalizedString(@"本期销量(元)"), sales];
    NSString *jackpotText = [NSString stringWithFormat:@"%@：%@", kLocalizedString(@"奖池累积(元)"), jackpot];
    self.salesLabel.attributedText = [self getAttributeString:salesText redStr:sales];
    self.jackpotLabel.attributedText = [self getAttributeString:jackpotText redStr:jackpot];
    
    [self reloadLevelView];
}

- (NSMutableAttributedString *)getAttributeString:(NSString *)text redStr:(NSString *)redStr {
    NSRange redRange = [text rangeOfString:redStr];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attriStr addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(redRange.location, redRange.length-1)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kLotteryBonusListViewFontSize] range:NSMakeRange(0, redRange.location)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kLotteryBonusListViewFontSize + 7] range:NSMakeRange(redRange.location, redRange.length-1)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kLotteryBonusListViewFontSize] range:NSMakeRange(redRange.location+redRange.length-1, 1)];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(redRange.location,  redRange.length)];
    
    return attriStr;
}

- (UIView *)createPrizeSubView:(LotteryPrizeModel *)model{
    UIView *view = [[UIView alloc] init];
    
    UILabel *levenLabel = [self createDefaultLotteryBonusListLabel];
    levenLabel.text = model.level;
    
    UILabel *numberLabel = [self createDefaultLotteryBonusListLabel];
    numberLabel.text = model.number;
    
    UILabel *bonusLabel = [self createDefaultLotteryBonusListLabel];
    bonusLabel.text = model.bonus;
    
    UIView *line1 = [[UIView alloc] init];
    UIView *line2 = [[UIView alloc] init];
    line1.backgroundColor = kDividingLineColor;
    line2.backgroundColor = kDividingLineColor;
    
    [numberLabel addSubview:line1];
    [numberLabel addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.5);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-0.5);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [view addSubview:levenLabel];
    [view addSubview:numberLabel];
    [view addSubview:bonusLabel];
    for (UIView *v in view.subviews){
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.height.mas_equalTo(view.mas_height);
        }];
    }
    return view;
}

- (void)reloadLevelView{
    [self.levelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    LotteryPrizeModel *prizeModel = [[LotteryPrizeModel alloc] init];
    prizeModel.level = kLocalizedString(@"奖级");
    prizeModel.number = kLocalizedString(@"中奖注数");
    prizeModel.bonus = kLocalizedString(@"单注奖金");
    NSMutableArray *prizeArray = [@[prizeModel] mutableCopy];
    [prizeArray addObjectsFromArray:self.model.prizeArray];
    
    UIView *lastBackView;
    for (int i = 0; i < prizeArray.count; i++) {
        LotteryPrizeModel *model = prizeArray[i];
        UIView *prizeView = [self createPrizeSubView:model];
        if (i == 0){
            prizeView.backgroundColor = kUIColorFromRGB10(245, 245, 245);
        }
        prizeView.layer.borderWidth = 1;
        prizeView.layer.borderColor = kDividingLineColor.CGColor;
        [self.levelView addSubview:prizeView];
        
        [prizeView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [prizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kPadding20);
            make.right.mas_equalTo(-kPadding20);
            make.height.mas_equalTo(40);
            if (lastBackView){
                make.top.mas_equalTo(lastBackView.mas_bottom).offset(-1);
            } else {
                make.top.mas_equalTo(0);
            }
        }];
        lastBackView = prizeView;
    }
    [lastBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}

- (UIView *)levelView{
    if (!_levelView){
        _levelView = [[UIView alloc] init];
    }
    return _levelView;
}

- (UIView *)salesJackpotView{
    if (!_salesJackpotView){
        _salesJackpotView = [[UIView alloc] init];
    }
    return _salesJackpotView;
}

- (UIView *)salesJackpotLineView{
    if (!_salesJackpotLineView){
        _salesJackpotLineView = [[UIView alloc] init];
        _salesJackpotLineView.backgroundColor = kDividingLineColor;
    }
    return _salesJackpotLineView;
}

- (UILabel *)salesLabel{
    if (!_salesLabel){
        _salesLabel = [self createDefaultLotteryBonusListLabel];
    }
    return _salesLabel;
}

- (UILabel *)jackpotLabel{
    if (!_jackpotLabel){
        _jackpotLabel = [self createDefaultLotteryBonusListLabel];
    }
    return _jackpotLabel;
}

- (UILabel *)createDefaultLotteryBonusListLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.commonSubtitleTintTextColor;
    label.font = [UIFont systemFontOfSize:kLotteryBonusListViewFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
