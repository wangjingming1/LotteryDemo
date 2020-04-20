//
//  LotteryRefreshHeaderView.m
//  Lottery
//
//  Created by wangjingming on 2020/2/21.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryRefreshHeaderView.h"

@implementation LotteryRefreshHeaderView

- (void)prepare
{
    [super prepare];
    self.stateLabel.textColor = UIColor.commonTitleTintTextColor;
    self.lastUpdatedTimeLabel.textColor = UIColor.commonTitleTintTextColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
