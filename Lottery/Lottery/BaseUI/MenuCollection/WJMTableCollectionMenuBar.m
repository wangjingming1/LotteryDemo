//
//  WJMTableCollectionMenuBar.m
//  Lottery
//
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollectionMenuBar.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "UILabel+Padding.h"

@interface WJMTableCollectionMenuBar()
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *menuBackView;
@property (nonatomic, strong) UIScrollView *menuScrollView;
@end

@implementation WJMTableCollectionMenuBar
- (instancetype)initWithMenu:(NSString *)menu
{
    return [self initWithMenus:@[menu]];
}

- (instancetype)initWithMenus:(NSArray <NSString *> *)menus
{
    self = [self init];
    if (self) {
        self.menuBarPadding = 0;
        [self setUI];
        [self createMenus:menus];
        
        self.canScroll = NO;
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.menuScrollView];
    [self.menuScrollView addSubview:self.menuBackView];
    [self addSubview:self.bottomLineView];
    
    [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.menuBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setMenuBarPadding:(CGFloat)menuBarPadding {
    _menuBarPadding = menuBarPadding;
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        view.menuNameLabel.padding = UIEdgeInsetsMake(0, menuBarPadding, 0, menuBarPadding);
    }
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    [self reloadLayout];
}

- (void)setMenuViewStyle:(MenuViewStyle)menuViewStyle{
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        view.menuViewStyle = menuViewStyle;
    }
}

- (NSInteger)getSelectedMenuIndex {
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        if (view.selected){
            return view.index;
        }
    }
    return 0;
}

- (void)setSelectedMenu:(NSUInteger)index {
    WJMTableCollectionMenuView *targetView;
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        view.selected = NO;
        if (index == view.index){
            view.selected = YES;
            targetView = view;
        }
    }
    [self selectMenuView:targetView];
}

- (void)createMenus:(NSArray <NSString *> *)menus {
    [self.menuBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < menus.count; i++){
        NSString *menu = menus[i];
        WJMTableCollectionMenuView *menuView = [self createMenuView:menu index:i];
        [self.menuBackView addSubview:menuView];
    }
}

- (void)reloadLayout{
    if (self.menuBackView.subviews.count == 0) return;
    if (self.menuBackView.subviews.count == 1){
        [self.menuBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    } else {
        if (self.canScroll){
            UIView *lastView;
            for (UIView *view in self.menuBackView.subviews){
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (lastView){
                        make.left.mas_equalTo(lastView.mas_right).offset(0);
                    } else {
                        make.left.mas_equalTo(0);
                    }
                }];
                lastView = view;
            }
            [self.menuBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.height.mas_equalTo(self);
            }];
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
        } else {
            [self.menuBackView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [self.menuBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self).multipliedBy(1.0/self.menuBackView.subviews.count);
                make.height.mas_equalTo(self);
                make.top.bottom.mas_equalTo(0);
            }];
        }
    }
}

- (UIView *)bottomLineView{
    if (!_bottomLineView){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = kUIColorFromRGB10(200, 200, 200);
    }
    return _bottomLineView;
}

- (UIView *)menuBackView{
    if (!_menuBackView){
        _menuBackView = [[UIView alloc] init];
    }
    return _menuBackView;
}

- (UIScrollView *)menuScrollView{
    if (!_menuScrollView){
        _menuScrollView = [[UIScrollView alloc] init];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _menuScrollView;
}

- (WJMTableCollectionMenuView *)createMenuView:(NSString *)menu index:(NSUInteger)index{
    WJMTableCollectionMenuView *view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableCollectionMenuBar:menuViewWithIndex:)]){
        view = [self.delegate tableCollectionMenuBar:self menuViewWithIndex:index];
    } else {
        view = [[WJMTableCollectionMenuView alloc] initWithMenuName:menu];
    }
    view.menuNameLabel.text = menu;
    view.index = index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewAction:)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    return view;
}

- (void)menuViewAction:(UITapGestureRecognizer *)tap{
    WJMTableCollectionMenuView *otherView = (WJMTableCollectionMenuView *)tap.view;
    if (otherView.selected){
        return;
    }
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        [view setSelected:otherView == view];
    }
    [self selectMenuView:otherView];
}

- (void)selectMenuView:(WJMTableCollectionMenuView *)menuView{
    [self.menuBackView setNeedsLayout];
    [self.menuBackView layoutIfNeeded];
    CGRect frame = [menuView.superview convertRect:menuView.frame toView:self];
    //相当于前后各增加半个宽度的距离再用来判断相交
    frame.origin.x -= frame.size.width/2;
    frame.size.width += frame.size.width;
    if (!CGRectContainsRect(self.bounds, frame) && CGRectIntersectsRect(frame, self.bounds)){
        CGRect rect = CGRectIntersection(frame, self.bounds);
        CGPoint offset = self.menuScrollView.contentOffset;
        int nextCount = 1;
        if (CGRectGetMinX(frame) - CGRectGetWidth(frame) < CGRectGetMinX(self.bounds)){
            offset.x += CGRectGetMinX(frame) - kPadding10;
            NSArray *array = [self getNextMenuView:menuView nextCount:-nextCount];
            CGFloat nextViewWidths = 0;
            for (UIView *view in array){
                nextViewWidths += CGRectGetWidth(view.frame);
            }
            offset.x -= nextViewWidths;
        } else {
            offset.x += CGRectGetWidth(frame) - CGRectGetWidth(rect) + kPadding10;
            NSArray *array = [self getNextMenuView:menuView nextCount:nextCount];
            CGFloat nextViewWidths = 0;
            for (UIView *view in array){
                nextViewWidths += CGRectGetWidth(view.frame);
            }
            offset.x += nextViewWidths;
        }
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x + CGRectGetWidth(self.menuScrollView.frame) > self.menuScrollView.contentSize.width) {
            offset.x = self.menuScrollView.contentSize.width-CGRectGetWidth(self.menuScrollView.frame);
        }
        [self.menuScrollView setContentOffset:offset animated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(tableCollectionMenuBar:selectTableCollectionMenuView:)]){
        [self.delegate tableCollectionMenuBar:self selectTableCollectionMenuView:menuView];
    }
}

- (NSArray <WJMTableCollectionMenuView *> *)getNextMenuView:(WJMTableCollectionMenuView *)curMenuView nextCount:(int)nextCount{
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 1; i <= nextCount; i++){
        for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
            if (view.index == curMenuView.index + i){
                [array addObject:view];
                break;
            }
        }
        if (array.count == nextCount){
            break;
        }
    }
    
    return array;
}

- (void)reloadMenuBarToFull{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if (CGRectGetWidth(self.menuBackView.frame) < CGRectGetWidth(self.menuScrollView.frame) && self.canScroll){
        CGFloat offset = (CGRectGetWidth(self.menuScrollView.frame) - CGRectGetWidth(self.menuBackView.frame));
        NSInteger count = (self.menuBackView.subviews.count - 1);
        if (count < 1) count = 1;
        CGFloat padding = offset/count;
        self.menuBarPadding += padding/2;
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
