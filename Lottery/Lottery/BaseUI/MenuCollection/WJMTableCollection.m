//
//  WJMTableCollection.m
//  Lottery
//
//  Created by wangjingming on 2020/3/7.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollection.h"
#import "Masonry.h"
#import "UIView+AttributeExtension.h"
#import "GlobalDefines.h"

@interface WJMTableCollection()<WJMTableCollectionMenuBarDelegate>

@end

@implementation WJMTableCollection

- (instancetype)init{
    self = [super init];
    if (self){
        self.canMenuScroll = NO;
        self.menuBarPadding = 0;
        self.menuBarHeight = 30;
        self.menuBarStyle = MenuView_DividingLine;
    }
    return self;
}

- (void)setTableCollectionMenus:(NSArray <NSString *> *)menus {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.menuBar = [[WJMTableCollectionMenuBar alloc] initWithMenus:menus];
    self.menuBar.canScroll = self.canMenuScroll;
    self.menuBar.menuBarPadding = self.menuBarPadding;
    self.menuBar.delegate = self;
    
    [self.menuBar setSelectedMenu:0];//默认选择第一个
    [self.menuBar setMenuViewStyle:self.menuBarStyle];
    [self addSubview:self.containerView];
    [self addSubview:self.menuBar];
    
    [self.menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.menuBarHeight);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.menuBar.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setMenuBarHeight:(CGFloat)menuBarHeight{
    _menuBarHeight = menuBarHeight;
    [self.menuBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(menuBarHeight);
    }];
}

- (UIView *)containerView{
    if (!_containerView){
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

#pragma mark - WJMTableCollectionMenuBarDelegate
- (void)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar selectTableCollectionMenuView:(WJMTableCollectionMenuView *)selectTableCollectionMenuView{
    if ([self.delegate respondsToSelector:@selector(tableCollectionMenuBar:selectTableCollectionMenuView:)]){
        [self.delegate tableCollectionMenuBar:tableCollectionMenuBar selectTableCollectionMenuView:selectTableCollectionMenuView];
        selectTableCollectionMenuView.containerView.stringTag = @"menuView.containerView";
        UIView *oldView = [self.containerView viewWithStringTag:@"menuView.containerView"];
        [oldView removeFromSuperview];
        [self.containerView addSubview:selectTableCollectionMenuView.containerView];
        [selectTableCollectionMenuView.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0);
        }];
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
