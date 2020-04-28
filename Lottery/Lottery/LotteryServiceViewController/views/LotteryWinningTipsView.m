//
//  LotteryWinningTipsView.m
//  Lottery
//
//  Created by wangjingming on 2020/2/29.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryWinningTipsView.h"
#import "LotteryWinningModel.h"

#import "GlobalDefines.h"
#import "UIImageView+AddImage.h"
#import "UIView+Color.h"

#import "Masonry.h"

/**标题字号*/
#define kLotteryWinningTipsViewTitleLabelSize    15
/**提示文字字号*/
#define kLotteryWinningTipsViewTipsLabelSize     12

@interface LotteryWinningTipsView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *tipsIconImage;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *openingReminderButton;
@end

@implementation LotteryWinningTipsView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = UIColor.commonBackgroundColor;
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.tipsIconImage];
    [self.backView addSubview:self.tipsLabel];
    [self.backView addSubview:self.openingReminderButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kPadding15);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
        make.top.mas_equalTo(kPadding10);
    }];
    [self.tipsIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-kPadding15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding10);
    }];
    
    [self.openingReminderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.centerY.mas_equalTo(self.backView);
    }];
    
}

- (void)setModel:(LotteryWinningModel *)model{
    _model = model;
    self.tipsLabel.text = model.lotteryTime;
    kImportantReminder(@"tipsView作为tableView的hearderView时layoutIfNeeded下会避免遮挡cell的bug")
    //LotteryPastPeriodViewController
    //这里强制更新一下view 能避免作为tableview的headerView时会遮挡cell的bug
    [self layoutIfNeeded];
    [self.tipsLabel sizeToFit];
    [self.titleLabel sizeToFit];
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
        [_backView setShadowAndColor:UIColor.commonShadowColor];
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.commonTitleTintTextColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:kLotteryWinningTipsViewTitleLabelSize];
        _titleLabel.text = @"开奖提醒";
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _tipsLabel.font = [UIFont systemFontOfSize:kLotteryWinningTipsViewTipsLabelSize];
    }
    return _tipsLabel;
}

- (UIImageView *)tipsIconImage{
    if (!_tipsIconImage){
        _tipsIconImage = [[UIImageView alloc] init];
        [_tipsIconImage setImageWithName:@"tips"];
    }
    return _tipsIconImage;
}

- (UIButton *)openingReminderButton{
    if (!_openingReminderButton){
        _openingReminderButton = [[UIButton alloc] init];
//        [_openingReminderButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _openingReminderButton.titleLabel.font = [UIFont boldSystemFontOfSize:kLotteryWinningTipsViewTitleLabelSize];
        [_openingReminderButton setTitle:@"开启提醒" forState:UIControlStateNormal];
        [_openingReminderButton setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
        [_openingReminderButton setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateHighlighted];
        [_openingReminderButton addTarget:self action:@selector(openingReminderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_openingReminderButton setTitleColor:kUIColorFromRGB10(78,132,239) forState:UIControlStateNormal];
        [_openingReminderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, -5)];
    }
    return _openingReminderButton;
}

#pragma mark -

- (void)openingReminderButtonClick:(UIButton *)button{
    NSLog(@"开启提醒");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
