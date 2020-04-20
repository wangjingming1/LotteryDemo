//
//  LSVCBallImageView.h
//  Lottery
//  LSVC(开奖服务) 球视图
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LSVCBallStyle) {
    LSVCBallStyle_redBall, //207,112,86
    LSVCBallStyle_blueBall,//110,152,240
};

@interface LSVCBallImageView : UIImageView
@property (nonatomic) LSVCBallStyle ballStyle;
@property (nonatomic, strong) UILabel *ballTitleLabel;
+ (UIImage *)getImage:(LSVCBallStyle)style;
+ (UIColor *)getColor:(LSVCBallStyle)style;

- (instancetype)initWithBallStyle:(LSVCBallStyle)style ballTitle:(NSString *)ballTitle;
- (void)setBallTitleLabelFontSize:(CGFloat)fontSize;

- (UIImage *)getImage;
- (UIColor *)getColor;

@end

NS_ASSUME_NONNULL_END
