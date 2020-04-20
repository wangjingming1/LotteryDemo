//
//  NewsCollectionViewCell.m
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "NewsCollectionViewCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "LotteryNewsModel.h"
#import "UIImageView+AddImage.h"

#define kNCVCellTitleLabelFontSize      kSystemFontOfSize+3
#define kNCVCellTimeLabelFontSize       kSystemFontOfSize-4
#define kNCVCellThumbnailImageViewSize  CGSizeMake(100, 70)

@interface NewsCollectionViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *informationSourcesLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation NewsCollectionViewCell
{
    MASConstraint *_thumbnailImageViewCenterY;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
        kImportantReminder(@"这里由于tableviewCell的size始终默认为CGSizeMake(320, 44),只有界面显示后才会更新为正确的宽度(layoutSubviews方法h中可以获取真实frame),所以这里给了屏幕宽度为默认值")
        frame.size.width = SCREEN_WIDTH;
        self.frame = frame;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.thumbnailImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.informationSourcesLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kPadding15);
        make.right.mas_equalTo(self.thumbnailImageView.mas_left).offset(-kPadding10);
    }];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding15);
        make.size.mas_equalTo(kNCVCellThumbnailImageViewSize);
        make.top.mas_equalTo(self.titleLabel).priority(MASLayoutPriorityDefaultMedium);//设置优先级为中
        _thumbnailImageViewCenterY = make.centerY.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);//设置优先级为高
    }];
    [self.informationSourcesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.informationSourcesLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.informationSourcesLabel);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
        make.right.mas_equalTo(-kPadding15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(LotteryNewsModel *)model{
    _model = model;
    [self reloadViewByModel:model];
}

- (void)reloadViewByModel:(LotteryNewsModel *)model{
    self.titleLabel.text = model.title;
    self.informationSourcesLabel.text = model.informationSources;
    self.timeLabel.text = model.time;
    self.thumbnailImageView.image = nil;
    [self.thumbnailImageView setImageWithName:model.imageUrl];
    
    [self setNeedsLayout];//设置重新布局标记
    [self layoutIfNeeded];//在当前runloop中立即重新布局
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    CGRect informationSourcesLabelFrame = self.informationSourcesLabel.frame;
    CGRect thumbnailImageViewFrame = self.thumbnailImageView.frame;
    
    //如果标题的高度超出了图片的高度
    if (CGRectGetHeight(titleLabelFrame) + kPadding10 > CGRectGetHeight(thumbnailImageViewFrame)){
        self.hyb_bottomOffsetToCell = kPadding15*2 + CGRectGetHeight(informationSourcesLabelFrame);
        [_thumbnailImageViewCenterY install];
        self.hyb_lastViewInCell = self.titleLabel;
    } else {
        [_thumbnailImageViewCenterY uninstall];
        self.hyb_bottomOffsetToCell = kPadding15;
        self.hyb_lastViewInCell = self.thumbnailImageView;
    }
}

//用来更新特殊约束
//- (void)updateConstraints {
//    [super updateConstraints];
//}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.commonTitleTintTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:kNCVCellTitleLabelFontSize];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)informationSourcesLabel{
    if (!_informationSourcesLabel){
        _informationSourcesLabel = [[UILabel alloc] init];
        _informationSourcesLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _informationSourcesLabel.font = [UIFont systemFontOfSize:kNCVCellTimeLabelFontSize];
    }
    return _informationSourcesLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.commonSubtitleTintTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:kNCVCellTimeLabelFontSize];
    }
    return _timeLabel;
}

- (UIImageView *)thumbnailImageView{
    if (!_thumbnailImageView){
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.backgroundColor = [UIColor redColor];
        _thumbnailImageView.layer.cornerRadius = 4;
        _thumbnailImageView.layer.masksToBounds = YES;
    }
    return _thumbnailImageView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColor.commonSubtitleTintTextColor;
    }
    return _bottomLineView;
}
@end
