//
//  LSVCViewingHistoryView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/16.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LSVCViewingHistoryView.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "LotteryKeyword.h"
#import "LotteryInformationAccess.h"
#import "UIView+AttributeExtension.h"

@interface LSVCViewingHistoryView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *viewingHistoryView;
@end

@implementation LSVCViewingHistoryView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.viewingHistoryView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kPadding10);
        make.left.mas_equalTo(kPadding10);
    }];
    [self.viewingHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setViewingHistory:(NSArray <NSString *> *) identifierArray {
    [self.viewingHistoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (identifierArray.count == 0) return;
    for (int i = 0; i < identifierArray.count && i < 5; i++){
        NSString *ide = identifierArray[i];
        UIView *view = [self createViewingHistorySubView:ide];
        [self.viewingHistoryView addSubview:view];
    }
    UIView *lastView;
    for (UIView *view in self.viewingHistoryView.subviews){
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            if (lastView){
                make.left.mas_equalTo(lastView.mas_right).offset(kPadding10);
            } else {
                make.left.mas_equalTo(kPadding10);
            }
        }];
        lastView = view;
    }
}

- (UIView *)createViewingHistorySubView:(NSString *)ide{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kUIColorFromRGB10(250, 230, 230);
    view.layer.cornerRadius = 12;
    view.layer.masksToBounds = YES;
    view.stringTag = ide;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedOneLottery:)];
    [view addGestureRecognizer:tap];
    
    LotteryKeyword *keyword = [[LotteryKeyword alloc] init];
    NSString *name = [keyword identifierToName:ide];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.text = name;
    nameLabel.textColor = kUIColorFromRGB10(218, 86, 63);
    nameLabel.userInteractionEnabled = NO;
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    arrowImgV.image = [UIImage imageNamed:@"smallRadArrow_right"];
    arrowImgV.userInteractionEnabled = NO;
    [view addSubview:nameLabel];
    [view addSubview:arrowImgV];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(kPadding10/2);
        make.bottom.mas_equalTo(-kPadding10/2);
    }];
    
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel);
        make.left.mas_equalTo(nameLabel.mas_right);//.offset(kPadding10/2);
        make.right.mas_equalTo(-kPadding10/2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    return view;
}

- (void)selectedOneLottery:(UITapGestureRecognizer *)tap{
    if (self.selectOneLottery){
        self.selectOneLottery(tap.view.stringTag);
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.commonTitleTintTextColor;
        _titleLabel.text = kLocalizedString(@"查看历史");
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIView *)viewingHistoryView{
    if (!_viewingHistoryView){
        _viewingHistoryView = [[UIView alloc] init];
    }
    return _viewingHistoryView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
