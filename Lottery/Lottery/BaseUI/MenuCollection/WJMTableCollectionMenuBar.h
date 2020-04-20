//
//  WJMTableCollectionMenuBar.h
//  Lottery
//  算奖工具顶部的菜单选项卡(双色球、大乐透)
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollectionMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@class WJMTableCollectionMenuBar, WJMTableCollectionMenuView;

@protocol WJMTableCollectionMenuBarDelegate <NSObject>

@optional 
- (WJMTableCollectionMenuView *)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar menuViewWithIndex:(NSUInteger)index;

- (void)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar selectTableCollectionMenuView:(WJMTableCollectionMenuView *)selectTableCollectionMenuView;

@end

@interface WJMTableCollectionMenuBar : UIView
@property (nonatomic, weak) id<WJMTableCollectionMenuBarDelegate> delegate;
/**
 如果可以滚动,MenuView宽度根据内容自适应宽度(如果可能，MenuBar允许翻页)
 如果不可以滚动，MenuView宽度根据容器宽度及显示个数来均分(保证所有Menu都显示出来)
 */
@property (nonatomic) BOOL canScroll;   //default NO
@property (nonatomic) CGFloat menuBarPadding;   //default 0,内边距,暂时只对左右生效(左右同时增加menuBarPadding)

- (instancetype)initWithMenu:(NSString *)menu;
- (instancetype)initWithMenus:(NSArray <NSString *> *)menus;

- (NSInteger)getSelectedMenuIndex;
- (void)setSelectedMenu:(NSUInteger)index;
- (void)setMenuViewStyle:(MenuViewStyle)menuStyle;

//将内容填满MenuBar(只限内容小于MenuBar时有效)
- (void)reloadMenuBarToFull;
@end

NS_ASSUME_NONNULL_END
