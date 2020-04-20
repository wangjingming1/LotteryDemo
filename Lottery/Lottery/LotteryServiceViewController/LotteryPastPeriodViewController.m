//
//  LotteryPastPeriodViewController.m
//  Lottery
//  往期彩票
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "MJRefresh.h"

#import "LotteryPastPeriodViewController.h"
#import "LotteryPastPeriodTableViewCell.h"
#import "LotteryBottomToolsbar.h"
#import "LotteryWinningTipsView.h"

#import "LotteryDownloadManager.h"
#import "LotteryWinningModel.h"
#import "LotteryInformationAccess.h"

#import "GlobalDefines.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "Masonry.h"

#define kLotteryViewControllerCellIdentifier @"LotteryPastPeriodViewControllerIdentifier"
#define kTableViewHeaderViewIdentifierId  @"headerViewId"

@interface LotteryPastPeriodViewController ()<UITableViewDelegate, UITableViewDataSource, LotteryBottomToolsbarDelegate>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UITableView *lotteryTableView;
@property (nonatomic, strong) NSMutableArray *lotteryWinningListArray;
@property (nonatomic) NSInteger lotteryWinningPage;
@property (nonatomic, strong) LotteryBottomToolsbar *bottomToolsbarView;
@property (nonatomic, strong) LotteryWinningTipsView *lotteryWinningTipsView;
@end

@implementation LotteryPastPeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.identifier = [self.params objectForKey:@"identifier"];
    [LotteryInformationAccess setLotteryViewingHistory:self.identifier];
    
    [self initData];
    [self setUI];
    
    [self updateNewdata];
}

- (void)initData{
    self.lotteryWinningListArray = [@[] mutableCopy];
    self.lotteryWinningPage = 0;
}

- (void)setUI{
    [self.backgroundView addSubview:self.lotteryTableView];
    
    CGFloat bottomToolsbarHeight = 50;
    [self.backgroundView addSubview:self.bottomToolsbarView];
    [self.lotteryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomToolsbarHeight);
    }];
    
    [self.bottomToolsbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.lotteryTableView);
        make.top.mas_equalTo(self.lotteryTableView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)reloadLotteryTableViewData{
    if (self.lotteryWinningListArray.count){
        LotteryWinningModel *model = self.lotteryWinningListArray.firstObject;
        self.bottomToolsbarView.identifier = model.identifier;
        self.lotteryWinningTipsView.model = model;
    }
    [self.lotteryTableView reloadData];
    [self.lotteryTableView.mj_footer endRefreshing];
}

- (void)updateNewdata{
    self.lotteryWinningPage = 0;
    [self.lotteryWinningListArray removeAllObjects];
    WS(weakSelf);
    [self reloadData:^{
        [weakSelf reloadLotteryTableViewData];
    }];
}

- (void)getMoreData{
    WS(weakSelf);
    [self reloadData:^{
        [weakSelf reloadLotteryTableViewData];
    }];
}

- (void)reloadData:(void (^)(void))finsh{
    NSInteger count = 10, begin = self.lotteryWinningPage*count;
    WS(weakSelf);
    [LotteryDownloadManager lotteryDownload:begin count:count identifiers:@[self.identifier] finsh:^(NSDictionary<NSString *,NSArray *> * _Nonnull lotteryDict) {
        [weakSelf.lotteryWinningListArray addObjectsFromArray:lotteryDict[weakSelf.identifier]];
        if (begin == 0 && weakSelf.lotteryWinningListArray.count > 1){
            ((LotteryWinningModel *)weakSelf.lotteryWinningListArray[0]).showPrizeView = YES;
        }
        if (finsh) finsh();
    }];
    self.lotteryWinningPage++;
}

- (LotteryBottomToolsbar *)bottomToolsbarView{
    if (!_bottomToolsbarView){
        _bottomToolsbarView = [[LotteryBottomToolsbar alloc] init];
        _bottomToolsbarView.delegate = self;
    }
    return _bottomToolsbarView;
}

- (LotteryWinningTipsView *)lotteryWinningTipsView{
    if (!_lotteryWinningTipsView){
        _lotteryWinningTipsView = [[LotteryWinningTipsView alloc] init];
    }
    return _lotteryWinningTipsView;
}

- (UITableView *)lotteryTableView{
    if (!_lotteryTableView){
        _lotteryTableView = [[UITableView alloc] init];
        kImportantReminder(@"tableViewCell的estimatedRowHeight高度预估建议设高点")
        /*!
         这个预估值建议设高点，过低会导致tableview过多的预估一页能显示的cell个数，
         导致频繁加载及计算cell高度，在Masonry下会明显卡顿
         */
        _lotteryTableView.estimatedRowHeight = 500;
        _lotteryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不使用分割线样式
        _lotteryTableView.rowHeight = UITableViewAutomaticDimension;
        [_lotteryTableView registerClass:[LotteryPastPeriodTableViewCell class] forCellReuseIdentifier:kLotteryViewControllerCellIdentifier];
        _lotteryTableView.delegate = self;
        _lotteryTableView.dataSource = self;

        _lotteryTableView.tableHeaderView = self.lotteryWinningTipsView;
        [self.lotteryWinningTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_lotteryTableView.mas_width);
        }];
        [self addRefreshFooterView:@selector(getMoreData) otherScrollView:self.lotteryTableView];
    }
    return _lotteryTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LotteryPastPeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLotteryViewControllerCellIdentifier];
    if (!cell) {
        cell = [[LotteryPastPeriodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kLotteryViewControllerCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LotteryWinningModel *model = [[LotteryWinningModel alloc] init];
    if (indexPath.row < self.lotteryWinningListArray.count) {
        model = [self.lotteryWinningListArray objectAtIndex:indexPath.row];
    }
    cell.model = model;
    return cell;
}


- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LotteryWinningModel *model = [[LotteryWinningModel alloc] init];
    if (indexPath.row < self.lotteryWinningListArray.count) {
        model = [self.lotteryWinningListArray objectAtIndex:indexPath.row];
    }
    NSString *stateKey = model.showPrizeView ? @"expanded" : @"unexpanded";
    return [LotteryPastPeriodTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        LotteryPastPeriodTableViewCell *cell = (LotteryPastPeriodTableViewCell *)sourceCell;
        // 配置数据
        cell.model = model;
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey: indexPath,
                 kHYBCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 kHYBRecalculateForStateKey : @(NO) // 标识不用重新更新
        };
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lotteryWinningListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LotteryWinningModel *model = self.lotteryWinningListArray[indexPath.row];
    model.showPrizeView = !model.showPrizeView;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.lotteryTableView reloadData];
}

#pragma mark -
- (void)lotteryBottomToolsbar:(LotteryBottomToolsbar *)toolsbar selectTools:(LotteryBottomTools)tools{
    NSLog(@"lotteryBottomToolsbar");
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"identifier"] = self.identifier;
    NSString *classStr = @"";
    if (tools == LotteryBottomTools_trendchart){
        classStr = @"TrendChartViewController";
        params[@"leftTitle"] = kLocalizedString(@"走势图");
    } else if (tools == LotteryBottomTools_calculator){
        classStr = @"CalculatorBonusViewController";
        params[@"leftTitle"] = kLocalizedString(@"算奖工具");
    }
    [self pushViewController:NSClassFromString(classStr) params:params];
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
