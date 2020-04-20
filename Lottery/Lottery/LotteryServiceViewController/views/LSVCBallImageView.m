//
//  LSVCBallImageView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LSVCBallImageView.h"
#import "GlobalDefines.h"
#import "UIImageView+AddImage.h"
#import "Masonry.h"

@implementation LSVCBallImageView
+ (UIImage *)getImage:(LSVCBallStyle)style{
    if (style == LSVCBallStyle_redBall){
        return [UIImage imageNamed:@"redBall"];
    } else if (style == LSVCBallStyle_blueBall){
        return [UIImage imageNamed:@"blueBall"];
    }
    return [[UIImage alloc] init];
}

+ (UIColor *)getColor:(LSVCBallStyle)style{
    if (style == LSVCBallStyle_redBall){
        return kUIColorFromRGB10(207, 112, 86);
    } else if (style == LSVCBallStyle_blueBall){
        return kUIColorFromRGB10(110, 152, 240);
    }
    return [UIColor whiteColor];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.ballTitleLabel];
        [self.ballTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initWithBallStyle:(LSVCBallStyle)style ballTitle:(NSString *)ballTitle{
    self = [self init];
    if (self){
        self.ballStyle = style;
        self.ballTitleLabel.text = ballTitle;
    }
    return self;
}

- (void)setBallStyle:(LSVCBallStyle)ballStyle{
    _ballStyle = ballStyle;
    if (ballStyle == LSVCBallStyle_redBall){
        [self setImageWithName:@"redBall"];
    } else if (ballStyle == LSVCBallStyle_blueBall){
        [self setImageWithName:@"blueBall"];
    } else {
        [self setImageWithName:@""];
    }
}

- (UIImage *)getImage {
    return [LSVCBallImageView getImage:self.ballStyle];
}

- (UIColor *)getColor {
    return [LSVCBallImageView getColor:self.ballStyle];
}

- (void)setBallTitleLabelFontSize:(CGFloat)fontSize{
    self.ballTitleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (UILabel *)ballTitleLabel{
    if (!_ballTitleLabel){
        _ballTitleLabel = [[UILabel alloc] init];
        _ballTitleLabel.textAlignment = NSTextAlignmentCenter;
        _ballTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _ballTitleLabel.textColor = [UIColor whiteColor];
    }
    return _ballTitleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
