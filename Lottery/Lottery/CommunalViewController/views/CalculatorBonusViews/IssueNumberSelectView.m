//
//  IssueNumberSelectView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "IssueNumberSelectView.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "WJMTagLabel.h"
#import "LotteryWinningModel.h"

#define kIssueNumberSelectViewCellIdentifier @"issueNumberSelectViewCellIdentifier"

@interface IssueNumberSelectView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@interface IssueNumberCell : UITableViewCell
@property (nonatomic, strong) UILabel *issueNumberLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) WJMTagLabel *newestLabel;
@property (nonatomic, strong) LotteryWinningModel *model;
@property (nonatomic, strong) UIImageView *selectImgV;
@end

@implementation IssueNumberSelectView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = 10;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLocalizedString(@"期次选择");
    

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
        make.height.mas_equalTo(self.tableView.rowHeight*self.count);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);//.offset(-kPadding10);
    }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 40;
        [_tableView registerClass:[IssueNumberCell class] forCellReuseIdentifier:kIssueNumberSelectViewCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:kIssueNumberSelectViewCellIdentifier];
    if (!cell) {
        cell = [[IssueNumberCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kIssueNumberSelectViewCellIdentifier];
    }
    LotteryWinningModel *model = [[LotteryWinningModel alloc] init];
    if (indexPath.row < self.modelArray.count){
        model = self.modelArray[indexPath.row];
    }
    //调整cell分割线
    if (indexPath.row == self.modelArray.count - 1){
        cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.frame), 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    cell.model = model;
    [cell setSelected:self.selectIdx == indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.selectIdx = indexPath.row;
    if (self.selectModel){
        LotteryWinningModel *model = self.modelArray[indexPath.row];
        self.selectModel(model);
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



@implementation IssueNumberCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.issueNumberLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.newestLabel];
    [self.contentView addSubview:self.selectImgV];
    
    [self.issueNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.issueNumberLabel.mas_right).offset(kPadding10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.issueNumberLabel);
    }];
    
    [self.newestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(35, 25));
    }];
    [self.selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-kPadding20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.newestLabel.hidden = YES;
}

- (void)setModel:(LotteryWinningModel *)model {
    _model = model;
    [self reloadIssueNumberCell];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectImgV.hidden = !self.selected;
}

- (void)reloadIssueNumberCell{
    self.issueNumberLabel.text = self.model.issueNumber;
    self.dateLabel.text = [self.model dateToGeneralFormat];
    self.newestLabel.hidden = !self.model.newest;
}

- (UILabel *)issueNumberLabel{
    if (!_issueNumberLabel){
        _issueNumberLabel = [[UILabel alloc] init];
        _issueNumberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        _issueNumberLabel.textColor = UIColor.commonTitleTintTextColor;
    }
    return _issueNumberLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        _dateLabel.textColor = UIColor.commonSubtitleTintTextColor;
    }
    return _dateLabel;
}

- (WJMTagLabel *)newestLabel{
    if (!_newestLabel){
        _newestLabel = [[WJMTagLabel alloc] init];
        _newestLabel.text = kLocalizedString(@"最新");
        _newestLabel.backgroundColor = [UIColor redColor];
        _newestLabel.textColor = [UIColor whiteColor];
        _newestLabel.textAlignment = NSTextAlignmentCenter;
        _newestLabel.font = [UIFont systemFontOfSize:14];
        _newestLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _newestLabel;
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
