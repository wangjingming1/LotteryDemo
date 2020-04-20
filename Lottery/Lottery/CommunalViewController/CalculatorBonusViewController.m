//
//  CalculatorBonusViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "CalculatorBonusViewController.h"
#import "GlobalDefines.h"
#import "CalculatorBonusView.h"
#import "LotteryKindName.h"
#import "WJMTableCollection.h"
#import "LotteryKeyword.h"
#import "Masonry.h"
#import "LotteryDownloadManager.h"
#import "IssueNumberSelectView.h"
#import "MySelectBallView.h"
#import "UIView+AttributeExtension.h"

@interface CalculatorBonusViewController ()<WJMTableCollectionMenuBarDelegate, CalculatorBonusViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) CalculatorBonusView *calculatorBonusView;
@property (nonatomic, strong) WJMTableCollection *menuCollectionView;
@property (nonatomic, strong) NSMutableArray *showCalculatorBonusArray;
@property (nonatomic, strong) LotteryKeyword *lotteryKeyword;
@property (nonatomic, strong) IssueNumberSelectView *issueNumberSelectView;
@property (nonatomic, strong) UIView *otherBackView;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray <LotteryWinningModel *> *> *lotteryData;
@end

@implementation CalculatorBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
    self.identifier = [self.params objectForKey:@"identifier"];
    [self initData];
    [self setUI];
    [self reloadViews];
//    self.navBarLeftButtonTitle = @"算奖工具";
    // Do any additional setup after loading the view.
}

- (void)initData{
    self.lotteryData = [@{} mutableCopy];
    self.showCalculatorBonusArray = [@[kLotteryIdentifier_shuangseqiu, kLotteryIdentifier_daletou] mutableCopy];
    self.lotteryKeyword = [[LotteryKeyword alloc] init];
}

- (void)setUI{
    self.menuCollectionView = [[WJMTableCollection alloc] init];
    self.menuCollectionView.delegate = self;
    NSMutableArray *menus = [@[] mutableCopy];
    for (NSString *ide in self.showCalculatorBonusArray){
        [menus addObject:[self.lotteryKeyword identifierToName:ide]];
    }
    [self.menuCollectionView setTableCollectionMenus:menus];
    self.menuCollectionView.menuBarHeight = 40;

    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = kLocalizedString(@"开奖结果仅供参考，以官方开奖信息为准");
    tipsLab.textColor = UIColor.commonSubTipsTintTextColor;
    tipsLab.font = [UIFont systemFontOfSize:kSubTipsFontOfSize];
    
    [self.backgroundView addSubview:self.menuCollectionView];
    [self.menuCollectionView.containerView addSubview:tipsLab];
    
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuCollectionView.containerView);
        kImportantReminder(@"这里由于没法使用scrollView来做约束,所以使用了scrollView的s父视图来做约束");
        kImportantReminder(@"这里对scrollView做约束实际上与对self.calculatorBonusView做约束效果是一样的,\
                           而calculatorBonusView是被自己子视图撑起来的，所以并不能达到预期效果");
        make.bottom.mas_equalTo(self.menuCollectionView.containerView).offset(-kPadding20);
    }];
}

- (void)reloadViews{
    NSUInteger idx = [self.showCalculatorBonusArray indexOfObject:self.identifier];
    if (idx == NSNotFound){
        idx = 0;
    }
    [self.menuCollectionView.menuBar setSelectedMenu:idx];
}

- (void)reloadCalculatorBonusView:(NSString *)identifier finsh:(void (^)(void))finsh{
    WS(weakSelf);
    [LotteryDownloadManager lotteryDownload:0 count:10 identifiers:@[identifier
    ] finsh:^(NSDictionary<NSString *,NSArray <LotteryWinningModel *>*> * _Nonnull lotteryDict) {
        NSArray<LotteryWinningModel *>*lotteryWinningModels = lotteryDict[identifier];
        weakSelf.lotteryData[identifier] = lotteryWinningModels;
        if (finsh) finsh();
    }];
}

- (CalculatorBonusView *)calculatorBonusView{
    if (!_calculatorBonusView){
        _calculatorBonusView = [[CalculatorBonusView alloc] init];
        _calculatorBonusView.delegate = self;
    }
    return _calculatorBonusView;
}

- (IssueNumberSelectView *)issueNumberSelectView{
    if (!_issueNumberSelectView){
        _issueNumberSelectView = [[IssueNumberSelectView alloc] init];
        _issueNumberSelectView.backgroundColor = [UIColor whiteColor];
    }
    return _issueNumberSelectView;
}

- (UIView *)otherBackView{
    if (!_otherBackView){
        _otherBackView = [[UIView alloc] init];
        _otherBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOtherBackView:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [_otherBackView addGestureRecognizer:tap];
        
        [self.view addSubview:_otherBackView];
        [_otherBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _otherBackView;
}

- (void)tapOtherBackView:(UITapGestureRecognizer *)tap{
    [self removeOtherBackView];
}

- (void)removeOtherBackView{
    [_otherBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_otherBackView removeFromSuperview];
    _otherBackView = nil;
    
    _issueNumberSelectView = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
        if (_otherBackView){
            [self.otherBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }];
        }
    }
}

kImportantReminder(@"由于TableViewCell的点击事件被父视图otherBackView捕获,所以这里做了判断")
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    获取点击视图的类型
    UIView *touchView = touch.view;
    
//    NSString * touchClass = NSStringFromClass([touch.view class]);
////    判断点击视图的类型是不是UITableView的cell类型
//    if ([touchClass isEqualToString:@"UITableViewCellContentView"]) {
////        如果是，返回false
//        return false;
//    }else{
////        如果不是返回true
//        return true;
//    }
    return touchView == _otherBackView;
}

#pragma mark - WJMTableCollectionMenuBarDelegate
- (void)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar selectTableCollectionMenuView:(WJMTableCollectionMenuView *)selectTableCollectionMenuView {
    CalculatorBonusView *calculatorBonusView = (CalculatorBonusView *)[selectTableCollectionMenuView.containerView viewWithStringTag:@"calculatorBonusView"];
    if (!calculatorBonusView){
        [selectTableCollectionMenuView.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        calculatorBonusView = [[CalculatorBonusView alloc] init];
        calculatorBonusView.stringTag = @"calculatorBonusView";
        calculatorBonusView.delegate = self;

        [selectTableCollectionMenuView.containerView addSubview:calculatorBonusView];
        [calculatorBonusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(selectTableCollectionMenuView.containerView);
            make.width.mas_equalTo(selectTableCollectionMenuView.containerView);
        }];
    }
    NSString *ide = self.showCalculatorBonusArray[selectTableCollectionMenuView.index];
    self.identifier = ide;
    
    WS(weakSelf);
    [self reloadCalculatorBonusView:ide finsh:^{
        calculatorBonusView.model = [weakSelf.lotteryData[ide] firstObject];
    }];
}

- (void)tableCollectionSelectIndex:(NSUInteger)index {
    NSString *ide = self.showCalculatorBonusArray[index];
    self.identifier = ide;
    [self reloadCalculatorBonusView:ide finsh:^{
        
    }];
}

#pragma mark - CalculatorBonusViewDelegate
- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showIssueNumberSelector:(void(^)(LotteryWinningModel *newModel))result{
    [self.otherBackView addSubview:self.issueNumberSelectView];
    
    self.issueNumberSelectView.modelArray = self.lotteryData[self.identifier];
    NSInteger selectIdx = [self.issueNumberSelectView.modelArray indexOfObject:calculatorBonusView.model];
    self.issueNumberSelectView.selectIdx = selectIdx;
    
    WS(weakSelf);
    [self.issueNumberSelectView setSelectModel:^(LotteryWinningModel * _Nonnull model) {
        if (result){
            result(model);
            [weakSelf removeOtherBackView];
        }
    }];
    
    [self.issueNumberSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (@available(iOS 11.0, *)) {
        [self.issueNumberSelectView setSafeAreaLayoutGuideBottom:self.view.mas_safeAreaLayoutGuideBottom];
    }
}

- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showMySelectBallSelector:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount result:(void(^)(NSString *newRedCount, NSString *newBlueCount))result{
    [self showMySelectBallView:SelectBallViewStyle model:calculatorBonusView.model oldRedCount:oldRedCount oldBlueCount:oldBlueCount result:result];
}

- (void)calculatorBonusView:(CalculatorBonusView *)calculatorBonusView showMyTargetBallSelector:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount result:(void(^)(NSString *newRedCount, NSString *newBlueCount))result{
    [self showMySelectBallView:TargetBallViewStyle model:calculatorBonusView.model oldRedCount:oldRedCount oldBlueCount:oldBlueCount result:result];
}

- (void)showMySelectBallView:(MySelectBallViewStyle)style model:(LotteryWinningModel *)model oldRedCount:(NSString *)oldRedCount oldBlueCount:(NSString *)oldBlueCount result:(void(^)(NSString *newRedCount, NSString *newBlueCount))result{
    MySelectBallView *mySelectBallView = [[MySelectBallView alloc] initWithStyle:style];
    mySelectBallView.backgroundColor = UIColor.commonGroupedBackgroundColor;//[UIColor whiteColor];
    [self.otherBackView addSubview:mySelectBallView];
    mySelectBallView.model = model;
    [mySelectBallView setOldRedCount:oldRedCount oldBlueCount:oldBlueCount];
    
    WS(weakSelf);
    [mySelectBallView setCancelBlock:^{
        [weakSelf removeOtherBackView];
    }];
    
    [mySelectBallView setFinishBlock:^(NSString * _Nonnull redCount, NSString * _Nonnull blueCount) {
        if (result){
            result(redCount, blueCount);
        }
       [weakSelf removeOtherBackView];
    }];
    [mySelectBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (@available(iOS 11.0, *)) {
        [mySelectBallView setSafeAreaLayoutGuideBottom:self.view.mas_safeAreaLayoutGuideBottom];
    }
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
