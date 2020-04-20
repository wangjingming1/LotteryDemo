//
//  LSVCLotteryWinningView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LSVCLotteryWinningView.h"
#import "LotteryWinningModel.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "UIImageView+AddImage.h"
#import "LSVCBallImageView.h"

#import "LotteryBonusListView.h"
#import "LotteryBottomToolsbar.h"
#import "LotteryPracticalMethod.h"

/**彩票种类字号*/
#define kLotteryWinningViewKindNameLabelSize    17
/**期数时间及奖池字号*/
#define kLotteryWinningViewLotteryInfoLabelSize 10
/**红蓝球字号*/
#define kLotteryWinningViewBallLabelSize        15

#define kLotteryInfoLabelFont [UIFont systemFontOfSize:\
self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod ? kLotteryWinningViewBallLabelSize :  kLotteryWinningViewLotteryInfoLabelSize]\

@interface LSVCLotteryWinningView()<LotteryBottomToolsbarDelegate>
/**中奖信息底视图*/
@property (nonatomic, strong) UIView *backView;
/**彩种及时间奖池等信息*/
@property (nonatomic, strong) UIView *lotteryInfoView;
/**红蓝球中间的线*/
@property (nonatomic, strong) UIView *redBallRightLineView;

/**工具栏(走势图，算奖工具)*/
@property (nonatomic, strong) LotteryBottomToolsbar *toolsBar;//CalculatorBonusViewController
/**奖金奖级列表*/
@property (nonatomic, strong) LotteryBonusListView *bonusListView;
@end

@implementation LSVCLotteryWinningView
{
    MASConstraint *_bonusListViewHeight;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = LSVCLotteryWinningViewStyle_LotteryService;
        self.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (instancetype)initWithStyle:(LSVCLotteryWinningViewStyle)style
{
    self = [self init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (void)setUI{
    //初始化一个点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAcyion:)];
    //把点击手势加上
    [self.backView addGestureRecognizer:tap];
    
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.lotteryInfoView];
    
    [self.lotteryInfoView addSubview:self.kindNameLabel];
    [self.lotteryInfoView addSubview:self.issueNumberLabel];
    [self.lotteryInfoView addSubview:self.dateLabel];
    [self.lotteryInfoView addSubview:self.jackpotLabel];
    
    [self.backView addSubview:self.redBallView];
    [self.backView addSubview:self.redBallRightLineView];
    [self.backView addSubview:self.blueBallView];
    [self.backView addSubview:self.ballBackLineView];
    [self.backView addSubview:self.testNumberLabel];
    [self.backView addSubview:self.rightArrowView];
    
    [self addSubview:self.bonusListView];
    [self addSubview:self.toolsBar];
    [self addSubview:self.backLineView];
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [self.lotteryInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(kPadding10);
        make.right.mas_equalTo(-kPadding10);
        make.top.mas_equalTo(kPadding10);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kPadding15);
        make.centerY.mas_equalTo(self.lotteryInfoView);
    }];
    [self.kindNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.issueNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kindNameLabel);
        make.top.mas_equalTo(self.kindNameLabel.mas_bottom).offset(kPadding10/2);
        make.bottom.mas_equalTo(0);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.issueNumberLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.issueNumberLabel);
    }];
    [self.jackpotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    [self.redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.lotteryInfoView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [self.redBallRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redBallView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.redBallView);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(self.redBallView.mas_height).multipliedBy(1/2.0);
    }];
    [self.blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redBallRightLineView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.redBallRightLineView);
    }];
    
    [self.ballBackLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.redBallView.mas_bottom).offset(kPadding15);
        make.height.mas_equalTo(1);
    }];
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.centerY.mas_equalTo(self.backView);
    }];
    
    [self.bonusListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.backView.mas_bottom);
        _bonusListViewHeight = make.height.mas_equalTo(0);
    }];
    
    [self.toolsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bonusListView);
        make.top.mas_equalTo(self.bonusListView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self.backLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolsBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    //bonusListViewHeight在只有需要的时候才装载
    [_bonusListViewHeight uninstall];
}

- (void)setStyle:(LSVCLotteryWinningViewStyle)style{
    _style = style;
    
    self.issueNumberLabel.font = kLotteryInfoLabelFont;
    self.dateLabel.font = kLotteryInfoLabelFont;
    self.jackpotLabel.font = kLotteryInfoLabelFont;
    
    self.iconView.hidden = self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod;
    self.kindNameLabel.hidden = self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod;
    self.issueNumberLabel.textColor = self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod ? UIColor.commonTitleTintTextColor : UIColor.commonSubtitleTintTextColor;
    self.dateLabel.textColor = self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod ? UIColor.commonTitleTintTextColor : UIColor.commonSubtitleTintTextColor;
    
    self.ballBackLineView.hidden = self.style == LSVCLotteryWinningViewStyle_HomePage;
    self.backLineView.hidden = self.style == LSVCLotteryWinningViewStyle_LotteryService;
    if (_style == LSVCLotteryWinningViewStyle_HomePage){
        [self updateConstraintsWithHomePage];
    } else if (_style == LSVCLotteryWinningViewStyle_LotteryService){
        [self updateConstraintsWithLotteryService];
    } else if (_style == LSVCLotteryWinningViewStyle_LotteryPastPeriod){
        [self updateConstraintsWithLotteryPastPeriod];
    }
}

- (void)updateConstraintsWithHomePage{
    [self.kindNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    [self.lotteryInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(kPadding10);
    }];
    [self.issueNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kindNameLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.kindNameLabel);
    }];
    [self.jackpotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kindNameLabel);
        make.right.mas_equalTo(self.jackpotLabel.superview).offset(-kPadding10);
    }];
    [self.redBallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [self.rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.centerY.mas_equalTo(self.redBallView);
    }];
    
    [self.backLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
        make.right.mas_equalTo(-kPadding15);
    }];
    [self.toolsBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)updateConstraintsWithLotteryService{
    [self.kindNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.lotteryInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(kPadding10);
    }];
    [self.issueNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kindNameLabel);
        make.top.mas_equalTo(self.kindNameLabel.mas_bottom).offset(kPadding10/2);
        make.bottom.mas_equalTo(0);
    }];
    [self.jackpotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    [self.redBallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.lotteryInfoView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    
    [self.rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.centerY.mas_equalTo(self.backView);
    }];
    [self.backLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
    }];
    [self.toolsBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
}

- (void)updateConstraintsWithLotteryPastPeriod{
    [self.kindNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.lotteryInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
    }];
    [self.issueNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kPadding10);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kPadding10);
    }];
    [self.jackpotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    [self.redBallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.lotteryInfoView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    
    [self.rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.centerY.mas_equalTo(self.backView);
    }];
    [self.backLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
    }];
    
    [self.toolsBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)setModel:(LotteryWinningModel *)model{
    _model = model;
    [self.iconView setImageWithName:self.model.icon];
    self.kindNameLabel.text = self.model.kindName;
    self.issueNumberLabel.text = self.model.issueNumber;
    self.dateLabel.text = [model dateToGeneralFormat];
    long long jackpot = [self.model.jackpot longLongValue];
    if (jackpot == 0){
        self.jackpotLabel.text = @"";
    } else {
        self.jackpotLabel.text = [LotteryPracticalMethod getMaxUnitText:jackpot withPrecisionNum:2];
    }
    
    [self reloadRightArrowViewImage];
    [self reloadBallView:self.redBallView ballStyle:LSVCBallStyle_redBall ballStr:self.model.redBall];
    [self reloadBallView:self.blueBallView ballStyle:LSVCBallStyle_blueBall ballStr:self.model.blueBall];
    [self.redBallRightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self.model.blueBall isEqualToString:@""]){
            make.width.mas_equalTo(0);
        } else {
            make.width.mas_equalTo(1);
        }
    }];
    if (self.style == LSVCLotteryWinningViewStyle_LotteryService){
        self.toolsBar.identifier = self.model.identifier;
    }
    if (self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod && self.model.showPrizeView){
        self.bonusListView.model = self.model;
        [_bonusListViewHeight uninstall];
    } else {
        [_bonusListViewHeight install];
    }
    [self.ballBackLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod && self.model.showPrizeView){
            make.left.mas_equalTo(kPadding20);
            make.right.mas_equalTo(-kPadding20);
        } else {
            make.left.right.mas_equalTo(0);
        }
    }];
    [self.backLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod && self.model.showPrizeView){
            make.top.mas_equalTo(self.toolsBar.mas_bottom).mas_equalTo(kPadding15);
        } else {
            make.top.mas_equalTo(self.toolsBar.mas_bottom);
        }
    }];
}

- (void)reloadRightArrowViewImage{
    if (self.style == LSVCLotteryWinningViewStyle_LotteryPastPeriod){
        if (self.model.showPrizeView){
            [self.rightArrowView setImageWithName:@"upArrow"];
        } else {
            [self.rightArrowView setImageWithName:@"downArrow"];
        }
    } else {
        [self.rightArrowView setImageWithName:@"rightArrow"];
    }
}

- (void)reloadBallView:(UIView *)ballView ballStyle:(LSVCBallStyle)ballStyle ballStr:(NSString *)ballStr{
    [ballView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *redBallArray = [ballStr componentsSeparatedByString:@","];
    if (redBallArray.count && ![redBallArray.firstObject isEqualToString:@""]){
        UIView *lastView;
        for (NSString *redBall in redBallArray){
            LSVCBallImageView *ballImageView = [[LSVCBallImageView alloc] initWithBallStyle:ballStyle ballTitle:redBall];
            [ballImageView setBallTitleLabelFontSize:kLotteryWinningViewBallLabelSize];
            [ballView addSubview:ballImageView];
            [ballImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView){
                    make.left.mas_equalTo(lastView.mas_right).offset(kPadding10);
                } else {
                    make.left.mas_equalTo(0);
                }
                make.top.bottom.mas_equalTo(0);
            }];
            lastView = ballImageView;
        }
        if (lastView){
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
        }
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIView *)lotteryInfoView{
    if (!_lotteryInfoView){
        _lotteryInfoView = [[UIView alloc] init];
    }
    return _lotteryInfoView;
}

- (UIImageView *)iconView{
    if (!_iconView){
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)kindNameLabel{
    if (!_kindNameLabel){
        _kindNameLabel = [[UILabel alloc] init];
        _kindNameLabel.numberOfLines = 1;
        _kindNameLabel.textColor = UIColor.commonTitleTintTextColor;
        _kindNameLabel.font = [UIFont boldSystemFontOfSize:kLotteryWinningViewKindNameLabelSize];
    }
    return _kindNameLabel;
}

- (UILabel *)issueNumberLabel{
    if (!_issueNumberLabel){
        _issueNumberLabel = [[UILabel alloc] init];
        _issueNumberLabel.numberOfLines = 1;
        _issueNumberLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _issueNumberLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _issueNumberLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _dateLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _dateLabel;
}

- (UILabel *)jackpotLabel{
    if (!_jackpotLabel){
        _jackpotLabel = [[UILabel alloc] init];
        _jackpotLabel.numberOfLines = 1;
        _jackpotLabel.textColor = [UIColor redColor];
        _jackpotLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _jackpotLabel;
}

- (UIView *)redBallView{
    if (!_redBallView){
        _redBallView = [[UIView alloc] init];
    }
    return _redBallView;
}

- (UIView *)redBallRightLineView{
    if (!_redBallRightLineView){
        _redBallRightLineView = [[UIView alloc] init];
        _redBallRightLineView.backgroundColor = kDividingLineColor;
    }
    return _redBallRightLineView;
}

- (UIView *)blueBallView{
    if (!_blueBallView){
        _blueBallView = [[UIView alloc] init];
    }
    return _blueBallView;
}

- (UIImageView *)rightArrowView{
    if (!_rightArrowView){
        _rightArrowView = [[UIImageView alloc] init];
        [_rightArrowView setImageWithName:@"rightArrow"];
    }
    return _rightArrowView;
}

- (UIView *)ballBackLineView{
    if (!_ballBackLineView){
        _ballBackLineView = [[UIView alloc] init];
        _ballBackLineView.backgroundColor = kDividingLineColor;
    }
    return _ballBackLineView;
}

- (LotteryBonusListView *)bonusListView{
    if (!_bonusListView){
        _bonusListView = [[LotteryBonusListView alloc] init];
        _bonusListView.layer.masksToBounds = YES;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColor.commonBackgroundColor;
        [_bonusListView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(kPadding20);
            make.right.mas_equalTo(-kPadding20);
            make.height.mas_equalTo(1);
        }];
        
    }
    return _bonusListView;
}

- (LotteryBottomToolsbar *)toolsBar{
    if (!_toolsBar){
        _toolsBar = [[LotteryBottomToolsbar alloc] init];
        _toolsBar.layer.masksToBounds = YES;
        [_toolsBar setToolsbarTextFont:[UIFont systemFontOfSize:15]];
        _toolsBar.delegate = self;
    }
    return _toolsBar;
}

- (UIView *)backLineView{
    if (!_backLineView){
        _backLineView = [[UIView alloc] init];
        _backLineView.backgroundColor = kDividingLineColor;
    }
    return _backLineView;
}
#pragma mark - LSVCLotteryWinningViewDelegate
- (void)tapAcyion:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        params[@"leftTitle"] = self.model.kindName;
        params[@"identifier"] = self.model.identifier;
        [self.delegate pushViewController:NSClassFromString(@"LotteryPastPeriodViewController") params:params];
    }
}

#pragma mark - LotteryBottomToolsbarDelegate
- (void)lotteryBottomToolsbar:(LotteryBottomToolsbar *)toolsbar selectTools:(LotteryBottomTools)tools{
    NSLog(@"lotteryBottomToolsbar");
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"identifier"] = self.model.identifier;
    NSString *classStr = @"";
    if (tools == LotteryBottomTools_trendchart){
        classStr = @"TrendChartViewController";
        params[@"leftTitle"] = kLocalizedString(@"走势图");
    } else if (tools == LotteryBottomTools_calculator){
        classStr = @"CalculatorBonusViewController";
        params[@"leftTitle"] = kLocalizedString(@"算奖工具");
    }
    [self.delegate pushViewController:NSClassFromString(classStr) params:params];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
