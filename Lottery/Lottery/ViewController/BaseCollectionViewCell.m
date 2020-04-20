//
//  BaseCollectionViewCell.m
//  Lottery
//
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "Masonry.h"
#import "GlobalDefines.h"

@implementation BaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = kCornerRadius;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (_titleLabel) return _titleLabel;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
  
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _titleLabel = titleLabel;
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    if (selected) {
//        self.backgroundColor = SELECTEDCOLOR;
//    }else{
//        self.backgroundColor = COMMONCOLOR7;
//    }
}
@end
