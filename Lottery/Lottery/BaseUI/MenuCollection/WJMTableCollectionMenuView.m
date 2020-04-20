//
//  WJMTableCollectionMenuView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollectionMenuView.h"
#import "Masonry.h"
#import "GlobalDefines.h"

@implementation WJMTableCollectionMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
        self.menuViewStyle = MenuView_DividingLine;
        self.selected = NO;
    }
    return self;
}

- (instancetype)initWithMenuName:(NSString *)menuName;
{
    self = [self init];
    if (self) {
        self.menuNameLabel.text = menuName;
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.menuNameLabel];
    [self addSubview:self.selectLineView];
    [self.menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuNameLabel);
        make.width.mas_equalTo(self.menuNameLabel.mas_width).multipliedBy(3/4.0);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setMenuViewStyle:(MenuViewStyle)menuViewStyle{
    _menuViewStyle = menuViewStyle;
    self.selectLineView.hidden = !(menuViewStyle == MenuView_DividingLine);
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    CGFloat menuNameLabelFont = 17;
    if (self.menuViewStyle == MenuView_DividingLine){
        self.selectLineView.backgroundColor = selected ? [UIColor redColor] : [UIColor clearColor];
        self.menuNameLabel.textColor = selected ? UIColor.commonSelectedTintTextColor : UIColor.commonTitleTintTextColor;
        self.menuNameLabel.font = [UIFont systemFontOfSize:menuNameLabelFont];
    } else if (self.menuViewStyle == MenuView_HighlightSelection){
        menuNameLabelFont = selected ? menuNameLabelFont : 15;
        self.menuNameLabel.textColor = selected ? UIColor.commonTitleTintTextColor : UIColor.commonSubtitleTintTextColor;
        self.menuNameLabel.font = selected ? [UIFont boldSystemFontOfSize:menuNameLabelFont] : [UIFont systemFontOfSize:menuNameLabelFont];
    }
}

- (UILabel *)menuNameLabel{
    if (!_menuNameLabel){
        _menuNameLabel = [[UILabel alloc] init];
        _menuNameLabel.textAlignment = NSTextAlignmentCenter;
        _menuNameLabel.textColor = UIColor.commonSelectedTintTextColor;
    }
    return _menuNameLabel;
}

- (UIView *)selectLineView{
    if (!_selectLineView){
        _selectLineView = [[UIView alloc] init];
        _selectLineView.backgroundColor = [UIColor clearColor];
    }
    return _selectLineView;
}

- (UIScrollView *)containerView{
    if (!_containerView){
        _containerView = [[UIScrollView alloc] init];
    }
    return _containerView;
}

@end
