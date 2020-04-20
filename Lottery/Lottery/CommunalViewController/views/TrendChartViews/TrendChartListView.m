//
//  TrendChartListView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "TrendChartListView.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "LotteryKeyword.h"

#define kTrendChartListViewCellIdentifier @"TrendChartListViewCellIdentifier"
@interface TrendChartListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *lotteryIdentifiers;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger selectIdx;
@property (nonatomic, strong) LotteryKeyword *lotteryKeyword;
@end

@interface TrendChartListCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImgV;
- (void)setTitle:(NSString *)title;
@end

@implementation TrendChartListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lotteryKeyword = [[LotteryKeyword alloc] init];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLocalizedString(@"彩种选择");

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kDividingLineColor;
    
    [self addSubview:titleLabel];
    [self addSubview:lineView];
    [self addSubview:self.tableView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.tableView.rowHeight);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);//.offset(-kPadding10);
    }];
}

- (void)setLotteryIdentifiers:(NSArray *)lotteryIdentifiers curIdentifier:(NSString *)curIdentifier{
    self.lotteryIdentifiers = lotteryIdentifiers;
    self.selectIdx = [lotteryIdentifiers indexOfObject:curIdentifier];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tableView.rowHeight*lotteryIdentifiers.count);
    }];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 40;
        [_tableView registerClass:[TrendChartListCell class] forCellReuseIdentifier:kTrendChartListViewCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lotteryIdentifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrendChartListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrendChartListViewCellIdentifier];
    if (!cell) {
        cell = [[TrendChartListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kTrendChartListViewCellIdentifier];
    }
    NSString *identifier = self.lotteryIdentifiers[indexPath.row];
    NSString *title = [self.lotteryKeyword identifierToName:identifier];
    //调整cell分割线
    if (indexPath.row == self.lotteryIdentifiers.count - 1){
        cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.frame), 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    [cell setTitle:title];
    [cell setSelected:self.selectIdx == indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.selectIdx = indexPath.row;
    if (self.selectIdentifier){
        self.selectIdentifier(self.lotteryIdentifiers[indexPath.row]);
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


@implementation TrendChartListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectImgV];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    [self.selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-kPadding20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectImgV.hidden = !self.selected;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        _titleLabel.textColor = UIColor.commonTitleTintTextColor;
    }
    return _titleLabel;
}

- (UIImageView *)selectImgV{
    if (!_selectImgV){
        _selectImgV = [[UIImageView alloc] init];
        _selectImgV.image = [UIImage imageNamed:@"duihaoRed"];
        _selectImgV.hidden = YES;
    }
    return _selectImgV;
}
@end
