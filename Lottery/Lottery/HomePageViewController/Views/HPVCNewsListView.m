//
//  HPVCNewsListView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCNewsListView.h"
#import "NewsCollectionViewCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "LotteryNewsModel.h"

#import "NewsDownloadManager.h"

#define kHeadLabelFontSize      (kSystemFontOfSize + 5)
#define kFootLabelFontSize      (kSystemFontOfSize - 2)

@interface HPVCNewsListView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *newsView;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation HPVCNewsListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.headLabel];
    [self.backView addSubview:self.newsView];
    [self.backView addSubview:self.footLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kPadding15);
        make.right.mas_equalTo(-kPadding10);
    }];
    [self.newsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headLabel.mas_bottom);
    }];
    [self.footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.newsView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding10);
    }];
}

- (void)reloadNewListView:(NSArray<LotteryNewsModel *> *)datas{
    [self setModelArray:datas];
    [self reloadView];
}

- (void)reloadView{
    [self.newsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView;
    for (LotteryNewsModel *model in self.modelArray){
        NewsCollectionViewCell *view = [[NewsCollectionViewCell alloc] init];
        [view setFrame:CGRectMake(0, 0, SCREEN_WIDTH - kPadding10*2, 44)];
        view.model = model;
        [self.newsView addSubview:view];
        CGFloat height = [view getCellHeight];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.newsView);
            make.height.mas_equalTo(height);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom);
            } else {
                make.top.mas_equalTo(0);
            }
        }];
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.width.mas_equalTo(self.newsView);
            make.height.mas_equalTo(height);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAcyion:)];
        [view addGestureRecognizer:tap];
        
        lastView = view;
        
    }
    if (lastView){
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadViewFinish:)]){
        [self.delegate reloadViewFinish:self];
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
        _backView.layer.cornerRadius = kCornerRadius;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIView *)newsView{
    if (!_newsView){
        _newsView = [[UIView alloc] init];
    }
    return _newsView;
}

- (UILabel *)headLabel{
    if (!_headLabel){
        _headLabel = [[UILabel alloc] init];
        _headLabel.textColor = UIColor.commonUnselectedTintTextColor;
        _headLabel.font = [UIFont boldSystemFontOfSize:kHeadLabelFontSize];
        _headLabel.text = @"彩票资讯";
    }
    return _headLabel;
}

- (UILabel *)footLabel{
    if (!_footLabel){
        _footLabel = [[UILabel alloc] init];
        _footLabel.textColor = UIColor.commonUnselectedTintTextColor;
        _footLabel.font = [UIFont systemFontOfSize:kFootLabelFontSize];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.text = @"查看更多资讯";
        _footLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAcyion:)];
        [_footLabel addGestureRecognizer:tap];
    }
    return _footLabel;
}

- (void)tapAcyion:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (tap.view == _footLabel){
            params[@"leftTitle"] = @"彩票资讯";
            [self.delegate pushViewController:NSClassFromString(@"NewsViewController") params:params];
        } else if ([tap.view isKindOfClass:[NewsCollectionViewCell class]]){
            params[@"url"] = ((NewsCollectionViewCell *)tap.view).model.newsUrl;
            params[@"leftTitle"] = @"资讯详情";
            params[@"y"] = @"-40";
            [self.delegate pushViewController:NSClassFromString(@"WebViewController") params:params];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
