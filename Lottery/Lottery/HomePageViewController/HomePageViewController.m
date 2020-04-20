//
//  HomePageViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "HomePageViewController.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "UIView+Color.h"

#import "LotteryBannerView.h"
#import "LSVCLotteryWinningView.h"
#import "LotteryWinningModel.h"

#import "HPVCHeaderView.h"
#import "HPVCConvenientServiceView.h"
#import "HPVCWinningListView.h"
#import "HPVCNewsListView.h"

#import "ProvinceListViewController.h"
#import "UIViewController+Cloudox.h"

#import "HomePageDownloadManager.h"
#import "WebViewController.h"
#import "MJRefresh.h"
#import "LotteryInformationAccess.h"

@interface HomePageViewController ()<UINavigationControllerDelegate, UIScrollViewDelegate, HPVCHeaderViewDelegate, HPVCConvenientServiceViewDelegate, HPVCWinningListViewDelegate, HPVCNewListViewDelegate>
@property (nonatomic, weak) HPVCHeaderView *headerView;
@property (nonatomic, weak) HPVCConvenientServiceView *convenientServiceView;
@property (nonatomic, weak) HPVCWinningListView *winningListView;
@property (nonatomic, weak) HPVCNewsListView *newsListView;
@property (nonatomic, copy) NSString *city;
@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *city = [LotteryInformationAccess getLotteryCurrentCity];
    if (!city || city.length == 0){
        city = @"全国";
    }
    self.city = city;
    [self reloadNavBarLeftTitle];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.headerView){
        [self.headerView.bannerView startTimer];
    }
    [self changeBarImageViewAlpha:self.scrollView.contentOffset.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.delegate = self;
    [self setNavTitleBar];
    [self setUI];
    
    [self reloadNewData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self changeBarImageViewAlpha:MAXFLOAT];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headerView.bannerView pauseTimer];
}

- (void)setNavTitleBar{
    [self changeBarImageViewAlpha:self.scrollView.contentOffset.y];
    kImportantReminder(@"导航栏透明及黑边")
    //设置导航栏背景图片为一个空的image，这样就透明了(设成nil就显示出来了)
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边(设成nil就显示出来了)
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)setUI{
    kImportantReminder(@"设置scrollView内容不由系统自动调整(不考虑导航栏跟状态栏，直接到顶)")
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self initHeaderView];
    [self initConvenientServiceView];
    [self initLotteryWinningListView];
    [self initNewListView];
    
    [self initRefreshViews];
}

- (void)reloadNavBarLeftTitle{
    NSString *leftBtnStr = [NSString stringWithFormat:@"彩票 ● %@  ▼", self.city];
    NSMutableAttributedString *leftBtnAttributedStr = [[NSMutableAttributedString alloc] initWithString:leftBtnStr];
    NSRange range1 = [leftBtnStr rangeOfString:@"●"];
    NSRange range2 = [leftBtnStr rangeOfString:@"▼"];
    NSRange rangeAll = NSMakeRange(0, leftBtnStr.length);
    [leftBtnAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range1];
    [leftBtnAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range2];
    
    [leftBtnAttributedStr addAttribute:NSBaselineOffsetAttributeName value:@(3) range:range1];
    [leftBtnAttributedStr addAttribute:NSBaselineOffsetAttributeName value:@(1) range:range2];
    [leftBtnAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeAll];
    [self setNavBarLeftButtonAttributedTitle:leftBtnAttributedStr];
}

- (NSString *)navBarLeftButtonImage{
    return @"";
}

- (void)initHeaderView{
    CGFloat navBarH = [self getNavigationbarHeight];
    CGFloat headerViewH = 150;
    HPVCHeaderView *headerView = [[HPVCHeaderView alloc] init];
    [self.scrollView addSubview:headerView];
    headerView.delegate = self;
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(navBarH + headerViewH);
    }];
    [headerView.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navBarH);
    }];
    [self.view layoutIfNeeded];
//    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor clearColor]];
//    [headerView setGradationColor:colors startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0)];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"homePageHeaderBG@2x" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    headerView.image = image;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView = headerView;
}

- (void)initConvenientServiceView{
    HPVCConvenientServiceView *csView = [[HPVCConvenientServiceView alloc] init];
    [self.scrollView addSubview:csView];
    csView.delegate = self;
    
    WS(weakSelf);
    [csView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.width.mas_equalTo(weakSelf.view).offset(-kPadding20);
        make.top.mas_equalTo(weakSelf.headerView.mas_bottom).offset(kPadding10);
    }];
    [csView setShadowAndColor:UIColor.commonShadowColor];
    
    self.convenientServiceView = csView;
}

- (void)initLotteryWinningListView{
    HPVCWinningListView *winningListVie = [[HPVCWinningListView alloc] init];
    [self.scrollView addSubview:winningListVie];
    winningListVie.delegate = self;
    
    WS(weakSelf);
    [winningListVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(weakSelf.convenientServiceView);
        make.top.mas_equalTo(weakSelf.convenientServiceView.mas_bottom).offset(kPadding10);
    }];
    [winningListVie setShadowAndColor:UIColor.commonShadowColor];
    
    self.winningListView = winningListVie;
}

- (void)initNewListView{
    HPVCNewsListView *newsListView = [[HPVCNewsListView alloc] init];
    [self.scrollView addSubview:newsListView];
    newsListView.delegate = self;
    
    WS(weakSelf);
    [newsListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(weakSelf.winningListView);
        make.top.mas_equalTo(weakSelf.winningListView.mas_bottom).offset(kPadding10);
    }];
    
    [newsListView setShadowAndColor:UIColor.commonShadowColor];
    self.newsListView = newsListView;
}

- (void)initRefreshViews{
    [self addRefreshHearderView:@selector(reloadNewData) otherScrollView:self.scrollView];
}

- (void)reloadNewData{
    WS(weakSelf);
    [HomePageDownloadManager homePageDownloadData:^(NSDictionary * _Nonnull datas) {
        [weakSelf refreshHomePageView:datas];
    }];
}

- (void)refreshHomePageView:(NSDictionary *)datas{
    NSArray *banners = [datas objectForKey:@"banners"];
    NSArray *convenientServices = [datas objectForKey:@"convenientServices"];
    NSArray *winnings = [datas objectForKey:@"winnings"];
    NSArray *news = [datas objectForKey:@"news"];
    
    [self.headerView reloadBannerView:banners];
    [self.convenientServiceView reloadConvenientServiceView:convenientServices];
    [self.winningListView reloadWinningListView:winnings];
    [self.newsListView reloadNewListView:news];
    
    [self.scrollView.mj_header endRefreshing];
}

- (void)navBarLeftButtonClick:(UIButton *)leftButton{
    ProvinceListViewController *vc = [[ProvinceListViewController alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"leftTitle"] = @"省份列表";
    vc.params = params;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeBarImageViewAlpha:(CGFloat)offset{
    CGFloat minAlphaOffset = 0;//- 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
//    UIView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
//    barImageView.alpha = alpha;
    if (alpha < 0) alpha = 0;
    if (alpha > 1) alpha = 1;
    self.navBarBgAlpha = [NSString stringWithFormat:@"%f", alpha];
}

- (CGFloat)getCurrentAlpha{
    CGFloat minAlphaOffset = 0;//- 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat alpha = (self.scrollView.contentOffset.y - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    return alpha;
}

#pragma mark - scrollViewDelegate
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        [self.convenientServiceView setShadowAndColor:UIColor.commonShadowColor];
        [self.winningListView setShadowAndColor:UIColor.commonShadowColor];
        [self.newsListView setShadowAndColor:UIColor.commonShadowColor];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeBarImageViewAlpha:scrollView.contentOffset.y];
}

#pragma mark - HPVCConvenientServiceViewDelegate
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params{
    [super pushViewController:vcClass params:params];
}

- (void)reloadViewFinish:(UIView *)initiator{
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.newsListView.frame) + 20);
    
    NSLog(@"reloadViewFinish(contentSize.h):%.2f", self.scrollView.contentSize.height);
}

#pragma mark - UINavigationControllerDelegate(由LotteryNavigationController处理自己的代理方法)
// 设置导航控制器的代理为self, 通过代理设置导航栏隐藏
//    self.navigationController.delegate = self;
// 将要显示控制器
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    UIImage *image;
//    if ([viewController isKindOfClass:[self class]]){
//        image = [[UIImage alloc] init];
//    }
//    //设置导航栏背景图片为一个空的image，这样就透明了(设成nil就显示出来了)
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边(设成nil就显示出来了)
//    [self.navigationController.navigationBar setShadowImage:image];
//    self.navigationController.navigationBar.translucent = YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
