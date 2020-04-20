//
//  WJMTableCollectionMenuView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MenuViewStyle) {
    MenuView_DividingLine,      //选择的menu下有分割线的样式
    MenuView_HighlightSelection,//突出选中menu，选中menu字体变大
};

@interface WJMTableCollectionMenuView : UIView
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) UILabel *menuNameLabel;
@property (nonatomic, strong) UIView *selectLineView;

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic) BOOL selected;

@property (nonatomic) MenuViewStyle menuViewStyle;// default MenuView_DividingLine

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *unSelectedColor;

- (instancetype)initWithMenuName:(NSString *)menuName;
@end

NS_ASSUME_NONNULL_END
