//
//  CalculatorBonusView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "CalculatorBonusView.h"
#import "LotteryWinningModel.h"
#import "LotteryPlayRulesModel.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "UIImageView+AddImage.h"
#import "LSVCBallImageView.h"
#import "LotteryPracticalMethod.h"
#import "UIImage+Expand.h"
#import "WJMTagLabel.h"
#import "BonusView.h"

typedef NS_ENUM(NSInteger, SubBallTag){
    SubBall_redTag = 1000,
    SubBall_blueTag = 2000,
    SubBall_redBallCountTag = 3000,
    SubBall_blueBallCountTag = 4000
};

@interface CalculatorBonusView()
@property (nonatomic, strong) UILabel *issueNumberLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *ballView;

@property (nonatomic, strong) UIButton *calculatorBtn;
@property (nonatomic, strong) UIView *issueNumberBackView;
@property (nonatomic, strong) UIView *mySelectBallView;
@property (nonatomic, strong) UIView *myTargetBallView;
@property (nonatomic, strong) UIView *calculatorView;
@property (nonatomic, strong) WJMTagLabel *newestLabel;
@property (nonatomic, strong) BonusView *bonusView;
@end

@implementation CalculatorBonusView
{
    CGFloat _labelFontSize;
    CGFloat _subLabelFontSize;
    NSUInteger _curIndex;
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
    _labelFontSize = 20;
    _subLabelFontSize = 15;
    _curIndex = 0;
    self.initSelectBall = NO;
}

- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.issueNumberBackView];
    [self addSubview:self.mySelectBallView];
    [self addSubview:self.myTargetBallView];
    [self addSubview:self.calculatorView];
    
    [self addTapGesture:self.issueNumberBackView];
    [self addTapGesture:self.mySelectBallView];
    [self addTapGesture:self.myTargetBallView];
    
    [self.issueNumberBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.mySelectBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.issueNumberBackView);
        make.top.mas_equalTo(self.issueNumberBackView.mas_bottom).offset(kPadding10);
    }];
    [self.myTargetBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mySelectBallView);
        make.top.mas_equalTo(self.mySelectBallView.mas_bottom);
    }];
    [self.calculatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.myTargetBallView);
        make.top.mas_equalTo(self.myTargetBallView.mas_bottom);
        make.bottom.mas_equalTo(-kPadding10);
    }];
}

- (void)setModel:(LotteryWinningModel *)model{
    if (self.initSelectBall || !_model){
        [self reloadMyBallView:self.mySelectBallView redCount:[NSString stringWithFormat:@"%ld", model.playRulesModel.redBullCount] blueCount:[NSString stringWithFormat:@"%ld", model.playRulesModel.blueBullCount]];
        [self reloadMyBallView:self.myTargetBallView redCount:@"0" blueCount:@"0"];
        [self removeBonusView];
    }
    _model = model;
    self.issueNumberLabel.text = model.issueNumber;
    self.dateLabel.text = [model dateToGeneralFormat];
    self.newestLabel.hidden = !model.newest;
    
    [self reloadBallView:model];
    if (!self.initSelectBall) {
        [self calculatorBonus];
    }
}

- (void)reloadBallView:(LotteryWinningModel *)model{
    NSArray *redBallArray = [model.redBall componentsSeparatedByString:@","];
    NSArray *blueBallArray = [model.blueBall componentsSeparatedByString:@","];
    [self.ballView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createSubBallLabel:redBallArray ballStyle:LSVCBallStyle_redBall tag:SubBall_redTag];
    [self createSubBallLabel:blueBallArray ballStyle:LSVCBallStyle_blueBall tag:SubBall_blueTag];
    
    [self.ballView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
    [self.ballView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)createSubBallLabel:(NSArray *)ballArray ballStyle:(LSVCBallStyle)ballStyle tag:(NSInteger)tag{
    for (int i = 0; i < ballArray.count; i++){
        NSString *ballStr = ballArray[i];
        LSVCBallImageView *ballImageView = [[LSVCBallImageView alloc] initWithBallStyle:ballStyle ballTitle:ballStr];
        [ballImageView setBallTitleLabelFontSize:14];
        ballImageView.tag = SubBall_redTag + i;
        [self.ballView addSubview:ballImageView];
    }
}

- (UIView *)createMyBallView:(NSString *)title defRedBallCount:(NSString *)defRedBallCount defBlueBallCount:(NSString *)defBlueBallCount{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
    UILabel *titleLabel = [self createLabel:title fontSize:_subLabelFontSize];
        
    UIView *redBallView = [[UIView alloc] init];
    LSVCBallImageView *redBallImageView = [[LSVCBallImageView alloc] init];
    redBallImageView.ballStyle = LSVCBallStyle_redBall;
    UILabel *redBallLabel = [self createLabel:kLocalizedString(@"红球") fontSize:_subLabelFontSize];
    UILabel *redBallCountLabel = [self createLabel:defRedBallCount fontSize:_subLabelFontSize];
    redBallCountLabel.textColor = [redBallImageView getColor];
    UILabel *redBallUnitLabel = [self createLabel:kLocalizedString(@"个") fontSize:_subLabelFontSize];
    
    UIView *blueBallView = [[UIView alloc] init];
    LSVCBallImageView *blueBallImageView = [[LSVCBallImageView alloc] init];
    blueBallImageView.ballStyle = LSVCBallStyle_blueBall;
    UILabel *blueBallLabel = [self createLabel:kLocalizedString(@"蓝球") fontSize:_subLabelFontSize];
    UILabel *blueBallCountLabel = [self createLabel:defBlueBallCount fontSize:_subLabelFontSize];
    blueBallCountLabel.textColor = [blueBallImageView getColor];
    UILabel *blueBallUnitLabel = [self createLabel:kLocalizedString(@"个") fontSize:_subLabelFontSize];
    
    UIImageView *rightArrowView = [self createRightArrowView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kUIColorFromRGB10(200, 200, 200);
    
    [view addSubview:titleLabel];
    [view addSubview:redBallView];
    [view addSubview:blueBallView];
    
    [redBallView addSubview:redBallImageView];
    [redBallView addSubview:redBallLabel];
    [redBallView addSubview:redBallCountLabel];
    [redBallView addSubview:redBallUnitLabel];
    
    [blueBallView addSubview:blueBallImageView];
    [blueBallView addSubview:blueBallLabel];
    [blueBallView addSubview:blueBallCountLabel];
    [blueBallView addSubview:blueBallUnitLabel];
    [view addSubview:rightArrowView];
    [view addSubview:lineView];
    
    redBallCountLabel.tag = SubBall_redBallCountTag;
    blueBallCountLabel.tag = SubBall_blueBallCountTag;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kPadding10);
    }];
    [redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.width.mas_equalTo(view.mas_width).multipliedBy(1/3.0);
    }];
    [blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(redBallView.mas_right);
        make.top.mas_equalTo(redBallView);
        make.width.mas_equalTo(view.mas_width).multipliedBy(1/3.0);
        make.bottom.mas_equalTo(0);
    }];
    [redBallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(kPadding15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [redBallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(redBallImageView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(redBallImageView);
    }];
    [redBallCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(redBallLabel.mas_right).offset(kPadding10/2);
        make.centerY.mas_equalTo(redBallImageView);
    }];
    [redBallUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(redBallCountLabel.mas_right).offset(1);
        make.centerY.mas_equalTo(redBallImageView);
    }];
    
    [blueBallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(kPadding15);
        make.size.mas_equalTo(redBallImageView);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [blueBallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blueBallImageView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(blueBallImageView);
    }];
    [blueBallCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blueBallLabel.mas_right).offset(kPadding10/2);
        make.centerY.mas_equalTo(blueBallImageView);
    }];
    [blueBallUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blueBallCountLabel.mas_right).offset(1);
        make.centerY.mas_equalTo(blueBallImageView);
    }];
    [rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding20);
        make.centerY.mas_equalTo(view);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    return view;
}

- (void)reloadMyBallView:(UIView *)myBallView redCount:(NSString *)redCount blueCount:(NSString *)blueCount{
    UILabel *redBallCountLabel = [myBallView viewWithTag:SubBall_redBallCountTag];
    UILabel *blueBallCountLabel = [myBallView viewWithTag:SubBall_blueBallCountTag];
    [redBallCountLabel setText:redCount];
    [blueBallCountLabel setText:blueCount];

    self.calculatorBtn.enabled = [self isCalculatorBonus];
    if (!self.calculatorBtn.enabled){
        [self removeBonusView];
    }
}

- (void)createBonusView:(NSArray <LotteryPrizeModel *> *)modelArray{
    [self removeBonusView];
    if (modelArray.count){
        self.bonusView = [[BonusView alloc] init];
        self.bonusView.prizeModelArray = modelArray;
        
        [self.calculatorView addSubview:self.bonusView];
        [self.bonusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.calculatorBtn.mas_bottom).offset(kPadding10);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)calculatorButtonClick:(UIButton *)button{
    NSLog(@"计算奖金click");
    [self calculatorBonus];
}

- (BOOL)isCalculatorBonus{
    int selectRedCount = [((UILabel *)[self.mySelectBallView viewWithTag:SubBall_redBallCountTag]).text intValue];
    int selectBlueCount = [((UILabel *)[self.mySelectBallView viewWithTag:SubBall_blueBallCountTag]).text intValue];
    
    int guessRedCount = [((UILabel *)[self.myTargetBallView viewWithTag:SubBall_redBallCountTag]).text intValue];
    int guessBlueCount = [((UILabel *)[self.myTargetBallView viewWithTag:SubBall_blueBallCountTag]).text intValue];
    return (selectRedCount && selectBlueCount && (guessRedCount || guessBlueCount));
}

- (void)calculatorBonus{
    if ([self isCalculatorBonus]){
        int selectRedCount = [((UILabel *)[self.mySelectBallView viewWithTag:SubBall_redBallCountTag]).text intValue];
        int selectBlueCount = [((UILabel *)[self.mySelectBallView viewWithTag:SubBall_blueBallCountTag]).text intValue];
        
        int guessRedCount = [((UILabel *)[self.myTargetBallView viewWithTag:SubBall_redBallCountTag]).text intValue];
        int guessBlueCount = [((UILabel *)[self.myTargetBallView viewWithTag:SubBall_blueBallCountTag]).text intValue];
        NSArray <LotteryPrizeModel *> *array = [self.model calculatorPrizeArrayWithSelectRedCount:selectRedCount selectBlueCount:selectBlueCount guessRedCount:guessRedCount guessBlueCount:guessBlueCount];
        [self createBonusView:array];
    }
}

- (void)showOtherViewByTapGesture:(UITapGestureRecognizer *)tapGesture{
    WS(weakSelf);
    if (tapGesture.view == self.issueNumberBackView && [self.delegate respondsToSelector:@selector(calculatorBonusView:showIssueNumberSelector:)]){
        [self.delegate calculatorBonusView:self showIssueNumberSelector:^(LotteryWinningModel * _Nonnull newModel) {
            weakSelf.model = newModel;
        }];
    } else if (tapGesture.view == self.mySelectBallView && [self.delegate respondsToSelector:@selector(calculatorBonusView:showMySelectBallSelector:oldBlueCount:result:)]){
        UILabel *redBallCountLabel = [tapGesture.view viewWithTag:SubBall_redBallCountTag];
        UILabel *blueBallCountLabel = [tapGesture.view viewWithTag:SubBall_blueBallCountTag];
        [self.delegate calculatorBonusView:self showMySelectBallSelector:redBallCountLabel.text oldBlueCount:blueBallCountLabel.text result:^(NSString * _Nonnull newRedCount, NSString * _Nonnull newBlueCount) {
            [weakSelf reloadMyBallView:tapGesture.view redCount:newRedCount blueCount:newBlueCount];
        }];
    } else if (tapGesture.view == self.myTargetBallView && [self.delegate respondsToSelector:@selector(calculatorBonusView:showMyTargetBallSelector:oldBlueCount:result:)]){
        UILabel *redBallCountLabel = [tapGesture.view viewWithTag:SubBall_redBallCountTag];
        UILabel *blueBallCountLabel = [tapGesture.view viewWithTag:SubBall_blueBallCountTag];
        [self.delegate calculatorBonusView:self showMyTargetBallSelector:redBallCountLabel.text oldBlueCount:blueBallCountLabel.text result:^(NSString * _Nonnull newRedCount, NSString * _Nonnull newBlueCount) {
            [weakSelf reloadMyBallView:tapGesture.view redCount:newRedCount blueCount:newBlueCount];
        }];
    }
}

- (void)addTapGesture:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOtherViewByTapGesture:)];
    [view addGestureRecognizer:tap];
}

- (UILabel *)createLabel:(NSString *)title fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

- (UIImageView *)createRightArrowView{
    UIImageView *righrArrowView = [[UIImageView alloc] init];
    [righrArrowView setImageWithName:@"rightArrow"];
    return righrArrowView;
}

- (UILabel *)issueNumberLabel{
    if (!_issueNumberLabel){
        _issueNumberLabel = [[UILabel alloc] init];
        _issueNumberLabel.font = [UIFont boldSystemFontOfSize:_labelFontSize];
        _issueNumberLabel.textColor = UIColor.commonTitleTintTextColor;
    }
    return _issueNumberLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [self createLabel:@"" fontSize:_subLabelFontSize];
        _dateLabel.textColor = UIColor.commonSubtitleTintTextColor;
    }
    return _dateLabel;
}

- (WJMTagLabel *)newestLabel{
    if (!_newestLabel){
        _newestLabel = [[WJMTagLabel alloc] init];
        _newestLabel.text = kLocalizedString(@"最新");
        _newestLabel.backgroundColor = [UIColor redColor];
        _newestLabel.textColor = [UIColor whiteColor];
        _newestLabel.textAlignment = NSTextAlignmentCenter;
        _newestLabel.font = [UIFont systemFontOfSize:12];
        _newestLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _newestLabel;
}

- (UIView *)ballView{
    if (!_ballView){
        _ballView = [[UIView alloc] init];
    }
    return _ballView;
}

- (UIView *)issueNumberBackView {
    if (!_issueNumberBackView){
        _issueNumberBackView = [[UIView alloc] init];
        _issueNumberBackView.backgroundColor = UIColor.commonGroupedBackgroundColor;// [UIColor whiteColor];
        
        UILabel *issueNumberSelectLabel = [self createLabel:kLocalizedString(@"期次选择") fontSize:_subLabelFontSize];
        issueNumberSelectLabel.textColor = UIColor.commonSubtitleTintTextColor;
        
        UIImageView *rightArrowView = [self createRightArrowView];
        UIView *dividingLineView = [[UIView alloc] init];
        dividingLineView.backgroundColor = UIColor.commonBackgroundColor;

        [_issueNumberBackView addSubview:issueNumberSelectLabel];
        [_issueNumberBackView addSubview:self.issueNumberLabel];
        [_issueNumberBackView addSubview:self.newestLabel];
        [_issueNumberBackView addSubview:self.dateLabel];
        [_issueNumberBackView addSubview:self.ballView];
        [_issueNumberBackView addSubview:rightArrowView];
        [_issueNumberBackView addSubview:dividingLineView];
        
        [issueNumberSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kPadding10);
            make.top.mas_equalTo(kPadding10);
        }];
        [self.issueNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(issueNumberSelectLabel);
            make.top.mas_equalTo(issueNumberSelectLabel.mas_bottom).offset(kPadding10);
        }];
        [self.newestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.issueNumberLabel.mas_right);
            make.bottom.mas_equalTo(self.issueNumberLabel.mas_top).offset(-kPadding10);
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(issueNumberSelectLabel);
            make.top.mas_equalTo(self.issueNumberLabel.mas_bottom).offset(kPadding10);
//            make.bottom.mas_equalTo(-kPadding10);
        }];
        
        [rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kPadding10);
            make.centerY.mas_equalTo(_issueNumberBackView);
        }];
        
        [self.ballView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightArrowView.mas_left).offset(-kPadding10);
            make.centerY.mas_equalTo(_issueNumberBackView);
        }];
        [dividingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(kPadding10);
            make.height.mas_equalTo(kPadding10);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _issueNumberBackView;
}

- (UIView *)mySelectBallView{
    if (!_mySelectBallView){
        _mySelectBallView = [self createMyBallView:kLocalizedString(@"我的投注") defRedBallCount:@"0" defBlueBallCount:@"0"];
    }
    return _mySelectBallView;
}

- (UIView *)myTargetBallView{
    if (!_myTargetBallView){
        _myTargetBallView = [self createMyBallView:kLocalizedString(@"我的命中") defRedBallCount:@"0" defBlueBallCount:@"0"];
    }
    return _myTargetBallView;
}

- (UIButton *)calculatorBtn{
    if (!_calculatorBtn){
        _calculatorBtn = [[UIButton alloc] init];
        _calculatorBtn.layer.cornerRadius = 20;
        _calculatorBtn.layer.masksToBounds = YES;
        [_calculatorBtn setTitle:kLocalizedString(@"计算奖金") forState:UIControlStateNormal];
        
        [_calculatorBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [_calculatorBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
        [_calculatorBtn setBackgroundImage:[UIImage imageWithColor:UIColor.commonLightGreyColor] forState:UIControlStateDisabled];
        
        [_calculatorBtn setEnabled:NO];
        
        [_calculatorBtn addTarget:self action:@selector(calculatorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calculatorBtn;
}

- (UIView *)calculatorView{
    if (!_calculatorView){
        _calculatorView = [[UIView alloc] init];
        _calculatorView.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];

        [_calculatorView addSubview:self.calculatorBtn];
        [self.calculatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kPadding20*2);
            make.right.mas_equalTo(-kPadding20*2);
            make.top.mas_equalTo(kPadding20);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-kPadding20).priorityLow();
        }];
    }
    return _calculatorView;
}

- (void)removeBonusView{
    if (self.bonusView){
        [self.bonusView removeFromSuperview];
        self.bonusView = nil;
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
