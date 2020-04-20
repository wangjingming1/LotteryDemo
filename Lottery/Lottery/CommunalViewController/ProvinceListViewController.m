//
//  ProvinceViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "ProvinceListViewController.h"
#import "Masonry.h"
#import "LotteryCitysManager.h"
#import "LotteryInformationAccess.h"
#import "GlobalDefines.h"
#import "UIView+AttributeExtension.h"

static NSString * const ProvinceListViewCellIdentifier = @"ProvinceListViewCellIdentifier";
@interface ProvinceListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *hearderView;
@property (nonatomic, strong) UITableView *provinceTableView;
@property (nonatomic, strong) NSArray *provinceArray;
@end

@implementation ProvinceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
}

- (void)initData{
    LotteryCitysManager *manager = [[LotteryCitysManager alloc] init];
    self.provinceArray = [manager getProvincesArray];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    
}
- (void)setUI{
    self.provinceTableView = [[UITableView alloc] init];
    self.provinceTableView.rowHeight = 45;
    [self.provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ProvinceListViewCellIdentifier];
    self.provinceTableView.delegate = self;
    self.provinceTableView.dataSource = self;
    self.provinceTableView.backgroundColor = kUIColorFromRGB10(234, 234, 234);
    
    kImportantReminder(@"如果使用delegate来设置tableHeaderView,则tableHeaderView不会跟着cell滚动");
    self.provinceTableView.tableHeaderView = self.hearderView;
    [self.hearderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.provinceTableView);
    }];
    
    [self.backgroundView addSubview:self.provinceTableView];
    [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    kImportantReminder(@"这里需要先更新hearderView的frame再赋值一次,否则tableHeaderView高度不对,会遮挡底部cell")
    [self.hearderView setNeedsLayout];
    [self.hearderView layoutIfNeeded];
//    self.provinceTableView.tableHeaderView = self.hearderView;
}

- (UIView *)hearderView{
    if (!_hearderView){
        _hearderView = [[UIView alloc] init];
//        _hearderView.backgroundColor = kUIColorFromRGB10(234, 234, 234);
        //进到这个界面后,如果有当前城市才显示headerView,否则不显示界面
        NSString *curCity = [LotteryInformationAccess getLotteryCurrentCity];
        NSArray *cityHistoryArray = [LotteryInformationAccess getLotteryCityHistoryArray];
        if (cityHistoryArray.count) {
            UILabel *curLocationLabel = [self createSubTitleLabel:kLocalizedString(@"当前位置")];
            UIButton *curCityButton = [self createCityButton:curCity];
            UILabel *historyLabel = [self createSubTitleLabel:kLocalizedString(@"访问历史")];
            
            [self.hearderView addSubview:curLocationLabel];
            [self.hearderView addSubview:curCityButton];
            [self.hearderView addSubview:historyLabel];
            
            [curLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kPadding20);
                make.top.mas_equalTo(kPadding20);
            }];
            [curCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(curLocationLabel.mas_left);
                make.top.mas_equalTo(curLocationLabel.mas_bottom).offset(kPadding10);
                make.width.mas_equalTo(self.hearderView.mas_width).multipliedBy(1.0/3).offset(-kPadding20);
                make.height.mas_equalTo(35);
            }];
            [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(curLocationLabel);
                make.top.mas_equalTo(curCityButton.mas_bottom).offset(kPadding20);
            }];
            
            UIView *lastView;
            for (NSString *historyCity in cityHistoryArray){
                UIButton *button = [self createCityButton:historyCity];
                [self.hearderView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastView){
                        make.left.mas_equalTo(lastView.mas_right).offset(kPadding10);
                    } else {
                        make.left.mas_equalTo(curCityButton);
                    }
                    make.top.mas_equalTo(historyLabel.mas_bottom).offset(kPadding10);
                    make.width.height.mas_equalTo(curCityButton);
                }];
                lastView = button;
            }
            if (lastView){
                [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-kPadding20);
                }];
            }
        }
    }
    return _hearderView;
}

- (UILabel *)createSubTitleLabel:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.commonSubtitleTintTextColor;
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    return label;
}

- (UIButton *)createCityButton:(NSString *)city{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:city forState:UIControlStateNormal];
    button.stringTag = city;
    button.backgroundColor = UIColor.commonBackgroundColor;// [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:17];

    [button setTitleColor:UIColor.commonTitleTintTextColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6;
    return button;
}

- (void)cityButtonClick:(UIButton *)button{
    [self selectCity:button.stringTag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProvinceListViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:ProvinceListViewCellIdentifier];
    }
    
    NSString *city = self.provinceArray[indexPath.row];
    cell.textLabel.text = city;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *city = self.provinceArray[indexPath.row];
    [self selectCity:city];
}

- (void)selectCity:(NSString *)city{
    [LotteryInformationAccess setLotteryCurrentCity:city];
    [self popViewController];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        [self.provinceTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
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
