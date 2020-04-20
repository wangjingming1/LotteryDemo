//
//  NewsCollectionViewCell.h
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryNewsModel;
@interface NewsCollectionViewCell : UITableViewCell
@property (nonatomic, strong) LotteryNewsModel *model;
@end

NS_ASSUME_NONNULL_END
