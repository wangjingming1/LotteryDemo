//
//  HPVCHeaderView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCHeaderView.h"
#import "LotteryBannerView.h"
#import "AFNetworking.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "LotteryBannerModel.h"

@interface HPVCHeaderView()<LotteryBannerViewDelegate>
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation HPVCHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (LotteryBannerView *)bannerView{
    if (_bannerView) return _bannerView;
    LotteryBannerView *bannerView = [[LotteryBannerView alloc] init];
    bannerView.delegate = self;
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.bottom.mas_equalTo(0);
    }];
    
    
    _bannerView = bannerView;
    return _bannerView;
}

- (void)reloadBannerView:(NSArray *)datas{
    self.modelArray = datas;
    [self reloadBannerImages];
}

- (void)reloadBannerImages{
    NSMutableArray *images = [@[] mutableCopy];
    for (LotteryBannerModel *model in self.modelArray){
        [images addObject:model.image];
    }
    [self.bannerView setImageArray:images];
}

#pragma mark - LotteryBannerViewDelegate
- (void)selectImage:(LotteryBannerView *)bannerView currentImage:(NSInteger)currentImage {
    if (!self.modelArray || self.modelArray.count <= currentImage) return;
    if (!_delegate || ![_delegate respondsToSelector:@selector(pushViewController:params:)]) return;
    
    LotteryBannerModel *model = self.modelArray[currentImage];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[@"leftTitle"] = @"赛事中心";
    params[@"url"] = model.url;
    [self.delegate pushViewController:NSClassFromString(@"WebViewController") params:params];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
