//
//  LotteryServiceViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "LotteryServiceViewController.h"
#import "LSVCLotteryWinningView.h"
#import "LotteryDownloadManager.h"
#import "MJRefresh.h"
#import "UIView+Color.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "LotteryKindName.h"
#import "LSVCViewingHistoryView.h"
#import "LotteryWinningModel.h"
#import "LotteryInformationAccess.h"
#import "UIScrollView+Touch.h"

@interface LotteryServiceViewController ()<LSVCLotteryWinningViewDelegate>
@property (nonatomic, strong) NSArray *identifiers;
@property (nonatomic, strong) LSVCViewingHistoryView *historyView;
@property (nonatomic, strong) NSDictionary <NSString *, NSArray<LotteryWinningModel *> *> *lotteryWinningModelDict;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray<LSVCLotteryWinningView *> *> *lotteryWinningViewDict;
@end

@implementation LotteryServiceViewController
{
    MASConstraint *_historyViewHeight;
}
- (NSString *)navBarLeftButtonImage{
    return @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadHistoryView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLSVCViewingHistory];
    // Do any additional setup after loading the view.
    [self setNavBarLeftButtonTitle:@"开奖服务"];
    [self initData];
    [self setUI];
}

- (void)initData{
    self.identifiers = @[
        kLotteryIdentifier_shuangseqiu,
        kLotteryIdentifier_daletou,
        kLotteryIdentifier_fucai3d,
        kLotteryIdentifier_pailie3,
        kLotteryIdentifier_pailie5,
        kLotteryIdentifier_qixingcai,
        kLotteryIdentifier_qilecai
    ];
    self.lotteryWinningModelDict = @{};
    self.lotteryWinningViewDict = [@{} mutableCopy];
    for (NSString *ide in self.identifiers){
        self.lotteryWinningViewDict[ide] = @[];
    }
}

- (void)setUI{
    WS(weakSelf);
    self.historyView = [[LSVCViewingHistoryView alloc] init];
    [self.historyView setSelectOneLottery:^(NSString * _Nonnull identifier) {
        LotteryWinningModel *model = weakSelf.lotteryWinningModelDict[identifier].firstObject;
        NSMutableDictionary *params = [@{} mutableCopy];
        params[@"leftTitle"] = model.kindName;
        params[@"identifier"] = model.identifier;
        [weakSelf pushViewController:NSClassFromString(@"LotteryPastPeriodViewController") params:params];
    }];
    [self.scrollView addSubview:self.historyView];
    [self reloadHistoryView];
    
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        _historyViewHeight = make.height.mas_equalTo(0);
    }];
    
    [self addRefreshHearderView:@selector(reloadNewData) otherScrollView:self.scrollView];
    [self.scrollView.mj_header beginRefreshing];
}

- (void)reloadHistoryView{
    if (!self.historyView) return;
    NSArray *viewingHistoryArray = [LotteryInformationAccess getLotteryViewingHistoryArray];
    NSArray* reversedArray = [[viewingHistoryArray reverseObjectEnumerator] allObjects];
    [self.historyView setViewingHistory:reversedArray];
    self.historyView.hidden = !reversedArray.count;
    if (self.historyView.hidden) {
        [_historyViewHeight install];
    } else {
        [_historyViewHeight uninstall];
    }
}

- (void)reloadNewData{
    NSInteger begin = 0, count = 1;
    WS(weakSelf);
    [LotteryDownloadManager lotteryDownload:begin count:count identifiers:self.identifiers finsh:^(NSDictionary<NSString *,NSArray *> * _Nonnull lotteryDict) {
        [weakSelf refreshLotterServiceView:lotteryDict];
    }];
}

- (void)refreshLotterServiceView:(NSDictionary <NSString *,NSArray *> *)lotteryDict {
    self.lotteryWinningModelDict = lotteryDict;
    UIView *lastBackView;
    for (NSString *ide in self.identifiers){
        NSMutableArray *array = [self.lotteryWinningViewDict[ide] mutableCopy];
        if (array && array.count > 0 && array.count == lotteryDict[ide].count){
            for (int i = 0; i < array.count && i < lotteryDict[ide].count; i++){
                LSVCLotteryWinningView *view = array[i];
                view.model = lotteryDict[ide][i];
            }
        } else {
            [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [array removeAllObjects];
            
            UIView *backView = [[UIView alloc] init];
            [backView setShadowAndColor:UIColor.commonShadowColor];
            [self.scrollView addSubview:backView];
            
            LSVCLotteryWinningView *lastView;
            for (int i = 0; i < lotteryDict[ide].count; i++){
                LotteryWinningModel *model = lotteryDict[ide][i];
                LSVCLotteryWinningView *view = [[LSVCLotteryWinningView alloc] initWithStyle:LSVCLotteryWinningViewStyle_LotteryService];
                view.delegate = self;
                view.layer.cornerRadius = kCornerRadius;
                view.layer.masksToBounds = YES;
                view.model = model;
                [backView addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastView){
                        make.top.mas_equalTo(lastView.mas_bottom);
                    } else {
                        make.top.mas_equalTo(0);
                    }
                    make.left.right.mas_equalTo(0);
                }];
                lastView = view;
                [array addObject:view];
            }
            if (lastView){
                [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kPadding15);
                make.width.mas_equalTo(self.view.mas_width).offset(-kPadding15*2);
                if (lastBackView){
                    make.top.mas_equalTo(lastBackView.mas_bottom).offset(kPadding15);
                } else {
                    make.top.mas_equalTo(self.historyView.mas_bottom).offset(kPadding15);
                }
            }];
            
            [backView setShadowAndColor:UIColor.commonShadowColor];
            lastBackView = backView;
        }
        self.lotteryWinningViewDict[ide] = array;
    }
    if (lastBackView){
        [lastBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-kPadding20);
        }];
    }
    [self.scrollView.mj_header endRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
