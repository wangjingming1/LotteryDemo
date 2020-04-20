//
//  WJMCheckBoxView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMCheckBoxView.h"
#import "GlobalDefines.h"
#import "WJMTagLabel.h"
#import "Masonry.h"
#import "UILabel+Padding.h"

@interface WJMCheckboxBtn()
@property (nonatomic) WJMTagLabelStyle style;
@end

@implementation WJMCheckboxBtn
+ (instancetype)radioBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag{
    WJMCheckboxBtn *btn = [[WJMCheckboxBtn alloc] initRadioBtnStyleWithTitle:title stringTag:stringTag];
    return btn;
}

+ (instancetype)tickBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag{
    WJMCheckboxBtn *btn = [[WJMCheckboxBtn alloc] initTickBtnStyleWithTitle:title stringTag:stringTag];
    return btn;
}

- (instancetype)initRadioBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag{
    self = [self init];
    if (self){
        [self setUI];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.style = WJMTagLabelStyle_RadioStyle;
        [self setTitle:title andStringTag:stringTag];
    }
    return self;
}

- (instancetype)initTickBtnStyleWithTitle:(NSString *)title stringTag:(NSString *)stringTag{
    self = [self init];
    if (self){
        [self setUI];
        self.titleLabel.backgroundColor = UIColor.commonBackgroundColor;
        self.titleLabel.style = WJMTagLabelStyle_TickStyle;
        self.titleLabel.layer.borderColor = kUIColorFromRGB10(227, 227, 227).CGColor;
        [self setTitle:title andStringTag:stringTag];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);//.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    self.titleLabel.padding = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setTitle:(NSString *)title andStringTag:(NSString *)stringTag{
    self.titleLabel.text = title;
    self.stringTag = stringTag;
}

- (WJMTagLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[WJMTagLabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _titleLabel.layer.cornerRadius = 6;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.selected = selected;
    if (self.titleLabel.style == WJMTagLabelStyle_TickStyle){
        self.titleLabel.backgroundColor = selected ? kUIColorFromRGB10(251, 244, 241) : UIColor.commonBackgroundColor;
        self.titleLabel.layer.borderColor = selected ? kUIColorFromRGB10(237, 169, 153).CGColor : kUIColorFromRGB10(227,227,227).CGColor;
    }
}
@end

@interface WJMCheckBoxView()
@property (nonatomic, strong) NSMutableArray *selectCheckboxBtns;
@property (nonatomic, strong) NSMutableArray *allCheckboxBtns;
@end

@implementation WJMCheckBoxView

- (instancetype)initCheckboxBtnBtns:(NSArray <WJMCheckboxBtn *>*)btns{
    self = [self init];
    if (self){
        self.allCheckboxBtns = [btns mutableCopy];
        self.selectCheckboxBtns = [@[] mutableCopy];
        
        self.maximumValue = [btns count];
        for (WJMCheckboxBtn *btn in btns){
            [btn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)selectCheckBoxBtn:(NSString *)stringTag{
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        if ([btn.stringTag isEqualToString:stringTag]) {
            btn.selected = YES;
            [_selectCheckboxBtns addObject:btn];
            return;
        }
    }
}

- (void)selectCheckBoxSingleBtn:(NSString *)stringTag{
    [self deselectAllCheckBtn];
    [self selectCheckBoxBtn:stringTag];
}

- (void)selectAllCheckBtn{
    [_selectCheckboxBtns removeAllObjects];
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        [btn setSelected:YES];
        [_selectCheckboxBtns addObject:btn];
    }
}

- (void)deselectAllCheckBtn{
    for (WJMCheckboxBtn *btn in _selectCheckboxBtns){
        [btn setSelected:NO];
    }
    [_selectCheckboxBtns removeAllObjects];
}

- (void)onButtonClicked:(WJMCheckboxBtn *)btn{
    if (_maximumValue == 1){
        [self deselectAllCheckBtn];
        [btn setSelected:YES];
    }else{
        if (![btn isSelected] && _maximumValue == [_selectCheckboxBtns count])
            return;
        
        [btn setSelected:![btn isSelected]];
    }
    if ([btn isSelected]) {
        [_selectCheckboxBtns addObject:btn];
        if ([self.delegate respondsToSelector:@selector(checkboxView:didSelectItemAtStringTag:)]){
            [self.delegate checkboxView:self didSelectItemAtStringTag:btn.stringTag];
        }
    }
    else{
        [_selectCheckboxBtns removeObject:btn];
        if ([self.delegate respondsToSelector:@selector(checkboxView:didDeselectItemAtStringTag:)]){
            [self.delegate checkboxView:self didDeselectItemAtStringTag:btn.stringTag];
        }
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
