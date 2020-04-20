//
//  LotteryPastPeriodTableViewCell.m
//  Lottery
//
//  Created by wangjingming on 2020/2/28.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPastPeriodTableViewCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "GlobalDefines.h"
#import "LotteryWinningModel.h"
#import "LSVCLotteryWinningView.h"
#import "Masonry.h"

@interface LotteryPastPeriodTableViewCell()
@property (nonatomic, strong)LSVCLotteryWinningView *lotteryWinningView;
@end

@implementation LotteryPastPeriodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.lotteryWinningView];
    [self.lotteryWinningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        kImportantReminder(@"cell使用Masonry布局的话，不要通过子视图来撑cell，由外面来计算，尽量减少系统计算量，否则界面越复杂滑动时越卡顿")
        //这里不能由子视图来撑cell, 由外面自己算
//        make.bottom.mas_equalTo(0);
    }];
    self.hyb_lastViewInCell = self.lotteryWinningView;
}

- (void)setModel:(LotteryWinningModel *)model{
    _model = model;
    [self reloadViewByModel:model];
}

- (void)reloadViewByModel:(LotteryWinningModel *)model{
    self.lotteryWinningView.model = model;
}

- (LSVCLotteryWinningView *)lotteryWinningView{
    if (!_lotteryWinningView){
        _lotteryWinningView = [[LSVCLotteryWinningView alloc] initWithStyle:LSVCLotteryWinningViewStyle_LotteryPastPeriod];
        _lotteryWinningView.userInteractionEnabled = NO;
    }
    return _lotteryWinningView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
