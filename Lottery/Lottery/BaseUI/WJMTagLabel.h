//
//  WJMTagLabel.h
//  Lottery
//  一个小的标签(算奖工具期次选择中的最新标签)
//  Created by wangjingming on 2020/3/10.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, WJMTagLabelStyle) {
    WJMTagLabelStyle_BubblesStyle,  //气泡样式
    WJMTagLabelStyle_RadioStyle,    //单选样式
    WJMTagLabelStyle_TickStyle,     //右上角对勾样式
};

@interface WJMTagLabel : UILabel
@property (nonatomic) WJMTagLabelStyle style;//default WJMTagLabelStyle_bubblesStyle
@property (nonatomic) CGFloat triangleSide; //default is 4
@property (nonatomic) BOOL selected;
@end

NS_ASSUME_NONNULL_END
