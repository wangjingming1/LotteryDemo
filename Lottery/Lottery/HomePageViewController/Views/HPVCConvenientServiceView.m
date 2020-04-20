//
//  HPVCConvenientServiceView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCConvenientServiceView.h"
#import "UIImageView+AddImage.h"
#import "UIView+Color.h"
#import "Masonry.h"
#import "GlobalDefines.h"

#import "CalculatorBonusViewController.h"
#import "LotteryStationViewController.h"
#import "TrendChartViewController.h"
#import "ImitationLotteryViewController.h"

#import "LotteryConvenientServiceModel.h"

/**便捷服务一行4个按钮*/
#define kLineCount 4

static NSInteger ConvenientServiceViewTag = 100;

@interface HPVCConvenientServiceView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) NSMutableArray *subViewItemTypeVecs;
@end

@implementation HPVCConvenientServiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _subViewItemTypeVecs = [@[] mutableCopy];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reloadConvenientServiceView:(NSArray<LotteryConvenientServiceModel *> *)datas{
    [self setModelArray:datas];
    
    [_subViewItemTypeVecs removeAllObjects];
    
    NSMutableArray *tmpArray = [@[] mutableCopy];
    for (LotteryConvenientServiceModel *model in datas){
        [tmpArray addObject:model];
        if (tmpArray.count == kLineCount || model == [datas lastObject]){
            [_subViewItemTypeVecs addObject:[tmpArray copy]];
            [tmpArray removeAllObjects];
        }
    }
    [self reloadView];
}

- (void)reloadView{
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.modelArray || self.modelArray.count == 0) return;
    LotteryConvenientServiceModel *firstModel = [self.modelArray firstObject];
    UIImage *iconImage = [UIImage imageNamed:firstModel.image];
    CGFloat leadSpacing = 20, tailSpacing = 20;
    CGFloat itemPadding = 10;
    CGFloat labelHeight = 20;
    CGFloat itemLength = iconImage.size.height + labelHeight + itemPadding*2;
    UIView *lastView;
    
    //存储每一行view数组(itemTypeViewArray)
    NSMutableArray <NSArray *>*allItemTypeViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *models in _subViewItemTypeVecs){
        //每一行的view数组
        NSMutableArray *itemTypeViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        UIView *itemBackView = [[UIView alloc] init];
        [self.backView addSubview:itemBackView];
        [itemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).offset(-itemPadding);
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(itemLength);
        }];
        for (LotteryConvenientServiceModel *model in models){
            [itemTypeViewArray addObject:[self createConvenientItemView:model padding:itemPadding labelHeight:labelHeight parentView:itemBackView]];
        }
        if (itemTypeViewArray.count == kLineCount){
            [itemTypeViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemLength leadSpacing:leadSpacing tailSpacing:tailSpacing];
        } else if (itemTypeViewArray.count > 0 && allItemTypeViewArray.count > 0){
            for (int i = 0; i < itemTypeViewArray.count; i++){
                UIView *itemView = itemTypeViewArray[i];
                UIView *otherView = allItemTypeViewArray[0][i];
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemLength);
                    make.left.mas_equalTo(otherView.mas_left);
                    make.centerY.mas_equalTo(itemBackView);
                }];
            }
        }
        [allItemTypeViewArray addObject:itemTypeViewArray];
        lastView = itemBackView;
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

- (UIView *)createConvenientItemView:(LotteryConvenientServiceModel *)model padding:(CGFloat)padding labelHeight:(CGFloat)labelHeight parentView:(UIView *)parentView{
    UIView *view = [[UIView alloc] init];
    view.tag = ConvenientServiceViewTag + [self.modelArray indexOfObject:model];
    [parentView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
    }];
    NSString *imageName = model.image;
    [imageView setImageWithName:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *nameLab = [[UILabel alloc] init];
    [view addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).offset(padding/2);
        make.height.mas_equalTo(labelHeight);
        make.bottom.mas_equalTo(-padding);
    }];
    NSString *name = model.title;
    nameLab.text = name;
    nameLab.numberOfLines = 1;
    nameLab.font = [UIFont systemFontOfSize:kSystemFontOfSize];
    nameLab.textColor = UIColor.commonUnselectedTintTextColor;
    nameLab.textAlignment = NSTextAlignmentCenter;
    //初始化一个点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAcyion:)];
    //把点击手势加上
    [view addGestureRecognizer:tap];
    
    return view;
}

- (void)tapAcyion:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        NSInteger count = tap.view.tag - ConvenientServiceViewTag;
        LotteryConvenientServiceModel *model = self.modelArray[count];
        NSString *leftTitle = model.title;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        params[@"leftTitle"] = leftTitle;
        
        NSString *vcClass = model.className;
        [self.delegate pushViewController:NSClassFromString(vcClass) params:params];
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.commonGroupedBackgroundColor;// [UIColor whiteColor];
        _backView.layer.cornerRadius = kCornerRadius;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
