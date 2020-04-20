//
//  TrendChartSettingView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "TrendChartSettingView.h"
#import "LotteryTrendChartSettingModel.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "WJMCheckBoxView.h"
#import "WJMTagLabel.h"

@interface TrendChartSettingView() <WJMCheckBoxViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *settingBackView;
@end

@implementation TrendChartSettingView
- (instancetype)initWithTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        [self setUI];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
    
    UIView *headerView = [self createHeaderView];
    self.settingBackView = [[UIView alloc] init];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kDividingLineColor;
    
    [self addSubview:headerView];
    [self addSubview:self.settingBackView];
    [self addSubview:lineView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.settingBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (UIView *)createHeaderView{
    UIView *headerView = [[UIView alloc] init];
    UIButton *cancelButton = [self createButton:@"" imageName:@"cha" action:@selector(cancelButtonClick:)];
    UIButton *finishButton = [self createButton:@"确定" imageName:@"" action:@selector(finishButtonClick:)];
    [headerView addSubview:cancelButton];
    [headerView addSubview:self.titleLabel];
    [headerView addSubview:finishButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelButton.mas_right);
        make.top.mas_equalTo(kPadding10);
        make.bottom.mas_equalTo(-kPadding10);
        make.right.mas_equalTo(finishButton.mas_left);
    }];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    return headerView;
}

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom{
    [self.settingBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);
    }];
}

- (UIButton *)createButton:(NSString *)title imageName:(NSString *)imageName action:(SEL)action{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColor.commonTitleTintTextColor forState:UIControlStateNormal];
    return button;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.commonTitleTintTextColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setSettingArray:(NSArray<LotterySettingModel *> *)settingArray{
    _settingArray = settingArray;
    [self reloadSettingBackView:settingArray];
}

- (UIView *)settingBackView{
    if (!_settingBackView){
        _settingBackView = [[UIView alloc] init];
    }
    return _settingBackView;
}

- (void)reloadSettingBackView:(NSArray<LotterySettingModel *> *)settingArray{
    [self.settingBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger maxContentCount = 0;
    for (LotterySettingModel *model in settingArray){
        NSArray *contentArray = [model.content componentsSeparatedByString:@","];
        if (contentArray.count > maxContentCount){
            maxContentCount = contentArray.count;
        }
    }
    for (LotterySettingModel *model in settingArray){
        UIView *view = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = model.title;
        titleLabel.textColor = UIColor.commonTitleTintTextColor;
        
        NSMutableArray *checkBoxBtnArray = [@[] mutableCopy];
        
        NSArray *contentArray = [model.content componentsSeparatedByString:@","];
        NSArray *selectContentArray = [model.defaultSelection componentsSeparatedByString:@","];
        for (NSString *content in contentArray){
            WJMCheckboxBtn *btn;
            NSString *title = content;
            if ([model.title isEqualToString:@"期次"]) {
                title = [NSString stringWithFormat:@"%@%@", content, kLocalizedString(@"期")];
            }
            if (model.multipleSelection){
                btn = [WJMCheckboxBtn tickBtnStyleWithTitle:title stringTag:content];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.triangleSide = 15;
            } else {
                btn = [WJMCheckboxBtn radioBtnStyleWithTitle:title stringTag:content];
                if ([content isEqualToString:contentArray.firstObject]){
                    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
                } else if ([content isEqualToString:contentArray.lastObject]){
                    btn.titleLabel.textAlignment = NSTextAlignmentRight;
                } else {
                    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                }
                btn.titleLabel.triangleSide = 8;
            }
            [checkBoxBtnArray addObject:btn];
        }
        
        WJMCheckBoxView *checkBoxView = [[WJMCheckBoxView alloc] initCheckboxBtnBtns:checkBoxBtnArray];
        checkBoxView.stringTag = model.title;
        checkBoxView.delegate = self;
        if (!model.multipleSelection){
            checkBoxView.maximumValue = 1;
        }
        for (NSString *selectContent in selectContentArray){
            [checkBoxView selectCheckBoxBtn:selectContent];
        }
        [view addSubview:titleLabel];
        [view addSubview:checkBoxView];
        [self.settingBackView addSubview:view];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kPadding10);
            make.top.mas_equalTo(kPadding10);
        }];
        [checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kPadding10);
            make.right.mas_equalTo(-kPadding10);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(kPadding10);
            make.bottom.mas_equalTo(0);
        }];
        if (checkBoxBtnArray.count <= 1){
            [checkBoxBtnArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(view.mas_width).multipliedBy(1.0/maxContentCount).offset(-kPadding20);
            }];
        } else {
            [checkBoxBtnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kPadding20 leadSpacing:0 tailSpacing:0];
            [checkBoxBtnArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
        }
    }
    if (self.settingBackView.subviews.count <= 1){
        [self.settingBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    } else {
        [self.settingBackView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [self.settingBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
}

- (void)finishButtonClick:(UIButton *)button{
    if (self.finishBlock){
        self.finishBlock();
    }
}

- (void)cancelButtonClick:(UIButton *)button{
    if (self.cancelBlock){
        self.cancelBlock();
    }
}

- (LotterySettingModel *)findSettingModelByTitle:(NSString *)title{
    for (LotterySettingModel *model in _settingArray){
        if ([model.title isEqualToString:title]){
            return model;
        }
    }
    return nil;
}
#pragma mark - WJMCheckBoxViewDelegate
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didSelectItemAtStringTag:(NSString *)stringTag{
    LotterySettingModel *model = [self findSettingModelByTitle:checkboxView.stringTag];
    if (checkboxView.maximumValue == 1){
        model.defaultSelection = stringTag;
    } else if (![model.defaultSelection containsString:stringTag]){
        model.defaultSelection = [NSString stringWithFormat:@"%@,%@", model.defaultSelection, stringTag];
    }
}

- (void)checkboxView:(WJMCheckBoxView *)checkboxView didDeselectItemAtStringTag:(NSString *)stringTag{
    LotterySettingModel *model = [self findSettingModelByTitle:checkboxView.stringTag];
    NSString *newStr = [NSString stringWithFormat:@",%@", stringTag];
    NSRange range = [model.defaultSelection rangeOfString:newStr];
    if (range.length > 0){
        model.defaultSelection = [model.defaultSelection stringByReplacingOccurrencesOfString:newStr withString:@""];
    } else {
        model.defaultSelection = [model.defaultSelection stringByReplacingOccurrencesOfString:stringTag withString:@""];
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
