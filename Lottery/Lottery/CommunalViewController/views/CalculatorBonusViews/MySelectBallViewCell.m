//
//  MySelectBallViewCell.m
//  Lottery
//
//  Created by wangjingming on 2020/3/13.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "MySelectBallViewCell.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "LotteryWinningModel.h"
#import "LSVCBallImageView.h"

@interface MySelectBallViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MySelectBallViewCell
+ (NSString *)redCellIdentifier {
    return @"redCellIdentifier";
}

+ (NSString *)blueCellIdentifier {
    return @"blueCellIdentifier";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.layer.borderColor = UIColor.commonSubtitleTintTextColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if ([self.reuseIdentifier isEqualToString:[MySelectBallViewCell redCellIdentifier]]){
        self.backgroundColor = selected ? [LSVCBallImageView getColor:LSVCBallStyle_redBall] : [UIColor clearColor];
    } else if ([self.reuseIdentifier isEqualToString:[MySelectBallViewCell blueCellIdentifier]]){
        self.backgroundColor = selected ? [LSVCBallImageView getColor:LSVCBallStyle_blueBall] : [UIColor clearColor];
        
    }
    self.layer.borderColor = selected ? [UIColor clearColor].CGColor : UIColor.commonSubtitleTintTextColor.CGColor;
    self.titleLabel.textColor = selected ? [UIColor whiteColor] : UIColor.commonSubtitleTintTextColor;
}
@end
